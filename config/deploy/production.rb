role :app, %w{capistrano@kubosch.no}
role :web, %w{capistrano@kubosch.no}
role :db,  %w{capistrano@kubosch.no}

server 'kubosch.no', user: 'capistrano', roles: %w{web app}

namespace :deploy do
  desc 'The spinner task is used by :cold_deploy to start the application up'
  task :spinner do
    on roles :all do
      execute :sudo, "systemctl start #{fetch :application}"
    end
  end

  desc 'Restart the service'
  task :restart do
    on roles :all do
      execute :sudo, "systemctl restart #{fetch :application}"
    end
  end
end
