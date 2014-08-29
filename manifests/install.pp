class apc::install {

  Apt::Ppa {
    before  => Package['php-apc']
  }

  case $::lsbdistcodename {
    'hardy': {
      softec_apt::ppa{'chris-lea/php-pecl-extras':
        mirror  => true,
        key     => 'C7917B12'
      }
    }

    'lucid': {
      if !defined(Softec_apt::Ppa['ondrej/php5-oldstable']) {
        softec_apt::ppa {'ondrej/php5-oldstable':
          mirror  => true,
          key     => 'E5267A6C'
        }
      }
    }
  }

  if (defined(Service['php5-fpm']) and defined(Service['apache2']) ){
    $notify = [Service['php5-fpm'] , Service['apache2']]
  }
  else {
    if defined(Service['apache2']) {
      $notify = Service['apache2']
    }
    else {
      if defined(Service['php5-fpm']) {
        $notify = Service['php5-fpm']
      }
      else {
        $notify = undef
      }
    }
  }

  if defined(Service['apache2']) {
    $notify_apache = Service['apache2']
  }

  package { 'php-apc':
    ensure  => present,
    notify  => $notify
  }

}
