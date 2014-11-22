# Chulai

Rails PaaS

## Installation

    gem install chulai

## How to

sign up on http://wo.chulai.la/

    rails new example
    cd example
    bundle install
    rails generate scaffold article title:string content:text
    bundle exec rake db:migrate
    awk 'NR==2{print "  root :to => redirect(\"/articles\")"}1' \
      config/routes.rb | tee config/routes.rb
    git init
    git add .
    git commit -m 'first commit'
    chulai
