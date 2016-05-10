# manages pe-puppet service state
class puppet_ent_agent::service {
  $service_name            = $::puppet_ent_agent::service_name

  assert_private()

  unless $::operatingsystem == 'Solaris' {
    service { $service_name:
      ensure => running,
      enable => true,
    }
  }
}
