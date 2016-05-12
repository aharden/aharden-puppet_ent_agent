# Download bash script from pe_repo and run it
class puppet_ent_agent::install::nix {
  $curl_path    = $::puppet_ent_agent::curl_path
  $master       = $::puppet_ent_agent::master
  $staging_dir  = $::puppet_ent_agent::staging_dir
  $version      = $::puppet_ent_agent::ensure
  $install_file = "${staging_dir}/install.bash"
  $install_cmd  = "/bin/bash -e ${install_file}"
  $source       = "https://${master}:8140/packages/${version}/${::platform_tag}.bash"

  include wget

  assert_private()

  case $::osfamily {
    'AIX': {
      $group      = 'system'
      $use_curl   = true
      $use_curl_k = false
    }
    'Solaris': {
      $group      = 'root'
      $use_curl   = true
      $use_curl_k = true
    }
    default: {
      $group    = 'root'
      $use_curl = false
    }
  }

  if (versioncmp($version,$::pe_version) > 0) {

    file { $staging_dir:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0755',
    }

    if $use_curl {
      if $use_curl_k {
        exec { "${curl_path} -k -1 -sLo \"${install_file}\" \"${source}\"":
          user   => 'root',
          before => Exec[$install_cmd],
        }
      } else {
        exec { "${curl_path} -1 -sLo \"${install_file}\" \"${source}\"":
          user   => 'root',
          before => Exec[$install_cmd],
        }
      }
    } else {
      wget::fetch { 'download PE agent install.bash':
        source             => $source,
        destination        => $install_file,
        timeout            => 0,
        redownload         => true,
        verbose            => false,
        flags              => ['--secure-protocol=TLSv1'],
        nocheckcertificate => true,
        before             => Exec[$install_cmd],
      }
    }

    exec { $install_cmd:
      user => 'root',
    }
  }
}
