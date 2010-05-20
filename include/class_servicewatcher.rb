class ServiceWatcher
	def self.plugin_class(string)
		object_name = "KnjServiceCheckerPlugin" + Php::ucwords(string)
		return Kernel.const_get(object_name)
	end
	
	def self.check_and_report(paras)
		begin
			paras["plugin"].check
			
			return {
				"errorstatus" => false
			}
		rescue => e
			paras["service"].reporters_merged.each do |reporter|
				reporter.reporter_plugin.report_error("reporter" => reporter, "error" => e, "plugin" => paras["plugin"], "service" => paras["service"])
			end
			
			return {
				"errorstatus" => true,
				"error" => e
			}
		end
	end
end