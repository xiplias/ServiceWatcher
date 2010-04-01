$:.unshift File.expand_path('../vendor', __FILE__)
require 'thor'

module ServiceWatcher
  class CLI < Thor
    check_unknown_options! unless ARGV.include?("exec")

    desc "status", "See status of enabled plugins"
    def status
     
    end
    
    desc "gtk", "Launch the GTK interface"
    def gtk
      puts "Loading GTK interface..."
      Dir.chdir("interfaces/gtk")
      require("servicewatcher")
    end

    def initialize(*)
      super
      
      puts "\nWelcome to Service Watcher Commandline Interface\n\n"
    end
  end
end