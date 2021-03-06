# Class: ptpd
# ===========================
#
# Full description of class ptpd here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'ptpd':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#

class ptpd(

  String $ptpinterface = 'eth0',
  Boolean $ptp_master = true,
){

  package { 'ptpd':
    ensure => 'installed',
  }

  if ($ptp_master) {
    $ptpengine = 'masteronly'
  } else {
    $ptpengine = 'serveronly'
  }

  service { 'ptpd':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['ptpd'],
  }

  file { '/etc/ptpd2.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ptpd/ptpd.conf.erb'),
  }
}


