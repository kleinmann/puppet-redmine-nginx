# Redmine Module with nginx support

Uwe Kleinmann <uwe@kleinmann.org>

This module installs Redmine 2.1.2 with an accompanying nginx vhost via Puppet.
It is specifically for Ubuntu 12.10 and hasn't been tested with anything else.

DISCLAIMER: This is rather opinionated.

# Usage
<pre>
  class { 'redmine':
    redmine_domain => 'projects.example.com',
    redmine_dbtype => 'postgresql',
    redmine_dbname => 'redmine',
    redmine_dbuser => 'redmineuser',
    redmine_dbpwd  => 'password',
    redmine_dbhost => 'localhost',
  }
</pre>

