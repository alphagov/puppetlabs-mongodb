define mongodb::user (
  $password,
  $roles       = '[]',
  $db_host     = '127.0.0.1',
  $db_port     = '27017',
  $db_name     = 'test',
  $js_dir      = '/root/puppetlabs-mongodb',
  $ensure      = 'present'
  ) {

  file { "${js_dir}":
    ensure => directory,
    path   => "${js_dir}",
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  $mongodb_script_user = "mongo_user-${title}_${db_name}.js"

  file { "${mongodb_script_user}":
    ensure  => present,
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    path    => "${js_dir}/${mongodb_script_user}",
    content => template('mongodb/user.js.erb'),
    require => File["${js_dir}"],
  }

  exec { "mongo_user-${name}_${db_name}":
      command     => "mongo ${db_host}:${db_port}/${db_name} ${js_dir}/${mongodb_script_user}",
      require     => Service['mongodb'],
      subscribe   => File[$mongodb_script_user],
      path        => ['/usr/bin', '/usr/sbin'],
      refreshonly => true,
  }
}
