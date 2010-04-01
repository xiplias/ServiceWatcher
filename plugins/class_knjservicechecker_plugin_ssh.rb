class KnjServiceCheckerPluginSsh
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
			}
		]
	end
	
	def initialize(paras)
		@paras = paras
	end
	
	def check
		sshrobot = SSHRobot.new(
			"host" => @paras["txthost"],
			"port" => @paras["txtport"],
			"user" => @paras["txtuser"],
			"passwd" => @paras["txtpasswd"]
		).getSession
	end
	
	def destroy
		@paras = nil
	end
end