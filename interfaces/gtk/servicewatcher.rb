#!/usr/bin/ruby

require "knj/autoload"
Knj::Os.chdir_file(__FILE__)

autoload :WinServiceEdit, "windows/win_service_edit"
autoload :WinMain, "windows/win_main"
autoload :WinReporterEdit, "windows/win_reporter_edit"

#Required files.
require("../../include/servicewatcher.rb")
include Gtk2

require("knj/gtk2_tv")
require("knj/gtk2_cb")
require("knj/web")

WinMain.new
Gtk.main