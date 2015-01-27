role :app, %w{capistrano@kubosch.no}
role :web, %w{capistrano@kubosch.no}
role :db,  %w{capistrano@kubosch.no}

server 'kubosch.no', user: 'capistrano', roles: %w{web app}
