## 2015-11-11 - Version 1.2.6

Bugfix:
* install/nix.pp: Force RedHat 5.x systems to specify TLSv1 security for wget.  We may have other platforms that require this since PE requires TLSv1 security or better.

Thanks to @ajmaidak for this contribution.

## 2015-11-03 - Version 1.2.5

Bugfix:
* params.pp: corrected PE 3.x service name from "pe_puppet" to "pe-puppet"

## 2015-11-03 - Version 1.2.4 (broken - do not use)

Bugfix:
* params.pp: rubyversion fact was not the best indicator of Puppet agent type (PE 3.x vs AIO) and hence service name.  I believe the "is_pe" fact is; moved over to using that.

## 2015-10-30 - Version 1.2.3 (broken - do not use)

Bugfix:
* added support in config and service classes for Puppet AIO (all-in-one) agent to accommodate transitions to PE 2015.2.x

## 2015-10-23 - Version 1.2.2

Bugfix:
* config.pp: uncorrected linting issue to improve code quality score
* install/nix.pp: added redownload parameter in case previous install.bash was still on disk
* params.pp: moved to a puppet_confdir fact for Puppet 3.x/4.x compatibility (thanks to puppetlabs-puppet_agent module for idea)

Thanks to @ajmaidak for the install/nix contribution.

## 2015-10-21 - Version 1.2.1

Bugfix:
* config.pp: spelling error fixed and corrected linting issue

## 2015-10-21 - Version 1.2.0

New features:
* agent_splay: (boolean) controls PE agent splay toggle on/off
* agent_remove_modulepath: (boolean) enables removal of deprecated modulepath
* manage_symlinks: (boolean) controls whether /usr/bin symlinks are managed

Bugfix:
* ensure: now by default set to 'present' as previously documented

Updates:
* Added Changelog
* Clarified PE 3.x-only support in Readme
* Additional testing resources added

Thanks to @ajmaidak for contributing to this release!

## 2015-08-12 - Version 1.1.0

New feature:
* Added management of /usr/bin symlinks for facter, hiera, puppet, and pe-man binaries that appeared to be dropped as of PE 3.8. (Unix/Linux)

Bugfix:
* Corrected owner:group of puppet.conf on AIX back to puppet:puppet.

## 2015-07-15 - Version 1.0.0

*First Production Release*

Refactored parameters and methods:
* pe_repo was unreliable as an apt source (at least as managed with puppetlabs/apt) so I decided to use the PE bash-script-based installation for Unix/Linux natively. (Dumped yum support as well.)
* Combined package_ensure and version parameters into a single 'ensure' parameter.