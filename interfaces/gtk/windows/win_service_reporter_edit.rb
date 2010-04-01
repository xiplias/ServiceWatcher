class WinServiceReporterEdit
	def initialize(paras = {})
		@paras = paras
		
		@gui = Gtk::Builder.new
		@gui.add_from_file("gui/win_service_reporter_edit.ui")
		@gui.connect_signals(){|h|method(h)}
		@gui.translate
		
		if (@paras["transient_for"])
			@gui["window"].transient_for = @paras["transient_for"]
		end
		
		update_plugins
		
		@gui["window"].show_all
		
		if (@paras["reporter"])
			
		end
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
		
	end
	
	def on_btnSave_clicked
		
	end
	
	def on_btnCancel_clicked
		
	end
end