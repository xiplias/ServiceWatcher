class WinMain
	def initialize
		@gui = Gtk::Builder.new
		@gui.add_from_file("gui/win_main.ui")
		@gui.connect_signals(){|h|method(h)}
		@gui.translate
		
		@tv_servers = @gui["tvServers"]
		@tv_servers.init([_("ID"), _("Title")])
		@tv_servers.columns[0].visible = false
		@tv_servers.selection.signal_connect("changed"){on_tvServers_changed}
		
		@tv_services = @gui["tvServices"]
		@tv_services.init([_("ID"), _("Name")])
		@tv_services.columns[0].visible = false
		
		@window = @gui["window"]
		
		@window.show_all
		update_servers
	end
	
	def on_tvServices_button_press_event(widget, event)
		if (event.button == 3)
			KnjGtkMenu.new({
				"items" => {
					"add" => {
						"text" => _("Add new"),
						"connect" => [self, "on_addService_clicked"]
					},
					"edit" => {
						"text" => _("Edit service"),
						"connect" => [self, "on_editService_clicked"]
					},
					"del" => {
						"text" => _("Delete service"),
						"connect" => [self, "on_delService_clicked"]
					}
				}
			})
		end
	end
	
	def on_addService_clicked
		if (!@tv_servers.sel)
			msgbox(_("Please select a server and try again."))
			return nil
		end
		
		server = $objects.get("Server", @tv_servers.sel[0])
		WinServiceEdit.new({"transient_for" => @window, "server" => server, "win_main" => self})
	end
	
	def on_editService_clicked
		if (!@tv_servers.sel)
			msgbox(_("Please select a server and try again."))
			return nil
		end
		server = $objects.get("Server", @tv_servers.sel[0])
		
		sel = @tv_services.sel
		if (!sel)
			msgbox(_("Please select a service and try again."))
			return nil
		end
		
		service = $objects.get("Service", sel[0])
		WinServiceEdit.new({"transient_for" => @window, "service" => service, "server" => server, "win_main" => self})
	end
	
	def on_delService_clicked
		sel = @tv_services.sel
		if (!sel)
			msgbox(_("Please select a service and try again."))
			return nil
		end
		
		if (msgbox(_("Do you want to delete this service?"), "yesno") != "yes")
			return nil
		end
		
		service = $objects.get("Service", sel[0])
		$objects.delete(service)
		
		update_services
	end
	
	def update_servers
		@tv_servers.model.clear
		
		q_servers = $db.select("servers")
		while(d_servers = q_servers.fetch)
			@tv_servers.append([d_servers["id"], d_servers["name"]])
		end
	end
	
	def update_services
		@tv_services.model.clear
		
		sel = @tv_servers.sel
		if (!sel)
			return nil
		end
		
		server = $objects.get("Server", sel[0])
		server.services.each do |service|
			@tv_services.append([service["id"], service["name"]])
		end
	end
	
	def on_window_destroy
		Gtk::main_quit
	end
	
	def on_tvServers_changed
		sel = @tv_servers.sel
		if (sel)
			server = $db.single("servers", {"id" => sel[0]})
			@gui["txtName"].text = server["name"]
			@gui["txtHost"].text = server["host"]
		else
			@gui["txtName"].text = ""
			@gui["txtHost"].text = ""
		end
		
		update_services
	end
	
	def on_btnDelete_clicked
		sel = @tv_servers.sel
		
		if (!sel)
			msgbox(_("Please select a server to delete."))
			return nil
		end
		
		if (msgbox(_("Do you want to delete the server?"), "yesno") != "yes")
			return nil
		end
		
		server = $objects.get("Server", sel[0])
		$objects.delete(server)
		
		update_servers
	end
	
	def on_btnSave_clicked
		sel = @tv_servers.sel
		
		save_hash = {
			"name" => @gui["txtName"].text,
			"host" => @gui["txtHost"].text
		}
		
		if (!sel)
			$objects.add("Server", save_hash)
		else
			server = $objects.get("Server", sel[0])
			server.update(save_hash)
		end
		
		update_servers
	end
end