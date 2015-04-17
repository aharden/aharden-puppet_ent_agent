# pe_agent::repo class determines and then contains
# the appropriate platform specific repo needed for
# the target agent platform
#
# if the platform doesn't support a repository, it
# is skipped
class puppet_ent_agent::repo inherits puppet_ent_agent {
  case $::osfamily {
    'RedHat': {
      # yumrepo on PE 3.3 doesn't support proxy => _none_ - PUP-2271
      if ($::pe_major_version == '3' and $::pe_minor_version == '3') {
        file { '/etc/yum.repos.d/pe_repo.repo':
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => template("${module_name}/pe_repo.repo.erb"),
        }
      } else {
        contain puppet_ent_agent::yum
      }
    }
    'Debian': { contain puppet_ent_agent::apt }
    default:  {}
  }
}
