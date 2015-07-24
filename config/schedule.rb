job_type :rvm_rake, "cd :path && source $HOME/.rvm/environments/ruby-2.1.2@mobile-d-occaz && :environment_variable=:environment bundle exec rake :task --silent :output"

set :output, 'log/cron.log'

every 1.day, :at => '4:30 am' do
	rvm_rake "local:remove_empty_post"
	rvm_rake "local:remove_expired_post"
end
