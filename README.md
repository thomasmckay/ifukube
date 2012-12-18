# Ifukube ~ Compositions For Your Bugzilla #

Setup postgresql database

      % su - root
      # su - postgres -c 'createuser -dls ifukube --no-password'
      # su - postgres -c 'createdb -U ifukube ifukube'

Start elasticsearch service

Create custom config

      % cp config/ifukube.yml.example config/ifukube.yml

## Based On OpenShift Rails Sample App ##
https://github.com/openshift/rails-example
