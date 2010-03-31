#!/usr/bin/ruby

Dir.chdir(File.dirname(__FILE__))

autoload :WinServiceEdit, "windows/win_service_edit"
autoload :WinMain, "windows/win_main"

#Required files.
require("gtk2")
require("knjrbfw/libautoconnect")
require("knjrbfw/libknjgtk")
require("knjrbfw/libknjgtk_tv")
require("knjrbfw/libknjgtk_cb")
require("knjrbfw/libknjphpfuncs")
require("knjrbfw/libknjweb")


#Database.
$db = KnjDB.new({
	"type" => "sqlite3",
	"path" => "etc/knjservicechecker.sqlite3"
})


#Objects.
$objects = Knj::Objects.new({
	"db" => $db,
	"class_path" => "include"
})


#Locales.
include GetText
bindtextdomain("locales", "locales")


WinMain.new
Gtk::main