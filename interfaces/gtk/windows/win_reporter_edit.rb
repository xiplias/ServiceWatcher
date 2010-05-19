class WinReporterEdit
	def initialize(paras = {})
		@paras = paras
		
		@gui = Gtk::Builder.new
		@gui.add_from_file("gui/win_reporter_edit.ui")
		@gui.connect_signals(){|h|method(h)}
		@gui.translate
		
		if (@paras["transient_for"])
			@gui["window"].transient_for = @paras["transient_for"]
		end
		
		update_plugins
		
		if (@paras["reporter"])
			@gui["txtName"].text = @paras["reporter"]["name"]
			@gui["cbReporters"].sel = @paras["reporter"]["plugin"]
			
			@paras["reporter"].details.each do |key, value|
				if (!@form["objects"][key])
					msgbox("Could not find: " + key)
				else
					Gtk2::form_setval(@form["objects"][key]["object"], value)
				end
			end
		end
		
		@gui["window"].show_all
	end
	
	def on_window_destroy
		@paras = nil
		@gui = nil
	end
	
	def update_plugins
		items = []
		Dir.new("../../reporters").each do |file|
			if (file.slice(0, 1) != ".")
				items << file.slice(30..-4)
			end
		end
		
		@gui["cbReporters"].init(items)
		@gui["cbReporters"].active = 0
	end
	
	def on_cbReporters_changed
		sel = @gui["cbReporters"].sel
		text = sel["text"]
		
		paras = Kernel.const_get("ServiceWatcherReporter" + Php::ucwords(text)).paras
		
		if (@form)
			@gui["vboxPluginDetails"].remove(@form["table"])
			@form["table"].destroy
		end
		
		@form = Gtk2::form(paras)
		@gui["vboxPluginDetails"].pack_start(@form["table"])
		@gui["vboxPluginDetails"].show_all
	end
	
	def on_btnSave_clicked
		sel = @gui["cbReporters"].sel
		save_hash = {
			"name" => @gui["txtName"].text,
			"plugin" => sel["text"]
		}
		
		if (@paras["reporter"])
			@paras["reporter"].update(save_hash)
			reporter = @paras["reporter"]
		else
			reporter = $objects.add("Reporter", save_hash)
		end
		
		reporter.del_details
		@form["objects"].each do |key, objhash|
			reporter.add_detail(key, Gtk2::form_getval(objhash["object"]))
		end
		
		if (@paras["win_service_edit"])
			@paras["win_service_edit"].update_reporters
		end
		
		@gui["window"].destroy
	end
	
	def on_btnCancel_clicked
		@gui["window"].destroy
	end
end