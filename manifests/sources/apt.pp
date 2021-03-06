class mongodb::sources::apt inherits mongodb::params {
  include apt

  if $mongodb::location {
    $location = $mongodb::location
  } else {
    $location = $mongodb::params::locations[$mongodb::init]
  }

  apt::source { '10gen':
    location    => $location,
    release     => 'dist',
    repos       => '10gen',
    key         => '492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10',
    key_server  => 'hkp://keyserver.ubuntu.com:80',
    include_src => false,
  }
}
