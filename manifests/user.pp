# == Define: mongodb::user
#
# Adds a user to Mongo authentication list with the provided
# parameter. All users will be added to the 'admin' database.
define mongodb::user (
  $password,
  $db_host     = '127.0.0.1',
  $db_name     = 'test',
  $db_port     = '27017',
  $ensure      = 'present',
  $js_dir      = '/root/puppetlabs-mongodb',
  $roles       = '[]',
  ) {

  file { $js_dir:
    ensure => directory,
    group  => 'root',
    mode   => '0700',
    owner  => 'root',
    path   => $js_dir,
  }

  $mongodb_script_user = "mongo_user-${title}_${db_name}.js"
  file { $mongodb_script_user:
    ensure  => present,
    content => template('mongodb/user.js.erb'),
    group   => 'root',
    mode    => '0600',
    owner   => 'root',
    path    => "${js_dir}/${mongodb_script_user}",
    require => File[$js_dir],
  }

  $database_host = "${db_host}:${db_port}/${db_name}"
  exec { "mongo_user-${name}_${db_name}":
    command     => "mongo ${database_host} ${js_dir}/${mongodb_script_user}",
    path        => ['/usr/bin', '/usr/sbin'],
    refreshonly => true,
    require     => Service['mongodb'],
    subscribe   => File[$mongodb_script_user],
  }
}
