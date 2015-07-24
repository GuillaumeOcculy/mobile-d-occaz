#!/usr/bin/env bash

RAILS_ENV=production rake assets:clean
RAILS_ENV=production rake assets:precompile
RAILS_ENV=production rake tmp:cache:clear

pumactl -F config/puma.rb stop
pumactl -F config/puma.rb start

whenever -i mobile-d-occaz

RAILS_ENV=production bin/delayed_job stop
RAILS_ENV=production bin/delayed_job -n 2 start
