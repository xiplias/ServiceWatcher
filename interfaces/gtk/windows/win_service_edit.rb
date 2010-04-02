class WinServiceEdit
	def initialize(paras = {})
		@paras = paras
		
		@gui = Gtk::Builder.new
		@gui.add_from_file("gui/win_service_edit.ui")
		@gui.connect_signals(){|h|method(h)}
		@gui.translate
		
		@window = @gui["window"]
		
		if (@paras["transient_for"])
			@window.transient_for = @paras["transient_for"]
		end
		
		update_plugins
		
		if (@paras["service"])
			@gui["txtName"].text = @paras["service"]["name"]
			@gui["cbPlugin"].sel = @paras["service"]["plugin"]
			
			@paras["service"].details.each do |key, value|
				@form["objects"][key]["object"].text = value
			end
			
			@tv_reporters = @gui["tvReporters"]
			@tv_reporters.init([_("ID"), _("Title"), _("Value")])
			@tv_reporters.columns[0].visible = false
			
			update_reporters
		end
		
		@window.show_all
		
		if (!@paras["service"])
			@gui["btnDelete"].hide
			@gui["frameReporters"].hide
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
	
	def update_reporters
		@tv_reporters.model.clear
		
		@paras["service"].reporters.each do |reporter|
			@tv_reporters.append([reporter["id"], reporter["plugin"], reporter["plugin"]])
		end
	end
	
	def on_cbPlugin_changed
		sel = @gui["cbPlugin"].sel
		text = sel["text"]
		
		paras = Kernel.const_get("KnjServiceCheckerPlugin" + ucwords(text)).paras
		
		if (@form)
			@gui["boxPluginDetails"].remove(@form["table"])
			@form["table"].destroy
		end
		
		@form = Knj::Gtk2::form(paras)
		@gui["boxPluginDetails"].add(@form["table"])
		@form["table"].show_all
	end
	
	def on_btnSave_clicked
		save_hash = {
			"name" => @gui["txtName"].text,
			"server_id" => @paras["server"]["id"],
			"plugin" => @gui["cbPlugin"].sel["text"]
		}
		
		if (!@paras["service"])
			service = $objects.add("Service", save_hash)
		else
			@paras["service"].update(save_hash)
			service = @paras["service"]
		end
		
		service.del_details
		@form["objects"].each do |name, datahash|
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
	
	def on_tvReporters_button_press_event(widget, event)
		if (event.button == 3)
			KnjGtkMenu.new(
				"items" => {
					"add" => {
						"text" => _("Add new"),
						"connect" => [self, "on_addReporter_clicked"]
					},
					"edit" => {
						"text" => _("Edit reporter"),
						"connect" => [self, "on_editReporter_clicked"]
					},
					"del" => {
						"text" => _("Delete reporter"),
						"connect" => [self, "on_delReporter_clicked"]
					}
				}
			)
		end
	end
	
	def on_addReporter_clicked
		WinServiceReporterEdit.new("transient_for" => @gui["window"], "service" => @paras["service"], "win_service_edit" => self)
	end
	
	def on_editReporter_clicked
		reporter_sel = @tv_reporters.sel
		if (!reporter_sel)
			msgbox(_("Please select a reporter and try again."))
			return nil
		end
		
		reporter = $objects.get("Reporter", reporter_sel[0])
		WinServiceReporterEdit.new("transient_for" => @gui["window"], "service" => @paras["service"], "reporter" => reporter, "win_service_edit" => self)
	end
	
	def on_delReporter_clicked
		reporter_sel = @tv_reporters.sel
		if (!reporter_sel)
			msgbox(_("Please select a reporter and try again."))
			return nil
		end
		
		if (msgbox(_("Do you want to delete this reporter?"), "yesno") != "yes")
			return nil
		end
		
		reporter = $objects.get("Reporter", reporter_sel[0])
		reporter.delete
		
		update_reporters
	end
end