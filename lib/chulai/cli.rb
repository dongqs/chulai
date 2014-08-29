require 'thor'
require 'chulai'

module Chulai

  class CLI < Thor

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
