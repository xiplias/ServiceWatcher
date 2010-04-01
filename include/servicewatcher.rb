#Some Mac-users have problems (xiplias included). This safes them from complete crash and following horrors - knj.
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

require("knjrbfw/libautoconnect")
autoload :ServiceWatcher, File.dirname(__FILE__) + "/class_servicewatcher"

#Database.
$db = KnjDB.new(
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


#Locales.
include GetText
GetText::bindtextdomain("locales", "locales")