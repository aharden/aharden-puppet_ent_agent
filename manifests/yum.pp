# manages yumrepo for RH-Linux-based pe_repos
# note that bug PUP-2271 prevents setting yumrepo proxy "none" with PE <= 3.3
class puppet_ent_agent::yum inherits puppet_ent_agent {
  $ensure    = $::puppet_ent_agent::ensure
  $master    = $::puppet_ent_agent::master
  $repo_name = 'puppetlabs-pepackages'

  case $ensure {
    'latest' : { $version = 'current' }
    default  : { $version = $ensure }
  }

  Yumrepo {
    baseurl   => "https://${master}:8140/packages/${version}/${::platform_tag}",
    descr     => "Puppet Labs PE Packages version: ${version}",
    enabled   => true,
    ensure    => present,
    gpgcheck  => true,
    gpgkey    => "https://${master}:8140/packages/GPG-KEY-puppetlabs",
    sslverify => 'False',
    before    => Package['pe-agent'],
  }

  # accomodate bug PUP-2271
  if ($::pe_major_version <= '3' and $::pe_minor_version <= '3') {
    yumrepo { $repo_name: }
    ini_file { "/etc/yum.repos.d/${repo_name}.repo":
      ensure  => present,
      section => $repo_name,
      setting => 'proxy',
      value   => '_none_',
      require => Yumrepo[$repo_name],
    }
  } else {
    yumrepo { $repo_name:
      proxy => '_none_',
    }
  }
}
