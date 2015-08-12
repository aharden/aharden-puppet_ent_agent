# manages symlinks to PE agent binaries
class puppet_ent_agent::config::symlinks {
  File {
    ensure => link,
  }

  file { '/usr/bin/facter':
    target => '/opt/puppet/bin/facter',
  }

  file { '/usr/bin/hiera':
    target => '/opt/puppet/bin/hiera',
  }

  file { '/usr/bin/puppet':
    target => '/opt/puppet/bin/puppet',
  }

  file { '/usr/bin/pe-man':
    target => '/opt/puppet/bin/pe-man',
  }
}
