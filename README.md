# Butterfly Net ~ Catching Pretty Bugs #

Setup postgresql database

      % su - root
      # su - postgres -c 'createuser -dls butterfly --no-password'
      # su - postgres -c 'createdb -U butterfly butterfly'

Start elasticsearch service

Create custom config

      % cp config/butterfly.yml.example config/butterfly.yml

## Based On OpenShift Rails Sample App ##
https://github.com/openshift/rails-example
