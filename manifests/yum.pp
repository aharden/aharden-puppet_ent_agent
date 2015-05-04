# manages yumrepo for RH-Linux-based pe_repos
# note that bug PUP-2271 prevents setting yumrepo proxy "none" with PE <= 3.3
class puppet_ent_agent::yum inherits puppet_ent_agent {
  $master         = $::puppet_ent_agent::master
  $package_ensure = $::puppet_ent_agent::package_ensure

  if $package_ensure == 'latest' {
    $package_version = 'current'
  } else {
    $package_version = $package_ensure
  }

  Yumrepo {
    baseurl   => "https://${master}:8140/packages/${package_version}/${::platform_tag}",
    descr     => "Puppet Labs PE Packages version: ${package_version}",
    enabled   => false,
    ensure    => absent,
    gpgcheck  => true,
    gpgkey    => "https://${master}:8140/packages/GPG-KEY-puppetlabs",
    sslverify => 'False',
    before    => Package['pe-agent'],
  }

  # accomodate bug PUP-2271
  if ($::pe_major_version <= '3' and $::pe_minor_version <= '3') {
    yumrepo { 'puppetlabs-pepackages': }
  } else {
    yumrepo { 'puppetlabs-pepackages':
      proxy => '_none_',
    }
  }
}
