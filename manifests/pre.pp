# Class:: redmine::pre
#
#
class redmine::pre {
  include redmine

  $redmine_user = $redmine::redmine_user

  user { $redmine_user:
      ensure     => present,
      shell      => '/bin/bash',
      home       => '/var/www/redmine',
      managehome => false,
      comment    => '',
  }

  require redmine::ubuntu_packages
}

class redmine::ubuntu_packages {
  include redmine

  $redmine_dbtype  = $redmine::redmine_dbtype

  exec {
    'apt-get update':
      command     => '/usr/bin/apt-get update';
  }

  $db_packages = $redmine_dbtype ? {
    mysql => ['libmysql++-dev','libmysqlclient-dev'],
    pgsql => ['libpq-dev', 'postgresql-client'],
  }
  package {
    $db_packages:
      ensure  => installed,
      require => Exec['apt-get update']
  }

  package {
    ['libmagickcore-dev','libmagickwand-dev',
      'libxml2-dev','libxslt1-dev']:
        ensure  => installed,
        require => Exec['apt-get update'],
  }

  # Assuming default ruby 1.9.3 (quantal)
  package {
    ['ruby','ruby-dev','rubygems']:
      require => Exec['apt-get update'],
      ensure  => installed;
  }

} # Class:: redmine::pre

