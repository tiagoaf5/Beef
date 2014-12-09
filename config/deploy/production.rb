# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{root@178.62.19.63}
role :web, %w{root@178.62.19.63}
role :db,  %w{root@178.62.19.63}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '178.62.19.63', user: 'root', roles: %w{web app}, password: 'beef1234'



