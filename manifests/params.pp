# Class: pe_agent::params
#
# This class manages PE agent parameters
#
# Parameters:
# - $config: path to configuration file
# - $package_ensure: desired ensure for pe-agent package
# - $master: PE master with agent files for upgrades (pe_repo server)
# - $agent_server: PE compile master
# - $agent_caserver: PE certificate authority (CA) server
# - $agent_fileserver: PE filebucket server
# - $agent_environment: desired default environment
# - $staging_dir: temp directory to use on AIX/Solaris
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
  if $::osfamily == 'windows' {
    $appdata = regsubst($::common_appdata,'\\','/','G')
    $config = "${appdata}/PuppetLabs/puppet/etc/puppet.conf"
  }
  else {
    $config = '/etc/puppetlabs/puppet/puppet.conf'
  }
  $ensure            = 'latest'
  $master            = $::settings::server
  $agent_server      = undef
  $agent_caserver    = undef
  $agent_fileserver  = undef
  $agent_environment = 'production'
  $staging_dir       = '/tmp/puppet-enterprise-installer'
  $windows_source    = undef
  $windows_task_min  = '10' # run a scheduled task to upgrade PE agent in x mins
}
