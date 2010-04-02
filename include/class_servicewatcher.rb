class ServiceWatcher
	def self.plugin_class(string)
		object_name = "KnjServiceCheckerPlugin" + ucwords(string)
		return Kernel.const_get(object_name)
	end
	
	def self.check_and_report(paras)
		begin
			paras["plugin"].check
		rescue => e
			paras["service"].reporters.each do |reporter|
				reporter.reporter_plugin.report_error("reporter" => reporter, "error" => e, "plugin" => paras["plugin"], "service" => paras["service"])
			end
		end
	end
end