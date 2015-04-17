# manages yumrepo for RH-Linux-based pe_repos
# note that bug PUP-2271 makes this incompatible with PE 3.3
class puppet_ent_agent::yum inherits puppet_ent_agent {
  $master         = $::puppet_ent_agent::master
  $package_ensure = $::puppet_ent_agent::package_ensure

  if $package_ensure == 'latest' {
    $package_version = 'current'
  } else {
    $package_version = $package_ensure
  }

  yumrepo { 'puppetlabs-pepackages':
    baseurl   => "https://${master}:8140/packages/${package_version}/${::platform_tag}",
    descr     => "Puppet Labs PE Packages version: ${package_version}",
    enabled   => true,
    gpgcheck  => true,
    gpgkey    => "https://${master}:8140/packages/GPG-KEY-puppetlabs",
    proxy     => '_none_',
    sslverify => 'False',
    before    => Package['pe-agent'],
  }
}
