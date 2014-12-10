# Simple Role Syntax
# ==================
role :app, %w{root@178.62.19.63}
role :web, %w{root@178.62.19.63}
role :db,  %w{root@178.62.19.63}

# Extended Server Syntax
# ======================
server '178.62.19.63', user: 'root', roles: %w{web app}, password: 'beef1234'



