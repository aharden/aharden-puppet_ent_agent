# Download bash script from pe_repo and run it
class puppet_ent_agent::install::nix inherits puppet_ent_agent {
  $master      = $::puppet_ent_agent::master
  $staging_dir = $::puppet_ent_agent::staging_dir
  $version     = $::puppet_ent_agent::ensure

  include wget

  case $::osfamily {
    'AIX':   { $group = 'system' }
    default: { $group = 'root' }
  }

  if $::pe_version != $version {

    file { $staging_dir:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0755',
    }

    wget::fetch { 'download PE agent install.bash':
      source             => "https://${master}:8140/packages/${version}/${::platform_tag}.bash",
      destination        => "${staging_dir}/install.bash",
      timeout            => 0,
      verbose            => false,
      nocheckcertificate => true,
    } ->
    exec { "/bin/bash -e ${staging_dir}/install.bash":
      user => 'root',
    }
  }
}
