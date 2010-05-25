#!/usr/bin/ruby

require "knj/autoload"
print "Homedir: " + Knj::Os.homedir + "\n"

Knj::Os.chdir_file(__FILE__)
require "../include/servicewatcher.rb"

$objects.list("Service").each do |service|
	ServiceWatcher.check_and_report(service)
end