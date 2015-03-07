lock '3.4.0'

set :application, 'blog'
set :repo_url, "svn+ssh://capistrano@kubosch.no/var/svn/trunk/#{fetch :application}"
set :deploy_to, "/u/apps/#{fetch :application}"
set :scm, :svn
set :pty, true

set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

namespace :deploy do
  task :startup_script do
    on roles :all do
      execute :sudo, "cp /u/apps/#{fetch :application}/current/usr/lib/systemd/system/#{fetch :application}.service /usr/lib/systemd/system/#{fetch :application}.service"
      execute :sudo, "systemctl enable #{fetch :application}"
      execute :sudo, 'systemctl daemon-reload'
    end
  end

  desc 'Announce maintenance'
  task :announce_maintenance do
    on roles :all do
      within "#{current_path}/public" do
        with rails_env: fetch(:rails_env) do
          puts 'execute 1'
          execute :cp, '503_update.html 503.html'
        end
      end
    end
  end

  desc 'End maintenance'
  task :end_maintenance do
    on roles :all do
      within "#{current_path}/public" do
        with rails_env: fetch(:rails_env) do
          puts 'execute 2'
          execute :cp, '503_down.html 503.html'
        end
      end
    end
  end

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

after 'deploy:updated', 'deploy:announce_maintenance'
before 'deploy:restart', 'deploy:startup_script'
after 'deploy:published', 'deploy:restart'
after 'deploy:finished', 'deploy:end_maintenance'
