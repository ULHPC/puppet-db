################################################################################
# Time-stamp: <Wed 2017-08-23 14:49 svarrette>
#
# File::      <tt>init.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# == Class: db
#
# Meta-module to manage {My,PostGre}SQL Databases in a generic and homogeneous way
#
#
# @param ensure [String] Default: 'present'.
#          Ensure the presence (or absence) of db
#
# === Requires
#
# n/a
#
# @example Basic instanciation
#
#     include '::db'
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { '::db':
#             ensure => 'present'
#         }
#
# === Authors
#
# The UL HPC Team <hpc-sysadmins@uni.lu> of the University of Luxembourg, in
# particular
# * Sebastien Varrette <Sebastien.Varrette@uni.lu>
# * Valentin Plugaru   <Valentin.Plugaru@uni.lu>
# * Sarah Peter        <Sarah.Peter@uni.lu>
# * Hyacinthe Cartiaux <Hyacinthe.Cartiaux@uni.lu>
# * Clement Parisot    <Clement.Parisot@uni.lu>
# See AUTHORS for more details
#
# === Warnings
#
# /!\ Always respect the style guide available here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
class db(
    String $ensure = $db::params::ensure
)
inherits db::params
{
    validate_legacy('String', 'validate_re', $ensure, ['^present', '^absent'])

    info ("Configuring db (with ensure = ${ensure})")

    case $::operatingsystem {
        /(?i-mx:ubuntu|debian)/:        { include ::db::common::debian }
        /(?i-mx:centos|fedora|redhat)/: { include ::db::common::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}
