class redis (
  $port=6379
)
{
  exec { 'install redis':
    command => '/bin/bash scripts/redis.sh',
    cwd     => '$HOME/500px-challenge'
  }
  ->
  file { '/etc/redis':
    ensure => directory
  }
  ->
  file { '/var/redis':
    ensure => directory
  }
  ->
  file { '/etc/init.d/redis':
    ensure => file,
    source => '$HOME/500px-challenge/redis-stable/utils/redis_init_script',
    owner    => 'root',
    group    => 'root',
    mode     => '0755',
  }
  ->
  file { "/etc/redis/${port}.conf":
    ensure => file,
    source => '$HOME/500px-challenge/redis-stable/redis.conf',
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
  }
  ->
  file { "/var/redis/${port}":
    ensure => directory
  }
  ->
  file_line { 'daemonize to yes':
    path  => "/etc/redis/${port}.conf",
    line  => 'daemonize yes',
    match => '^daemonize',
  }
  ->
  file_line { 'set pidfile':
    path  => "/etc/redis/${port}.conf",
    line  => "pidfile /var/run/redis_${port}.pid,
    match => '^pidfile',
  }
  ->
  file_line { 'set logfile':
    path  => "/etc/redis/${port}.conf",
    line  => "logfile \"/var/log/redis_${port}.log\"",
    match => '^logfile',
  }
  ->
  file_line { 'set dir':
    path  => "/etc/redis/${port}.conf",
    line  => "dir /var/redis/${port}",
    match => '^dir',
  }
  ->
  exec { 'set redis runlevel to default':
    command => '/usr/sbin/update-rc.d redis defaults',
  }
  ->
  service { 'redis':
    ensure => running,
    enable => true,
  }
}