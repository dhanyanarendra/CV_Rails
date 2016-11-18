set :stage, :uat
set :branch, :uat
set :deploy_to, '/u01/apps/qwinix/peershape_uat'
set :log_level, :debug

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
role :app, %w{deploy@uat-peershape-election-api.qwinix.io}
role :web, %w{deploy@uat-peershape-election-api.qwinix.io}
role :db, %w{deploy@uat-peershape-election-api.qwinix.io}
server 'uat-peershape-election-api.qwinix.io', roles: %w{:web, :app, :db}, user: 'deploy'

set :ssh_options, {
   #verbose: :debug,
   keys: %w(~/.ssh/id_rsa),
   auth_methods: %w(publickey)
}
