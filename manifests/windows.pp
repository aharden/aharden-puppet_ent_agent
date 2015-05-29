# Windows package installation
# The Windows pe-agent files are not hosted in pe_repo, so we use a UNC share
#  to hold the PE agent MSIs, which are installed by the Windows package
#  provider
# Note: Must use 32-bit installer on Windows Server 2003 64-bit:
#  https://docs.puppetlabs.com/pe/latest/install_windows.html#installdir
# Note: PE has only a 32-bit installer until v3.7.0
# Includes code from https://forge.puppetlabs.com/opentable/puppetversion
# (Thanks, opentable!)
class puppet_ent_agent::windows inherits puppet_ent_agent {
  $master           = $::puppet_ent_agent::master
  $version          = $::puppet_ent_agent::version
  $windows_source   = $::puppet_ent_agent::windows_source
  $windows_task_min = $::puppet_ent_agent::windows_task_min

  $windows_cmd = 'C:/Windows/Temp/installPEagent.cmd'

  case $::architecture {
    'x86': {
      $package_msi  = "puppet-enterprise-${version}.msi"
    }
    'x64': {
      # only 32-bit installers on PE 3.3.2 and earlier
      if versioncmp($version,'3.3.2') <= 0 {
        $package_msi  = "puppet-enterprise-${version}.msi"
      }
      else {
        case $::kernelversion {
          '5.2.3790': { # must install 32-bit on WS2003 x64
            $package_msi  = "puppet-enterprise-${version}.msi"
          }
          default: {
            $package_msi  = "puppet-enterprise-${version}-x64.msi"
          }
        }
      }
    }
    default: {
      notify { "Unsupported Windows architecture ${::architecture}.": }
    }
  }

  if $::pe_version != $version {
    # run upgrade outside of pe_agent run

    file { 'UpgradePEAgent script':
      ensure  => file,
      path    => $windows_cmd,
      content => template("${module_name}/installPEagent.cmd.erb"),
    }

    # Using another powershell script to create a scheduled task to run the upgrade script.
    #
    # The scheduled_task resource is not being used here because there is no way to pass
    # local time to the start_time parameter. Using the strftime from stdlib will use the
    # time at catalog compilation (the time of the master) which will cause problems if you
    # clients run in a differne timezone to the master

    file { 'ScheduleTask script':
      ensure  => present,
      path    => 'C:/Windows/Temp/ScheduledTask.ps1',
      content => template("${module_name}/ScheduledTask.ps1.erb"),
      require => File['UpgradePEAgent script'],
      notify  => Exec['create scheduled task'],
    }

    exec { 'create scheduled task':
      command     => 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -File C:\Windows\Temp\ScheduledTask.ps1 -ensure present',
      require     => File['ScheduleTask script'],
      refreshonly => true,
    }
  } else {
    # clean up
    file { 'UpgradePEAgent script':
      ensure => absent,
      path   => $windows_cmd,
    }

    # Yes we still have to exec to remove because scheduled_task { ensure => absent } doesn't work!
    exec { 'remove scheduled task':
      command => 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -File C:\Windows\Temp\ScheduledTask.ps1 -ensure absent',
      before  => File['ScheduleTask script'],
      onlyif  => 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -File C:\Windows\Temp\ScheduledTask.ps1 -exists True'
    }

    file { 'ScheduleTask script':
      ensure => absent,
      path   => 'C:/Windows/Temp/ScheduledTask.ps1',
    }
  }
}
