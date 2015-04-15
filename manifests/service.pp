# manages pe-puppet service state
class puppet_ent_agent::service inherits puppet_ent_agent {
  service { 'pe-puppet':
    ensure => running,
    enable => true,
  }
}
