#!/usr/bin/ruby

Dir.chdir(File.dirname(__FILE__))

autoload :WinServiceEdit, "windows/win_service_edit"
autoload :WinMain, "windows/win_main"

#Required files.
require("../../include/servicewatcher")
require("gtk2")
require("knjrbfw/libknjgtk")
require("knjrbfw/libknjgtk_tv")
require("knjrbfw/libknjgtk_cb")
require("knjrbfw/libknjphpfuncs")
require("knjrbfw/libknjweb")

WinMain.new
Gtk::main