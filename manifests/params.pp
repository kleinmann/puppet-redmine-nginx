# Class:: redmine::params
#
#
class redmine::params {
  $redmine_user        = 'redmine'
  $redmine_dbtype      = 'postgresql'
  $redmine_dbname      = 'redmine'
  $redmine_dbuser      = 'redmineu'
  $redmine_dbpwd       = 'changeme'
  $redmine_dbhost      = 'localhost'
  $redmine_dbport      = '5432'
  $redmine_domain      = $::fqdn
} # Class:: redmine::params

