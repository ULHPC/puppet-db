################################################################################
# Time-stamp: <Wed 2017-08-23 14:37 svarrette>
#
# File::      <tt>mydef.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# == Defines: db::mydef
#
# Meta-module to manage {My,PostGre}SQL Databases in a generic and homogeneous way
#
# == Pre-requisites
#
# * The class 'db' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent'.
#   Default: 'present'
#
# [*content*]
#  Specify the contents of the mydef entry as a string. Newlines, tabs,
#  and spaces can be specified using the escaped syntax (e.g., \n for a newline)
#
# [*source*]
#  Copy a file as the content of the mydef entry.
#  Uses checksum to determine when a file should be copied.
#  Valid values are either fully qualified paths to files, or URIs. Currently
#  supported URI types are puppet and file.
#  In neither the 'source' or 'content' parameter is specified, then the
#  following parameters can be used to set the console entry.
#
# == Sample usage:
#
#     include "db"
#
# You can then add a mydef specification as follows:
#
#      db::mydef {
#
#      }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[https://docs.puppet.com/puppet/latest/style_guide.html]
#
define db::mydef(
    $ensure         = 'present',
    $content        = '',
    $source         = ''
)
{
  validate_re($ensure, '^present$|^absent$')
  #validate_string($mode)
  #validate_hash($hash)
  #validate_absolute_path($path)
  #if ! (is_string($owner) or is_integer($owner)) {
  #  fail("\$owner must be a string or integer, got ${owner}")
  #}
  #validate_bool($replace)

    include db::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("db::mydef 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($db::ensure != $ensure) {
        if ($db::ensure != 'present') {
            fail("Cannot configure a db '${basename}' as db::ensure is NOT set to present (but ${db::ensure})")
        }
    }

    # if content is passed, use that, else if source is passed use that
    $real_content = $content ? {
        '' => $source ? {
            ''      => template('db/db_entry.erb'),
            default => ''
        },
        default => $content
    }
    $real_source = $source ? {
        '' => '',
        default => $content ? {
            ''      => $source,
            default => ''
        }
    }

    # concat::fragment { "${db::params::configfile}_${basename}":
    #     ensure  => "${ensure}",
    #     target  => "${db::params::configfile}",
    #     content => $real_content,
    #     source  => $real_source,
    #     order   => '50',
    # }

    # case $ensure {
    #     present: {

    #     }
    #     absent: {

    #     }
    #     disabled: {

    #     }
    #     default: { err ( "Unknown ensure value: '${ensure}'" ) }
    # }

}
