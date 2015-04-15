class puppet_ent_agent::cron inherits puppet_ent_agent {
  $first = fqdn_rand(30)
  $second = fqdn_rand(30) + 30

  cron { 'cron.puppet.onetime':
    command => '/opt/puppet/bin/puppet agent --onetime --no-daemonize --color=false --verbose',
    user    => 'root',
    minute  => [ $first, $second ],
    require => Package['pe-agent'],
  }
}
