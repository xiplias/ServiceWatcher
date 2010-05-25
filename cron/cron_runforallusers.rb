#!/usr/bin/env ruby

require "knj/autoload"
list = Knj::Sysuser.list

list.each do |sysuser|
	sw_db_path = sysuser["home"] + "/.servicewatcher/servicewatcher.sqlite3"
	
	if File.exists?(sw_db_path)
		print %x[/usr/bin/sudo -u #{sysuser["nick"]} ruby /opt/servicewatcher/cron/cron_all.rb]
	end
end