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

  package {
    ['libmagickcore-dev','libmagickwand-dev']:
        ensure  => installed,
  }
} # Class:: redmine::pre
