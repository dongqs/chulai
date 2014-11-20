require 'thor'
require 'chulai'

module Chulai

  class CLI < Thor

    default_task :deploy

    desc "deploy", "Deploy the newest version"
    def deploy
      base = Base.new
      base.gemfile
      base.account
      base.ssh_key
      base.ssh_config
      base.push
      base.deploy
      base.open
    end

    desc "version", "Prints the chulai's version infomation"
    def version
      puts "chulai #{Chulai::VERSION}"
    end
    map %w(-v --version) => :version

    desc "status", "Prints the chulai server status"
    def status
      puts "chulai server #{Chulai::Base.status}"
    end
  end
end
