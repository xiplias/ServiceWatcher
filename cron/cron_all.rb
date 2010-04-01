#!/usr/bin/ruby

Dir.chdir(File.dirname(__FILE__))
require("../include/servicewatcher.rb")

$objects.list("Service").each do |service|
	obj = ServiceWatcher.plugin_class(service["plugin"]).new(service.details)
	obj.check
end