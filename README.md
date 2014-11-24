# Chulai

Rails PaaS

## Installation

    gem install chulai

## How to

sign up on http://wo.chulai.la/

    # create a new rails app
    rails new example
    cd example
    bundle install
    rails generate scaffold article title:string content:text
    bundle exec rake db:migrate
    cat <<EOF>config/routes.rb
    Rails.application.routes.draw do
      root :to => redirect("/articles")
      resources :articles
    end
    EOF

    # commit
    git init
    git add .
    git commit -m 'first commit'

    # deploy with chulai.la
    chulai
