# manages pe-puppet service state
class puppet_ent_agent::service {
  service { 'pe-puppet':
    ensure => running,
    enable => true,
  }
}
