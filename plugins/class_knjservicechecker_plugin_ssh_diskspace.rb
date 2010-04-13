class KnjServiceCheckerPluginSsh_diskspace
	def self.paras
		return [
			{
				"type" => "text",
				"title" => _("Port"),
				"name" => "txtport"
			},
			{
				"type" => "text",
				"title" => _("Hostname"),
				"name" => "txthost"
			},
			{
				"type" => "text",
				"title" => _("Username"),
				"name" => "txtuser"
			},
			{
				"type" => "password",
				"title" => _("Password"),
				"name" => "txtpasswd"
			},
			{
				"type" => "text",
				"title" => _("Path"),
				"name" => "txtpath"
			},
			{
				"type" => "text",
				"title" => _("Warning percent"),
				"name" => "txtwarnperc"
			}
		]
	end
	
	def initialize(paras)
		@paras = paras
	end
	
	def check
		sshrobot = Knj::SSHRobot.new(
			"host" => @paras["txthost"],
			"port" => @paras["txtport"].to_i,
			"user" => @paras["txtuser"],
			"passwd" => @paras["txtpasswd"]
		)
		sshrobot.getSession
		
		if (!is_numeric(@paras["txtwarnperc"]))
			raise "Warning percent is not numeric - please enter it correctly as number only."
		end
		
		warnperc = @paras["txtwarnperc"].to_i
		output = sshrobot.shellCMD("df -m -P " + Knj::Strings::UnixSafe(@paras["txtpath"]))
		
		match = output.match(/([0-9]+)%/)
		
		if (!match or !match[1] or !is_numeric(match[1]))
			raise _("Error in result from the server.")
		end
		
		if (match[1].to_i > warnperc)
			raise "Diskspace percent is " + match[1] + " - warning percent is " + warnperc.to_s + "."
		end
	end
	
	def destroy
		@paras = nil
	end
end