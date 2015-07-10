# manages upgrades of Puppet Enterprise agent when needed
class puppet_ent_agent::install inherits puppet_ent_agent {
  $ensure         = $::puppet_ent_agent::ensure
  $windows_source = $::puppet_ent_agent::windows_source

  include ::puppet_ent_agent::repo

  case $::osfamily {
    'AIX','Solaris','Windows': {
      if ($ensure != 'present') and ($ensure != 'latest') {
        case $::osfamily {
          'AIX':     { include ::puppet_ent_agent::aix }
          'Solaris': { include ::puppet_ent_agent::solaris }
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
    'Debian','RedHat' : {
      package { 'pe-agent':
        ensure  => $ensure,
      }
    }
    default: {
      notify { "Unsupported OS family ${::osfamily}.": }
    }
  }
}
