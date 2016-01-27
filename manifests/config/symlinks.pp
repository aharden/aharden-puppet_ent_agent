# manages symlinks to PE agent binaries
class puppet_ent_agent::config::symlinks {
  $bin_path                = $::puppet_ent_agent::bin_path

  assert_private()

  File {
    ensure => link,
  }

  file { '/usr/bin/facter':
    target => "${bin_path}/facter",
  }

  file { '/usr/bin/hiera':
    target => "${bin_path}/hiera",
  }

  file { '/usr/bin/puppet':
    target => "${bin_path}/puppet",
  }

  file { '/usr/bin/pe-man':
    target => "${bin_path}/pe-man",
  }
}
