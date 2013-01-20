# == Class: redmine
#
# === Parameters
#
# [redmine_user] Name of redmine user
# [redmine_dbtype] Redmine database type (mysql/pgsql)
# [redmine_dbname] Redmine database name
# [redmine_dbuser] Redmine database user
# [redmine_dbpwd] Redmine database password
# [redmine_dbhost] Redmine database host (default localhost)
# [redmine dbport] Redmine database port for postgresql (default 5432)
# [redmine_domain] Redmine domain (default $fqdn)
#
# === Examples
#
# node /redmine/ {
#   class {
#     'redmine':
#       redmine_dbuser => 'redmine',
#       redmine_dbpwd  => 'password',
#       redmine_dbname => 'redmine',
#       redmine_domain => 'redmine.example.com',
#   }
# }
#
# === Authors
#
# Uwe Kleinmann <uwe@kleinmann.org>
#
# === Copyright
#
# BSD license

# Class:: redmine
#
#
class redmine(
    $redmine_user        = $redmine::params::redmine_user,
    $redmine_dbtype      = $redmine::params::redmine_dbtype,
    $redmine_dbname      = $redmine::params::redmine_dbname,
    $redmine_dbuser      = $redmine::params::redmine_dbuser,
    $redmine_dbpwd       = $redmine::params::redmine_dbpwd,
    $redmine_dbhost      = $redmine::params::redmine_dbhost,
    $redmine_dbport      = $redmine::params::redmine_dbport,
    $redmine_domain      = $redmine::params::redmine_domain,
  ) inherits redmine::params {
  case $::operatingsystem {
    ubuntu: {
      include redmine::server
    }
    default: {
      err "${::operatingsystem} not supported yet"
    }
  } # case
} # Class:: redmine

