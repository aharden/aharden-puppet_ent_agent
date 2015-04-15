class puppet_ent_agent::install inherits puppet_ent_agent {
  include ::puppet_ent_agent::repo

  case $::osfamily {
    'AIX':     { include ::puppet_ent_agent::aix }
    'Debian','RedHat': {
      package { 'pe-agent':
        ensure  => $package_ensure,
      }
    }
    'Solaris': { include ::puppet_ent_agent::solaris }
    'windows': {
      if $windows_source {
        include ::puppet_ent_agent::windows
      }
      else {
        notify { 'Windows repository not available: source not defined.': }
      }
    default: {
      notify { "Unsupported OS family ${::osfamily}.": }
    }
  }
}
