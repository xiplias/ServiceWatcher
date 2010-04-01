require("knjrbfw/libautoconnect")

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
		print "File: " + plugin_file + "\n"
		eval_code = "autoload :KnjServiceCheckerPlugin" + ucwords(plugin_file.slice(23))
		print eval_code + "\n"
	end
end


#Locales.
begin
	require "gettext2"
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

include GetText
GetText::bindtextdomain("locales", "locales")