define mongodb::user (
  $password,
  $js_dir      = '/root/puppetlabs-mongodb',
  ) {

  file { $js_dir:
    ensure => directory,
    path   => $js_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
}
