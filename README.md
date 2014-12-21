LDSO - be&f
====

Instructions to deploy the application for production:
* Run
```
cap production deploy
```


Instructions to run the application in a development environment:
* Create user beef_db with password beef_db in local PostgreSQL instalation
```
sudo -u postgres createuser beef_db -s
sudo -u postgres psql
#inside postgres console type
\password beef_db
#then write "beef_db" after "Password:"
beef_db
#to exit the prompt
\q
```
*If there are any problems setting up the user/password, follow the instructions from here: https://gorails.com/setup/ubuntu/14.04#postgresql, including the installation
* Install dependencies
```
bundle install
```
* Create db, load schema and seed (Can give errors/warnings if no schema or seeds defined, but that's ok)
```
rake db:setup
```
* Run application on localhost port 3000
```
rails s
```

