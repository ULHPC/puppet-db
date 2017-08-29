################################################################################
# Time-stamp: <Wed 2017-08-23 15:14 svarrette>
#
# File::      <tt>common.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# = Class: db::common
#
# Base class to be inherited by the other db classes, containing the common code.
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
#
class db::common {

  # Load the variables used in this module. Check the params.pp file
  require db::params

  # Order
  if ($db::ensure == 'present') {
    Group['db'] -> User['db'] -> Package['db']
  }
  else {
    Package['db'] -> User['db'] -> Group['db']
  }

  # Prepare the user and group
  group { 'db':
    ensure => $db::ensure,
    name   => db::params::group,
    gid    => db::params::gid,
  }
  user { 'munge':
    ensure     => $db::ensure,
    name       => $db::params::username,
    uid        => $db::params::gid,
    gid        => $db::params::gid,
    comment    => $db::params::comment,
    home       => $db::params::home,
    managehome => true,
    system     => true,
    shell      => $db::params::shell,
  }

  package { 'db':
    name    => "${db::params::packagename}",
    ensure  => "${db::ensure}",
  }
  package { $db::params::extra_packages:
    ensure => 'present'
  }

  if $db::ensure == 'present' {

    # Prepare the log directory
    file { "${db::params::logdir}":
      ensure => 'directory',
      owner  => "${db::params::logdir_owner}",
      group  => "${db::params::logdir_group}",
      mode   => "${db::params::logdir_mode}",
      require => Package['db'],
    }

    # Configuration file
    file { "${db::params::configdir}":
      ensure => 'directory',
      owner  => "${db::params::configdir_owner}",
      group  => "${db::params::configdir_group}",
      mode   => "${db::params::configdir_mode}",
      require => Package['db'],
    }
    # Regular version using file resource
    file { 'db.conf':
      ensure  => "${db::ensure}",
      path    => "${db::params::configfile}",
      owner   => "${db::params::configfile_owner}",
      group   => "${db::params::configfile_group}",
      mode    => "${db::params::configfile_mode}",
      #content => template("db/dbconf.erb"),
      #source => "puppet:///modules/db/db.conf",
      #notify  => Service['db'],
      require => [
        #File["${db::params::configdir}"],
        Package['db']
      ],
    }

    # # Concat version -- see https://forge.puppetlabs.com/puppetlabs/concat
    # include concat::setup
    # concat { "${db::params::configfile}":
      #     warn    => false,
      #     owner   => "${db::params::configfile_owner}",
      #     group   => "${db::params::configfile_group}",
      #     mode    => "${db::params::configfile_mode}",
      #     #notify  => Service['db'],
      #     require => Package['db'],
      # }
    # # Populate the configuration file
    # concat::fragment { "${db::params::configfile}_header":
      #     ensure  => "${db::ensure}",
      #     target  => "${db::params::configfile}",
      #     content => template("db/db_header.conf.erb"),
      #     #source => "puppet:///modules/db/db_header.conf",
      #     order   => '01',
      # }
    # concat::fragment { "${db::params::configfile}_footer":
      #     ensure  => "${db::ensure}",
      #     target  => "${db::params::configfile}",
      #     content => template("db/db_footer.conf.erb"),
      #     #source => "puppet:///modules/db/db_footer.conf",
      #     order   => '99',
      # }

    # PID file directory
    file { "${db::params::piddir}":
      ensure  => 'directory',
      owner   => "${db::params::piddir_user}",
      group   => "${db::params::piddir_group}",
      mode    => "${db::params::piddir_mode}",
    }
  }
  else
  {
    # Here $db::ensure is 'absent'
    file {
      [
        $db::params::configdir,
        $db::params::logdir,
        $db::params::piddir,
      ]:
        ensure => $db::ensure,
        force  => true,
    }
  }
    # Sysconfig / default daemon directory
    file { "${db::params::default_sysconfig}":
      ensure  => $db::ensure,
      owner   => $db::params::configfile_owner,
      group   => $db::params::configfile_group,
      mode    => '0755',
      #content => template("db/default/db.erb"),
      #source => "puppet:///modules/db/default/db.conf",
      notify  =>  Service['db'],
      require =>  Package['db']
    }

  service { 'db':
    ensure     => ($db::ensure == 'present'),
    name       => "${db::params::servicename}",
    enable     => ($db::ensure == 'present'),
    pattern    => "${db::params::processname}",
    hasrestart => "${db::params::hasrestart}",
    hasstatus  => "${db::params::hasstatus}",
    require    => [
      Package['db'],
      File[$db::params::configdir],
      File[$db::params::logdir],
      File[$db::params::piddir],
      File[$db::params::configfile_init]
    ],
    subscribe  => File['db.conf'],
  }

}
