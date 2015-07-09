# AIX agent installation
# AIX doesn't support pe-agent as a package, so we use a modification of
#  the PE curl-based installation
class puppet_ent_agent::aix inherits puppet_ent_agent {
  $staging_dir = $::puppet_ent_agent::staging_dir
  $version     = $::puppet_ent_agent::package_ensure

  if $::pe_version != $version {

    file { $staging_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'system',
      mode   => '0755',
    }

    file { "${staging_dir}/aix-install.bash":
      ensure  => file,
      owner   => 'root',
      group   => 'system',
      mode    => '0644',
      content => template("${module_name}/aix-install.bash.erb"),
    } ->
    exec { "/bin/bash -e ${staging_dir}/aix-install.bash":
      user => 'root',
    }
  }
}
