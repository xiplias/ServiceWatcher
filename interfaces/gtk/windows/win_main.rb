class WinMain
	def initialize
		@gui = Gtk::Builder.new
		@gui.add_from_file("gui/win_main.ui")
		@gui.connect_signals(){|h|method(h)}
		@gui.translate
		
		@tv_groups = @gui["tvGroups"]
		@tv_groups.init([_("ID"), _("Title")])
		@tv_groups.columns[0].visible = false
		@tv_groups.selection.signal_connect("changed"){on_tvGroups_changed}
		
		@tv_services = @gui["tvGroupServices"]
		@tv_services.init([_("ID"), _("Name")])
		@tv_services.columns[0].visible = false
		
		@tv_reporters = @gui["tvReporters"]
		@tv_reporters.init([_("ID"), _("Title"), _("Plugin")])
		@tv_reporters.columns[0].visible = false
		
		@tv_gdreporters = @gui["tvGroupDefaultReporters"]
		@tv_gdreporters.init([_("ID"), _("Title"), _("Plugin")])
		@tv_gdreporters.columns[0].visible = false
		
		@window = @gui["window"]
		@window.show_all
		
		$objects.connect("callback" => [self, "update_reporters"], "object" => "Reporter", "signals" => ["add", "update", "delete"])
		$objects.connect("callback" => [self, "update_groups"], "object" => "Group", "signals" => ["add", "update", "delete"])
		$objects.connect("callback" => [self, "update_services"], "object" => "Service", "signals" => ["add", "update", "delete"])
		$objects.connect("callback" => [self, "update_groupreporters"], "object" => "Group_reporterlink", "signals" => ["add", "update", "delete"])
		
		update_groups
		update_reporters
	end
	
	def on_tvGroupServices_button_press_event(widget, event)
		if (event.button == 3)
			Gtk2::Menu.new("items" => [
				[_("Add new"), [self, "on_addService_clicked"]],
				[_("Edit service"), [self, "on_editService_clicked"]],
				[_("Delete service"), [self, "on_delService_clicked"]],
				[_("Run"), [self, "on_runService_clicked"]]
			])
		end
	end
	
	def on_addService_clicked
		if (!@tv_groups.sel)
			msgbox(_("Please select a group and try again."))
			return nil
		end
		
		group = $objects.get("Group", @tv_groups.sel[0])
		WinServiceEdit.new({"transient_for" => @window, "group" => group, "win_main" => self})
	end
	
	def on_editService_clicked
		if (!@tv_groups.sel)
			msgbox(_("Please select a group and try again."))
			return nil
		end
		group = $objects.get("Group", @tv_groups.sel[0])
		
		sel = @tv_services.sel
		if (!sel)
			msgbox(_("Please select a service and try again."))
			return nil
		end
		
		service = $objects.get("Service", sel[0])
		WinServiceEdit.new({"transient_for" => @window, "service" => service, "group" => group, "win_main" => self})
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
	
	def on_runService_clicked
		sel = @tv_services.sel
		if (!sel)
			msgbox(_("Please select a service and try again."))
			return nil
		end
		
		service = $objects.get("Service", sel[0])
		obj = ServiceWatcher::plugin_class(service["plugin"]).new(service.details)
		
		result = ServiceWatcher::check_and_report("plugin" => obj, "service" => service)
		
		if (!result["errorstatus"])
			msgbox(_("The check was executed with success."))
		else
			puts result["error"].inspect
			print "\n"
			puts result["error"].backtrace
			print "\n\n"
			
			msgbox(_("The check returned an error.") + "\n\n" + result["error"].inspect)
		end
	end
	
	def update_groups(*paras)
		@tv_groups.model.clear
		
		q_groups = $db.select("groups")
		while(d_groups = q_groups.fetch)
			@tv_groups.append([d_groups["id"], d_groups["name"]])
		end
	end
	
	def update_services(*paras)
		@tv_services.model.clear
		
		sel = @tv_groups.sel
		if (!sel)
			return nil
		end
		
		group = $objects.get("Group", sel[0])
		group.services.each do |service|
			@tv_services.append([service["id"], service["name"]])
		end
	end
	
	def update_reporters(*paras)
		@tv_reporters.model.clear
		
		$objects.list("Reporter").each do |reporter|
			@tv_reporters.append([reporter["id"], reporter["name"], reporter.reporter_plugin.class.to_s])
		end
	end
	
	def update_groupreporters(*paras)
		@tv_gdreporters.model.clear
		
		self.group.reporters.each do |link|
			@tv_gdreporters.append([
				link.id,
				link.title,
				link.reporter.plugin.class.to_s
			])
		end
	end
	
	def on_window_destroy
		Gtk::main_quit
	end
	
	def group
		sel = @tv_groups.sel
		
		if !sel
			msgbox(_("Please select a group to delete."))
			return nil
		end
		
		return $objects.get("Group", sel[0])
	end
	
	def on_tvGroups_changed
		sel = @tv_groups.sel
		if sel
			group = $db.single("groups", {"id" => sel[0]})
			@gui["txtGroupName"].text = group["name"]
		else
			@gui["txtGroupName"].text = ""
		end
		
		update_services
		update_groupreporters
	end
	
	def on_btnDelete_clicked
		if msgbox(_("Do you want to delete the group?"), "yesno") != "yes"
			return nil
		end
		
		$objects.delete(self.group)
	end
	
	def on_btnSave_clicked
		save_hash = {
			"name" => @gui["txtGroupName"].text
		}
		
		if !self.group
			$objects.add("Group", save_hash)
		else
			self.group.update(save_hash)
		end
	end
	
	def on_tvReporters_button_press_event(widget, event)
		if event.button == 3
			Gtk2::Menu.new("items" => [
				[_("Add new"), [self, "on_addReporter_clicked"]],
				[_("Edit"), [self, "on_editReporter_clicked"]],
				[_("Delete"), [self, "on_delReporter_clicked"]]
			])
		end
	end
	
	def on_addReporter_clicked
		WinReporterEdit.new
	end
	
	def on_editReporter_clicked
		sel = @tv_reporters.sel
		if !sel
			msgbox(_("Please select a reporter and try again."))
			return nil
		end
		
		reporter = $objects.get("Reporter", sel[0])
		WinReporterEdit.new("reporter" => reporter)
	end
	
	def on_delReporter_clicked
		sel = @tv_reporters.sel
		if !sel
			msgbox(_("Please select a reporter and try again."))
			return nil
		end
		
		if msgbox(_("Do you want to delete this reporter?"), "yesno") != "yes"
			return nil
		end
		
		reporter = $objects.get("Reporter", sel[0])
		$objects.delete(reporter)
		update_reporters
	end
	
	def on_tvGroupDefaultReporters_button_press_event(widget, event)
		if event.button == 3
			Gtk2::Menu.new("items" => [
				[_("Add new"), [self, "on_addGroupReporter_clicked"]],
				[_("Delete"), [self, "on_delGroupReporter_clicked"]]
			])
		end
	end
	
	def on_addGroupReporter_clicked
		reporter = Gtk2::msgbox(
			"title" => _("Choose reporter"),
			"type" => "list",
			"items" => $objects.list("Reporter")
		)
		
		if !reporter
			return false
		end
		
		begin
			rlink = $objects.add("Group_reporterlink", {
				"reporter_id" => reporter["id"],
				"group_id" => self.group["id"]
			})
		rescue Errors::Notice => e
			msgbox(e.message)
		end
	end
	
	def on_delGroupReporter_clicked
		sel = @tv_gdreporters.sel
		if !sel
			msgbox(_("Please select a reporter and try again."))
			return nil
		end
		
		if msgbox(_("Do you want to remove this reporter?"), "yesno") != "yes"
			return nil
		end
		
		link = $objects.get("Group_reporterlink", sel[0])
		$objects.delete(link)
	end
end