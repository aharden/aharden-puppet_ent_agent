# pe_agent::repo class determines and then contains
# the appropriate platform specific repo needed for
# the target agent platform
#
# if the platform doesn't support a repository, it
# is skipped
class puppet_ent_agent::repo inherits puppet_ent_agent {
  case $::osfamily {
    #'Debian': { contain puppet_ent_agent::apt }
    'Redhat': { contain puppet_ent_agent::yum }
    default:  {}
  }
}
