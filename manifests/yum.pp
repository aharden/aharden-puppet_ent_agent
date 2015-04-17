class puppet_ent_agent::yum inherits puppet_ent_agent {
  File_line['patch bug PUP-2271'] -> Yumrepo['puppetlabs-pepackages']

  if $package_ensure == 'latest' {
    $package_version = 'current'
  } else {
    $package_version = $package_ensure
  }

  #patch bug PUP-2271 if it's there on PE 3.3 by updating yumrepo.rb
  if ($::pe_major_version == '3' and $::pe_minor_version == '3') {
    file { 'patch bug PUP-2271':
      ensure => 'file',
      path   => '/opt/puppet/lib/ruby/site_ruby/1.9.1/puppet/type/yumrepo.rb',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => "puppet:///modules/${module_name}/puppet-enterprise.gpg.key",
    }
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
