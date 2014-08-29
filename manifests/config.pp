# = Class: apc::config
#
# This class configure apc on node
#
# == Actions:
# Push apc.php and apc.conf.php files into $apcdocroot. Set password in
# apc.conf.php file
#
# === Authors
#
# Felice Pizzurro <felice.pizzurro@softecspa.it>
#

class apc::config {

  # /etc/php5/conf.d/apc.ini

  file { $apc::apcconffile:
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('apc/apc.ini.erb'),
    notify  => $apc::install::notify,
  }

  if $lsbdistcodename != 'hardy' {
    $ensure_link = $apc::enabled ? {
      true    =>  'link',
      default => absent
    }

    file {'/etc/php5/conf.d/20-apc.ini':
      ensure  => $ensure_link,
      target  => $apc::apcconffile
    }
  }

  exec { 'apc-apache2-restart':
    command     => '/etc/init.d/apache2 restart',
    refreshonly => true,
  }

  if $apc::apcdocroot != '' {

    file { "${apc::apcdocroot}/apc.php":
      ensure  => present,
      mode    => '0644',
      source  => 'puppet:///modules/apc/apc.php',
      owner   => 'www-data',
      group   => 'www-data',
    }

    file { "${apc::apcdocroot}/apc.conf.php":
      ensure  => present,
      mode    => '0644',
      content => template('apc/apc.conf.php'),
      owner   => 'www-data',
      group   => 'www-data',
    }
  }
}
