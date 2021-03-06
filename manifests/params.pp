# Class: puppet_ent_agent::params
#
# This class manages PE agent parameters
#
# Parameters:
# - $config: path to configuration file
# - $ensure: desired ensure/version for pe-agent package
# - $master: PE master with agent files for upgrades (pe_repo server)
# - $agent_server: PE compile master
# - $agent_caserver: PE certificate authority (CA) server
# - $agent_fileserver: PE filebucket server
# - $agent_environment: desired default environment
# - $agent_splay: enable splay on the agent
# - $agent_remove_modulepath: remove the deprecated modulepath setting from puppet.conf
# - $manage_symlinks: create symlinks in /usr/bin
# - $staging_dir: temp directory to use on non-Windows servers
# - $timeout: time to wait for agent installation to finish on Unix/Linux
# - $windows_source: UNC path to file share hosting Windows PE MSI installers
# _ $windows_task_min: (int) will schedule a task to run upgrade in x mins
# - $version: must pass version number for PE windows package provider and AIX
#   and Solaris install methods - defaults to current PE agent version
#
# Actions:
#
# Requires:
# - pe_repo classes for the configured OS families and architectures must be
#   assigned to the server(s) that will respond as $master
#   - $settings::server (default) is resolved on the Puppet master.
#   - This could be a single PE master, or a pool of PE masters behind a
#     load-balancer.
#
# Sample Usage:
#
class puppet_ent_agent::params {
  $config                  = "${::puppet_confdir}/puppet.conf"
  $curl_path               = '/usr/bin/curl'
  $ensure                  = 'present'
  $master                  = $::settings::server
  $agent_server            = undef
  $agent_caserver          = undef
  $agent_fileserver        = undef
  $agent_environment       = 'production'
  $agent_splay             = undef
  $agent_remove_modulepath = false
  $staging_dir             = '/tmp/puppet_ent_agent'
  $timeout                 = 900
  $windows_source          = undef
  $windows_task_min        = '10' # run a scheduled task to upgrade PE agent in x mins
  $manage_symlinks         = true

  # determine agent type
  if versioncmp($::puppetversion, '4.0.0') > 0 { # All-in-one agent
    $bin_path     = '/opt/puppetlabs/bin'
    $service_name = 'puppet'
    $skip_install = true
    $skip_service = false
  } else {      # PE 3.x agent
    $bin_path     = '/opt/puppet/bin'
    $service_name = 'pe-puppet'
    $skip_install = false
    if $::osfamily == 'Solaris' {
      $skip_service = true
    } else {
      $skip_service = false
    }
  }
}
