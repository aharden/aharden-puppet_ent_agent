# Windows package installation
# The Windows pe-agent files are not hosted in pe_repo, so we use a UNC share
#  to hold the PE agent MSIs, which are installed by the Windows package
#  provider
# Note: Must use 32-bit installer on Windows Server 2003 64-bit:
#  https://docs.puppetlabs.com/pe/latest/install_windows.html#installdir
# Note: PE has only a 32-bit installer until v3.7.0
class puppet_ent_agent::windows inherits puppet_ent_agent {
  $master         = $::puppet_ent_agent::master
  $version        = $::puppet_ent_agent::version
  $windows_source = $::puppet_ent_agent::windows_source

  case $::architecture {
    'x86': {
      $package_msi  = "puppet-enterprise-${version}.msi"
      $package_name = 'Puppet Enterprise'
    }
    'x64': {
      # only 32-bit installers on PE 3.3 and earlier
      $version_array = split($version, '[.]')
      if ($version_array[0] <= '3' and $version_array[1] <= '3') {
        $package_msi  = "puppet-enterprise-${version}.msi"
        $package_name = 'Puppet Enterprise'
      }
      else {
        case $::kernelversion {
          '5.2.3790': { # must install 32-bit on WS2003 x64
            $package_msi  = "puppet-enterprise-${version}.msi"
            $package_name = 'Puppet Enterprise'
          }
          default: {
            $package_msi  = "puppet-enterprise-${version}-x64.msi"
            $package_name = 'Puppet Enterprise (64-bit)'
          }
        }
      }
    }
    default: {
      notify { "Unsupported Windows architecture ${::architecture}.": }
    }
  }

  package { $package_name:
    ensure          => $version,
    source          => "${windows_source}\\${package_msi}",
    install_options => ["PUPPET_MASTER_SERVER=${master}"],
  }
}
