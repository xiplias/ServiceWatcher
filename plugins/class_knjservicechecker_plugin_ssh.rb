class KnjServiceCheckerPluginSsh
	def self.paras
		return [
			{
				"type" => "text",
				"title" => _("Port"),
				"name" => "txtport",
				"default" => "22"
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
	
	def self.check(paras)
		begin
			sshrobot = Knj::SSHRobot.new(
				"host" => paras["txthost"],
				"port" => paras["txtport"],
				"user" => paras["txtuser"],
				"passwd" => paras["txtpasswd"]
			).session
		rescue => e
			raise "SSH connection failed for #{paras["txtuser"]}@#{paras["txthost"]}:#{paras["txtport"]}!"
		end
	end
end