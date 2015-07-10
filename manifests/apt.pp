# manages apt repo based on debian/ubuntu pe_repos
class puppet_ent_agent::apt inherits puppet_ent_agent {
  $ensure       = $::puppet_ent_agent::ensure
  $master       = $::puppet_ent_agent::master
  $repo_name    = $::puppet_ent_agent::repo_name
  $repo_version = $::puppet_ent_agent::repo_version

  if $ensure == 'latest' { $repo_version = 'current' }

  file { '/etc/apt/puppet-enterprise.gpg.key':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/puppet-enterprise.gpg.key",
  }

  apt_key { $repo_name:
    ensure => 'present',
    id     => '4BD6EC30',
    source => '/etc/apt/puppet-enterprise.gpg.key',
  }

  apt::conf { $repo_name:
    priority => '90',
    content  => template("${module_name}/apt.conf.erb"),
  }

  apt::source { $repo_name:
    location => "https://${master}:8140/packages/${repo_version}/${::platform_tag}",
    repos    => './',
    include  => {
      'src' => false,
    },
    release  => $::lsbdistcodename,
    before    => Package['pe-agent'],
  }
}
