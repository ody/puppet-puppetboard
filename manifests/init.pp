class puppetboard(
  $puppetdb_host,
  $puppetdb_port      = 8080,
  $ssl                = true,
  $puppetdb_ssl_key   = false,
  $puppetdb_ssl_cert  = false,
  $puppetdb_timeout   = 20,
  $dev_listen_host    = '127.0.0.1',
  $dev_listen_port    = 5000,
  $unresponsive_hours = 2,
  $enable_query       = false,
  $loglevel           = 'info',
  $docroot            = '/var/www/puppetboard',
  $user               = 'www-data',
  $group              = 'www-data',
) {

  package { 'puppetboard':
    ensure => present,
    provider => pip,
  }

  if $ssl and ($puppetdb_ssl_key == false or $puppetdb_ssl_cert == false) {
    fail('When ssl is enabled you much provides that to an ssl certificate signed by your puppet CA and proved the paths to the key and certificate for puppetdb_ssl_key and puppetdb_ssl_cert')
  }

  if $ssl {
    $puppetdb_ssl_verify = true
  } else {
    $puppetdb_ssl_verify = false
  }

  file { "${docroot}/settings.py":
    ensure  => file,
    content => template('puppetboard/settings.py.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0640',
  }
}
