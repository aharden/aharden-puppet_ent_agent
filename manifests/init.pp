# Class: puppet_ent_agent
#
# This class manages the Puppet Enterprise (PE) agent.
#
# Parameters:
#
# Actions:
#   - Configure PE agent
#   - Upgrade PE agent if required
#   - Manage pe-puppet service
#
# Requires:
#
# Sample Usage:
#
class puppet_ent_agent (
  $config                  = $puppet_ent_agent::params::config,
  $ensure                  = $puppet_ent_agent::params::ensure,
  $master                  = $puppet_ent_agent::params::master,
  $agent_server            = $puppet_ent_agent::params::agent_server,
  $agent_caserver          = $puppet_ent_agent::params::agent_caserver,
  $agent_fileserver        = $puppet_ent_agent::params::agent_fileserver,
  $agent_environment       = $puppet_ent_agent::params::agent_environment,
  $agent_splay             = $puppet_ent_agent::params::agent_splay,
  $agent_remove_modulepath = $puppet_ent_agent::params::agent_remove_modulepath,
  $staging_dir             = $puppet_ent_agent::params::staging_dir,
  $manage_symlinks         = $puppet_ent_agent::params::manage_symlinks,
  $windows_source          = $puppet_ent_agent::params::windows_source,
  $windows_task_min        = $puppet_ent_agent::params::windows_task_min,
) inherits puppet_ent_agent::params {

  validate_absolute_path($config)
  validate_string($ensure)
  validate_string($master)
  validate_string($agent_server)
  validate_string($agent_caserver)
  validate_string($agent_fileserver)
  validate_string($agent_environment)
  validate_string($staging_dir)
  validate_string($windows_source)
  validate_bool($agent_remove_modulepath)
  validate_bool($manage_symlinks)
  if ($agent_splay != undef) {
    validate_bool($agent_splay)
  }
  validate_integer($windows_task_min)

  class { '::puppet_ent_agent::install': } ->
  class { '::puppet_ent_agent::config': } ->
  class { '::puppet_ent_agent::service': }

}
