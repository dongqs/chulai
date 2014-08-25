require 'thor'
require 'chulai'

module Chulai

  class CLI < Thor

    desc "version", "Prints the chulai's version infomation"
    def version
      puts "chulai #{Chulai::VERSION}"
    end
    map %w(-v --version) => :version

  end
end
