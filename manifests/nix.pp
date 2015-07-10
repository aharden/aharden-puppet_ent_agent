# Unix/Linux agent installation
# We use a modification of the PE curl-based installation
class puppet_ent_agent::nix inherits puppet_ent_agent {
  $staging_dir = $::puppet_ent_agent::staging_dir
  $version     = $::puppet_ent_agent::ensure

  $group = 'root'

  case $::osfamily {
    'AIX':     {
      $group = 'system'
      $os = 'aix'
      }
    'Debian':  {
      case $::platform_tag {
        'ubuntu-14.04-i386','ubuntu-14.04-amd64' : { $os = 'ubuntu-14' }
        default : {
          notify { "Unsupported Debian platform ${::platform_tag}.": }
        }
      }
    }
    'Solaris': {
      case $::platform_tag {
        'solaris-10-i386','solaris-10-sparc' : { $os = 'solaris-10'}
        'solaris-11-i386','solaris-11-sparc' : { $os = 'solaris-11'}
        default : {
          notify { "Unsupported Solaris platform ${::platform_tag}.": }
        }
      }
    }
  }

  if $::pe_version != $version {

    file { $staging_dir:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0755',
    }

    file { "${staging_dir}/${os}-install.bash":
      ensure  => file,
      owner   => 'root',
      group   => 'system',
      mode    => '0644',
      content => template("${module_name}/${os}-install.bash.erb"),
    } ->
    exec { "/bin/bash -e ${staging_dir}/${os}-install.bash":
      user => 'root',
    }
  }
}
