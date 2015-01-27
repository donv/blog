lock '3.3.5'

set :application, 'blog'
set :repo_url, "svn+ssh://capistrano@kubosch.no/var/svn/trunk/#{fetch :application}"
set :deploy_to, "/u/apps/#{fetch :application}"
set :scm, :svn
set :pty, true

# set :log_level, :debug

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# after 'deploy:updated', :announce_maintenance
# after 'deploy:finishing', :end_maintenance
before 'deploy:restart', 'deploy:startup_script'
after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :startup_script do
    on roles :all do
      execute :sudo, "cp /u/apps/#{fetch :application}/current/usr/lib/systemd/system/#{fetch :application}.service /usr/lib/systemd/system/#{fetch :application}.service"
      execute :sudo, "systemctl enable #{fetch :application}"
      execute :sudo, 'systemctl daemon-reload'
    end
  end
end
