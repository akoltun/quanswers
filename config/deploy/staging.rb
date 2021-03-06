# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{sasha@192.168.1.100}
role :web, %w{sasha@192.168.1.100}
role :db,  %w{sasha@192.168.1.100}

set :rails_env, :staging
set :stage, :staging

set :branch, :staging

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '192.168.1.100', user: 'sasha', roles: %w{web app db}, primary: true


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
set :ssh_options, {
   keys: %w(/Users/sasha/.ssh/id_rsa),
   forward_agent: true,
   auth_methods: %w(publickey)
}
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

namespace :deploy do

  desc 'Modify alert'
  task :modifyalert do
    on roles(:app) do
      execute "rm #{release_path}/app/views/test/alert.js"
      execute "cp #{release_path}/frontend/alert.js #{release_path}/app/views/test/alert.js"
    end
  end

  after :updated, :modifyalert


end