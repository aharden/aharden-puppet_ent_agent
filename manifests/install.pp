# manages upgrades of Puppet Enterprise agent when needed
class puppet_ent_agent::install inherits puppet_ent_agent {
  $ensure         = $::puppet_ent_agent::ensure
  $windows_source = $::puppet_ent_agent::windows_source

  if $ensure != 'present' {
    include ::puppet_ent_agent::repo

    case $::osfamily {
      'AIX','Debian','Solaris','Windows': {
        if $ensure != 'latest' {
          case $::osfamily {
            'AIX','Debian','Solaris': { include ::puppet_ent_agent::nix }
            #'Solaris': { include ::puppet_ent_agent::solaris }
            'windows': {
              if $windows_source {
                include ::puppet_ent_agent::windows
              }
              else {
                notify { 'Windows repository not available: source not defined.': }
              }
            }
            default: {}
          }
        }
        else {
          notify { "Must specify PE agent version on ${::osfamily}": }
        }
      }
      'RedHat' : {
        package { 'pe-agent':
          ensure  => $ensure,
        }
      }
      default: {
        notify { "Unsupported OS family ${::osfamily}.": }
      }
    }
  }
}
