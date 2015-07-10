#puppet\_ent\_agent

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with pe_agent](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)

##Overview

The puppet\_ent\_agent module installs, configures and manages the Puppet Enterprise Agent software and the pe-puppet service.

##Module Description

The puppet\_ent\_agent module is dependent on the PE Package Repositories (pe_repo classes) available on any Puppet Enterprise Master version 3.2 or greater. This module was designed so that PE users can easily upgrade their managed PE agents after a version upgrade of a deployment's PE server(s).

##Setup

###What puppet\_ent\_agent affects

* pe-agent package (and pe-\* packages related to PE)
* puppet.conf configuration file.
* pe-puppet service.

###Beginning with puppet\_ent\_agent

`include '::puppet_ent_agent'` is enough to get you up and running.

```puppet
class { '::puppet_ent_agent':
  agent_caserver => 'puppetca.company.lan',
  ensure         => '3.8.1'
  windows_source => '\\myfileserver\pe-agent'
}
```

###Parameters

The following parameters are available in the puppet_ent_agent module:

####`config`

Path to the puppet.conf file.  Defaults:
* Unix/Linux: '/etc/puppetlabs/puppet/puppet.conf'
* Windows: '${appdata}/PuppetLabs/puppet/etc/puppet.conf'

####`ensure`

Default setting: 'present'

To disable PE agent upgrades, leave this set to 'present'.

To upgrade managed agents to a specific PE version, specify a PE agent version
available on your pe_repo PE masters and/or Windows PE agent source.

If the pe_repo package repository of the specified version is not present on
the pe_repo server, the module will fail.  This module does not manage pe_repo.

####`master`

Hostname of a PE master with the required pe_repo classes properly applied to
it.  Defaults to the PE master that compiled the agent's catalog.

####`agent_server` & `agent_caserver` & `agent_fileserver` & `agent_environment`

Sets the server, ca_server, archive_file_server and environment settings in the agent's puppet.conf file.

The server settings default to undef and do not manage the settings unless overridden in node classification.  *agent_environment* defaults to 'production'.

####`staging_dir`

The directory that will be used on non-Windows hosts to temporarily hold the
PE Agent installation script.  This defaults to '/tmp/puppet_ent_agent'.

####`windows_source`

A UNC path to a publicly-readable SMB share that contains the PE Agent for Windows
MSI files.  Ensure that both 32-bit and 64-bit installers are hosted there; the
default file names are assumed.  The author recommends the use of Distributed File
Services (DFS) namespaces with multiple folder targets to efficiently provide a single
UNC path to the files for multi-site deployments.

####`windows_task_min`

The number of minutes to delay a scheduled task that will be configured to run an
upgrade of the PE agent on a managed Windows system, if required.  Defaults to 10
minutes.  This is meant to allow an upgrade of the PE agent while it's not running
a catalog.


##Limitations

This module depends completely on the correct pe_repo classes being added to the target
Puppet Enterprise master servers.  If agent installers aren't present, the install class
of this module will fail.  Best practice is to add pe_repo classes corresponding to
the OS families and architectures of all nodes managed in your infrastructure.

Windows support requires the MSI installers for the PE Agent for Windows to be hosted
outside of the PE environment.  PowerShell is required for upgrade support.

AIX, Debian/Ubuntu, and Windows OS Families have been tested.  RedHat and Solaris
testing is in progress, but should work.  Windows support was changed to a scheduled
task after it was found that managing the PE agent as a Puppet package resource produced
unpredictable behavior and is not supported by Puppet Labs.
