class KnjServiceCheckerPluginMail
	def self.paras
		return [
			{
				"type" => "text",
				"title" => _("Host"),
				"name" => "txthost"
			},
			{
				"type" => "text",
				"title" => _("Port"),
				"name" => "txtport"
			},
			{
				"type" => "select",
				"title" => _("Type"),
				"opts" => [_("POP"), _("IMAP"), _("SMTP")],
				"name" => "seltype"
			},
			{
				"type" => "check",
				"title" => _("SSL"),
				"name" => "chessl"
			},
			{
				"type" => "text",
				"title" => _("Username"),
				"name" => "txtuser"
			},
			{
				"type" => "password",
				"title" => _("Password"),
				"name" => "txtpass"
			}
		]
	end
	
	def initialize(paras)
		@paras = paras
	end
	
	def check
		if @paras["chessl"] == "1"
			sslval = true
		else
			sslval = false
		end
		
		if @paras["seltype"] == "IMAP"
			conn = Net::IMAP.new(@paras["txthost"], @paras["txtport"].to_i, sslval)
			conn.login(@paras["txtuser"], @paras["txtpass"])
		elsif @paras["seltype"] == "POP"
			conn = Net::POP.new(@paras["txthost"], @paras["txtport"].to_i, sslval)
			conn.start(@paras["txtuser"], @paras["txtpass"])
		elsif @paras["seltype"] == "SMTP"
			conn = Net::SMTP.new(@paras["txthost"], @paras["txtport"].to_i)
			
			if (sslval)
				conn.enable_ssl
			end
			
			conn.start(@paras["txthost"], @paras["txtuser"], @paras["txtpass"]) do |smtp|
				#nothing here.
			end
		end
	end
	
	def destroy
		@paras = nil
	end
end