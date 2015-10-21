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
