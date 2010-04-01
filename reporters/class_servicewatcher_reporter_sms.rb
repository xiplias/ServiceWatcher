class ServiceWatcherReporterSms
	def self.paras
		return [
			{
				"type" => "text",
				"name" => "txtphonenumber",
				"title" => _("Phone number")
			}
		]
	end
	
	def initialize(paras)
		@paras = paras
	end
	
	def report_error(error_hash)
		#send sms.
	end
end