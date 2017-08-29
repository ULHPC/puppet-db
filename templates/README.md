Templates
=========

Puppet supports templates and templating via ERB, which is part of the Ruby
standard library and is used for many other projects including Ruby on Rails.
Templates allow you to manage the content of template files, for example
configuration files that cannot yet be managed as a Puppet type. 

Learn more [here](http://projects.puppetlabs.com/projects/puppet/wiki/Puppet_Templating)

You can use templates like this: 

    class db {
        package { db: ensure => latest }
        file { "/etc/db.conf":
             content => template("db/myfile.erb")
        }
    }

The templates are searched for in:

    $templatedir/db/myfile.erb
    $modulepath/db/templates/myfile.erb

