#!/usr/bin/ruby

require "knj/autoload"
Knj::Os.chdir_file(__FILE__)
require "../include/servicewatcher.rb"

$objects.list("Service").each do |service|
	obj = ServiceWatcher.plugin_class(service["plugin"]).new(service.details)
	ServiceWatcher.check_and_report("plugin" => obj, "service" => service)
end