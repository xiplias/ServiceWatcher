class ServiceWatcherReporterEmail
	def self.paras
		return [
			{
				"type" => "text",
				"name" => "txtaddress",
				"title" => _("Email address")
			}
		]
	end
	
	def initialize(paras)
		@paras = paras
	end
	
	def report_error(error_hash)
		#send email.
	end
end