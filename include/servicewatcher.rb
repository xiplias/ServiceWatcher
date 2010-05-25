#Some Mac-users have problems (Xiplias included). This saves them from a complete crash and following horrors - knj.
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

require "knj/autoload"
require "knj/web" #for String::sql and String::html - knj.

include Knj

autoload :ServiceWatcher, File.dirname(__FILE__) + "/class_servicewatcher"

#Database.
sw_path = Knj::Os.homedir + "/.servicewatcher"
dbpath = sw_path + "/servicewatcher.sqlite3"
samplepath = File.dirname(__FILE__) + "/../database/servicewatcher_sample.sqlite3"

if !File.exists?(sw_path)
	FileUtils.mkdir_p(sw_path)
end

if !File.exists?(dbpath)
	FileUtils.cp_r(samplepath, dbpath)
end

$db = Knj::Db.new(
	"type" => "sqlite3",
	"path" => dbpath
)


#Objects.
$objects = Knj::Objects.new(
	"db" => $db,
	"class_path" => File.dirname(__FILE__)
)


plugins_path = File.dirname(__FILE__) + "/../plugins"
Dir.new(plugins_path).entries.each do |plugin_file|
	if (plugin_file != "." and plugin_file != "..")
		autoload(("ServiceWatcherPlugin" + Php.ucwords(plugin_file.slice(28..-4))).to_sym, plugins_path + "/" + plugin_file)
	end
end

reporters_path = File.dirname(__FILE__) + "/../reporters"
Dir.new(reporters_path).entries.each do |reporter_file|
	if (reporter_file != "." and reporter_file != "..")
		autoload(("ServiceWatcherReporter" + Php.ucwords(reporter_file.slice(30..-4))).to_sym, reporters_path + "/" + reporter_file)
	end
end


#Locales.
include GetText
GetText.bindtextdomain("locales", "locales")