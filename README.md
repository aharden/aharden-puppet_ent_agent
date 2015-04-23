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
* /etc/puppetlabs/puppet/puppet.conf configuration file.
* pe-puppet service.

###Beginning with puppet\_ent\_agent

`include '::puppet_ent_agent'` is enough to get you up and running.

```puppet
class { '::puppet_ent_agent':
  agent_caserver => 'puppetca.company.lan',
  windows_source => '\\myfileserver\pe-agent'
}
```

###Parameters

The following parameters are available in the puppet_ent_agent module:

####`config`

Path to the puppet.conf file (defaults to /etc/puppetlabs/puppet/puppet.conf)

####`package_ensure`

Version of pe-agent to ensure, by default this is set to latest, and uses the 'current'
package repository on the master. *This will auto upgrade agents if master is updated.*

If you specify a version number, it may cause issues with general vs specific version
differences (ie 3.2.0 vs 3.2.0.el6.1).

To disable updating, set this to 'present'.

AIX/Solaris/Windows don't support this: see the related *version* variable documented below.

####`master`

Hostname of apt/yum repository with pe-agent packages on it, assumes the hostname is of a PE master
with the required pe_repo classes properly applied to it.  Defaults to the PE master that compiled
the agent's catalog.

####`agent_server` & `agent_caserver` & `agent_fileserver` & `agent_environment`

Sets the server, ca_server, archive_file_server and environment settings in the agent's puppet.conf file.

The server settings default to undef and do not manage the settings unless overridden in node classification.  *agent_environment* defaults to 'production'.

####`staging_dir`

The directory that will be used on AIX and Solaris hosts to temporarily hold the
PE Agent installation files.  This defaults to PE's default: /tmp/puppet-enterprise-installer

####`windows_source`

A UNC path to a publicly-readable SMB share that contains the PE Agent for Windows
MSI files.  Ensure that both 32-bit and 64-bit installers are hosted there; the
default file names are assumed.  The author recommends the use of Distributed File
Services (DFS) namespaces with multiple folder targets to efficiently provide a single
UNC path to the files for multi-site deployments.

####`version`

On AIX/Solaris/Windows: The desired version of the PE agent to install.  These OS families' 
native package providers don't support `ensure => latest`.  This parameter defaults to the 
version of the running PE agent (which means agent upgrades aren't armed unless a 
newer version is set in the class declaration or hieradata).



##Limitations

This module depends completely on the correct pe_repo classes being added to the target
Puppet Enterprise master servers.  If agent installers aren't present, the install class
of this module will fail.  Best practice is to add pe_repo classes corresponding to
the OS families and architectures of all nodes managed in your infrastructure.

Windows support requires the MSI installers for the PE Agent for Windows to be hosted
outside of the PE environment.

AIX, Debian/Ubuntu, and Windows OS Families have been tested.  Solaris testing is in
progress.  RedHat support with yumrepo is potentially problematic on PE <= 3.3 due to
bug PUP-2271.
