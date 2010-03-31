class WinServiceEdit
	def initialize(paras)
		@paras = paras
		
		@gui = Gtk::Builder.new
		@gui.add_from_file("gui/win_service_edit.ui")
		@gui.connect_signals(){|h|method(h)}
		@gui.translate
		
		@window = @gui["window"]
		
		if (@paras["transient_for"])
			@window.transient_for = @paras["transient_for"]
		end
		
		@window.show_all
		update_plugins
		
		if (@paras["service"])
			@gui["txtName"].text = @paras["service"]["name"]
		else
			@gui["btnDelete"].hide
		end
		
		
	end
	
	def on_window_destroy
		@paras = nil
		@gui = nil
		@window = nil
	end
	
	def update_plugins
		items = []
		Dir.new("../../plugins").each do |file|
			if (file.slice(0, 1) != ".")
				items << file.slice(31..-4)
			end
		end
		
		@gui["cbPlugin"].init(items)
		@gui["cbPlugin"].active = 0
	end
	
	def on_cbPlugin_changed
		sel = @gui["cbPlugin"].sel
		text = sel["text"]
		
		object_file = "../../plugins/class_knjservicechecker_plugin_" + text + ".rb"
		object_str = "KnjServiceCheckerPlugin" + ucwords(text)
		
		require(object_file)
		paras = Kernel.const_get(object_str).paras
		
		table = Gtk::Table.new(paras.length, 2)
		table.row_spacings = 4
		table.column_spacings = 4
		top = 0
		@retd = {}
		
		paras.each do |item|
			label = Gtk::Label.new(item["title"])
			text = Gtk::Entry.new
			
			table.attach(label, 0, 1, top, top + 1, Gtk::SHRINK, Gtk::SHRINK)
			table.attach(text, 1, 2, top, top + 1, Gtk::EXPAND | Gtk::FILL, Gtk::SHRINK)
			
			@retd[item["name"]] = {
				"type" => "text",
				"object" => text
			}
			top += 1
		end
		
		@gui["boxPluginDetails"].add(table)
		table.show_all
	end
	
	def on_btnSave_clicked
		save_hash = {
			"name" => @gui["txtName"].text,
			"server_id" => @paras["server"]["id"]
		}
		
		if (!@paras["service"])
			service = $objects.add("Service", save_hash)
		else
			@paras["service"].update(save_hash)
			service = @paras["service"]
		end
		
		service.del_details
		@retd.each do |name, datahash|
			service.add_detail(name, datahash["object"].text)
		end
		
		if (@paras["win_main"])
			@paras["win_main"].update_services
		end
		
		@window.destroy
	end
	
	def on_btnDelete_clicked
		if (msgbox(_("Do you want to delete this service?"), "yesno") != "yes")
			return nil
		end
		
		$objects.delete(@paras["service"])
		@window.destroy
	end
end