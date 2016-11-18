set :stage, :production
set :branch, :production_test
set :deploy_to, '/u01/apps/qwinix/peershape-prod'
set :log_level, :debug

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
role :app, %w{deploy@api.peershape.com}
role :web, %w{deploy@api.peershape.com}
role :db, %w{deploy@api.peershape.com}

server 'api.peershape.com', roles: %w{:web, :app, :db}, user: 'deploy'

set :ssh_options, {
   #verbose: :debug,
   keys: %w(~/.ssh/id_rsa),
   auth_methods: %w(publickey)
}
