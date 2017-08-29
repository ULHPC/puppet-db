# File::      <tt>params.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'db::params'

$names = ["ensure", "protocol", "port", "packagename"]

notice("db::params::ensure = ${db::params::ensure}")
notice("db::params::protocol = ${db::params::protocol}")
notice("db::params::port = ${db::params::port}")
notice("db::params::packagename = ${db::params::packagename}")

#each($names) |$v| {
#    $var = "db::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
