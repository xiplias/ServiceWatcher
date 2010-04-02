class ServiceWatcherReporterEmail
	def self.paras
		return [
			{
				"type" => "text",
				"name" => "txtsmtphost",
				"title" => _("SMTP host"),
				"default" => "localhost"
			},
			{
				"type" => "text",
				"name" => "txtsmtpport",
				"title" => _("SMTP port"),
				"default" => "25"
			},
			{
				"type" => "text",
				"name" => "txtsmtpuser",
				"title" => _("SMTP user")
			},
			{
				"type" => "text",
				"name" => "txtsmtppasswd",
				"title" => _("SMTP password")
			},
			{
				"type" => "text",
				"name" => "txtaddress",
				"title" => _("Email address")
			},
			{
				"type" => "text",
				"name" => "txtfromaddress",
				"title" => _("From email address")
			},
			{
				"type" => "text",
				"name" => "txtsubject",
				"title" => _("Subject")
			}
		]
	end
	
	def initialize(paras)
		@paras = paras
	end
	
	def report_error(error_hash)
		details = error_hash["reporter"].details
		
		html = _("An error occurred") + "\n\n" + error_hash["error"].inspect
		
		mail = Knj::Mail.new(
			"from" => details["txtfromaddress"],
			"subject" => details["txtsubject"],
			"to" => details["txtaddress"],
			"html" => html
		)
		mail.send
		
		print "Report error: " + error_hash["error"].inspect
		#send email.
	end
end