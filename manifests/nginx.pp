# Class:: redmine::nginx
#
#
class redmine::nginx {
  include redmine

  $redmine_domain = $redmine::redmine_domain

  file {
    '/etc/nginx/conf.d/redmine.conf':
      ensure  => file,
      content => template('redmine/nginx-vhost.conf.erb'),
      owner   => root,
      group   => root,
      mode    => '0644',
  }
} # Class:: redmine::nginx

