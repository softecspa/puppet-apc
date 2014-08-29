# = Class: apc
#
# This class install apc module on using php pecl.
#
# == Parameters:
# $password::   password used to protect access to apc.php page
#
# $enabled::    true enable apc module. Default=true
#
# $apc_stat::   if true set apc.stat=1 otherwise set apc.stat=0.
#               default=true
#
# $apcdocroot:: virtualhost's docroot where apc.php page is pushed. If it's not configured no monitoring script will be pushed. Default: ''
#
# == Actions:
#   Install apc module using php-apc package
#
# == Sample Usage:
#
# 1) install apc with monitoring page in /var/www
#   class {'apc':
#     enabled     => "true",
#     password    => "yourpassword",
#     apc_stat    => "true",
#     apcdocroot  => "/var/www"
#   }
#
# 2) install apc with no monitoring page and all default params
#
#  include apc
# === Authors
#
# Felice Pizzurro <felice.pizzurro@softecspa.it>
#
class apc (
    $password,
    $apcdocroot     = '',
    $enabled        = 'true',
    $apc_stat       = 'true',
    $shm_size       = '1024M',
    $num_files_hint = '5000',
    $ttl            = '3600',
    $rfc1867        = 'false',
    $gc_ttl         = '3600',
    $user_ttl       = '0',
  ){

  $apcconffile = $::lsbdistcodename ? {
    hardy   => '/etc/php5/conf.d/apc.ini',
    default => '/etc/php5/mods-available/apc.ini'
  }

  include apc::install
  include apc::config

  Class['apc::install'] ->
  Class['apc::config']
}
