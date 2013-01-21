# Class:: redmine::server
class redmine::server {
  include redmine
  require redmine::pre
  require redmine::nginx

  $redmine_dbtype  = $redmine::redmine_dbtype
  $redmine_dbname  = $redmine::redmine_dbname
  $redmine_dbuser  = $redmine::redmine_dbuser
  $redmine_dbpwd   = $redmine::redmine_dbpwd
  $redmine_dbhost  = $redmine::redmine_dbhost
  $redmine_dbport  = $redmine::redmine_dbport
  $redmine_domain  = $redmine::redmine_domain
  $redmine_user    = $redmine::redmine_user

  $redmine_without_gems = $redmine_dbtype ? {
    mysql    => 'postgres sqlite',
    pgsql    => 'mysql sqlite',
    default  => '',
  }

  package { 'redmine':
    ensure   => present,
    name     => 'redmine',
    provider => 'dpkg',
    source   => '/tmp/redmine_2.1.2_all.deb',
    require  => File['redmine-package'],
  }

  file { 'redmine-package':
    ensure  => 'present',
    path    => '/tmp/redmine_2.1.2_all.deb',
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    source  => 'puppet:///modules/redmine/redmine_2.1.2_all.deb',
  }

  exec {
    'Install redmine bundles':
      command     => "bundle install --without development test ${redmine_without_gems}",
      logoutput   => 'on_failure',
      provider    => shell,
      cwd         => "/var/www/redmine",
      path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      user        => 'root',
      require     => [Package['redmine'], Package['bundler']];
    'Setup redmine DB':
      command     => 'bundle exec rake generate_secret_token ; bundle exec rake db:migrate RAILS_ENV=production ; bundle exec rake redmine:load_default_data RAILS_ENV=production ; bundle exec rake db:encrypt RAILS_ENV=production',
      logoutput   => 'on_failure',
      provider    => shell,
      cwd         => "/var/www/redmine",
      path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      user        => $redmine_user,
      require     => [
        Package['redmine'],
        File['/var/www/redmine/config/database.yml'],
        File['/var/www/redmine/tmp'],
        Package['bundler'],
        Exec['Install redmine bundles'],
        ],
      refreshonly => true;
    'Migrate redmine DB':
      command   => 'bundle exec rake db:migrate RAILS_ENV=production',
      logoutput => 'on_failure',
      provider  => shell,
      cwd       => "/var/www/redmine",
      path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      user      => $redmine_user,
      creates   => '/.redmine_setup_done',
      require   => [
        Package['redmine'],
        File['/var/www/redmine/config/database.yml'],
        File['/var/www/redmine/tmp'],
        Package['bundler'],
        Exec['Install redmine bundles'],
        ];
  }


  file { '/.redmine_setup_done':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    require => Exec['Migrate redmine DB'],
  }

  file {
    '/var/www/redmine/config/database.yml':
      ensure  => file,
      content => template('redmine/database.yml.erb'),
      owner   => $redmine_user,
      group   => $redmine_user,
      require => [Package['redmine'],File['/var/www/redmine/config/configuration.yml']];
    '/var/www/redmine/config/unicorn.rb':
      ensure  => file,
      content => template('redmine/unicorn.rb.erb'),
      owner   => $redmine_user,
      group   => $redmine_user,
      require => [Package['redmine'],File['/var/www/redmine/config/configuration.yml']];
    '/var/www/redmine/config/configuration.yml':
      ensure  => file,
      content => template('redmine/configuration.yml.erb'),
      owner   => $redmine_user,
      group   => $redmine_user,
      mode    => '0640',
      require => Package['redmine'],
      notify  => Exec['Setup redmine DB'];
    '/var/www/redmine/tmp':
      ensure  => directory,
      owner   => $redmine_user,
      group   => $redmine_user,
      require => Package['redmine'];
  }

  file { '/var/lib/redmine':
      ensure => directory,
      owner  => $redmine_user,
      group  => 'www-data',
      mode   => '0775';
  }

  file {
    '/etc/init.d/redmine':
      ensure  => file,
      content => template('redmine/redmine.init.erb'),
      owner   => root,
      group   => root,
      mode    => '0755',
      notify  => Service['redmine'],
      require => Exec['Setup redmine DB'];
  }

  service {
    'redmine':
      ensure    => running,
      require   => File['/etc/init.d/redmine'],
      hasstatus => false,
      pattern   => 'unicorn_rails',
      enable    => true;
  }
} # Class:: redmine::server

