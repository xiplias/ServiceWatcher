#Some Mac-users have problems (Xiplias included). This safes them from a complete crash and following horrors - knj.
begin
	require "gettext"
rescue LoadError
	print "Notice: Could not load gettext-extension - using failover class.\n"
	
	module GetText
		def _(string)
			return string
		end
		
		def gettext(string)
			return string
		end
		
		def bindtextdomain(temp1, temp2)
			#nothing here.
		end
	end
end

require("knj/autoload")
include Knj
include Php

autoload :ServiceWatcher, File.dirname(__FILE__) + "/class_servicewatcher"

#Database.
$db = Knj::Db.new(
	"type" => "sqlite3",
	"path" => File.dirname(__FILE__) + "/../database/servicewatcher.sqlite3"
)


#Objects.
$objects = Knj::Objects.new(
	"db" => $db,
	"class_path" => File.dirname(__FILE__)
)


plugins_path = File.dirname(__FILE__) + "/../plugins"
Dir.new(plugins_path).entries.each do |plugin_file|
	if (plugin_file != "." and plugin_file != "..")
		eval_code = "autoload :KnjServiceCheckerPlugin" + ucwords(plugin_file.slice(31..-4)) + ", \"" + plugins_path + "/" + plugin_file + "\""
		eval(eval_code)
	end
end

reporters_path = File.dirname(__FILE__) + "/../reporters"
Dir.new(reporters_path).entries.each do |reporter_file|
	if (reporter_file != "." and reporter_file != "..")
		eval_code = "autoload :ServiceWatcherReporter" + ucwords(reporter_file.slice(30..-4)) + ", \"" + reporters_path + "/" + reporter_file + "\""
		eval(eval_code)
	end
end


#Locales.
include GetText
GetText::bindtextdomain("locales", "locales")