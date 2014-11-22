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
    echo 'Rails.application.routes.draw do
      root :to => redirect("/articles")
      resources :articles
    end' > config/routes.rb
    git init
    git add .
    git commit -m 'first commit'
    chulai
