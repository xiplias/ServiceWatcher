class KnjServiceCheckerPluginSsh_ftp
	def self.paras
		return [
			{
				"title" => _("SSH hostname"),
				"name" => "txtsshhost"
			},
			{
				"title" => _("SSH port"),
				"name" => "txtsshport",
				"default" => "22"
			},
			{
				"title" => _("SSH username"),
				"name" => "txtsshuser"
			},
			{
				"type" => "password",
				"title" => _("SSH password"),
				"name" => "txtsshpasswd"
			},
			{
				"title" => _("FTP hostname"),
				"name" => "txtftphost"
			},
			{
				"title" => _("FTP port"),
				"name" => "txtftpport"
			},
			{
				"title" => _("FTP username"),
				"name" => "txtftpuser"
			},
			{
				"title" => _("FTP password"),
				"name" => "txtftppasswd",
				"type" => "password"
			}
		]
	end
	
	def initialize(paras)
		@paras = paras
	end
	
	def check
		sshrobot = Knj::SSHRobot.new(
			"host" => @paras["txtsshhost"],
			"port" => @paras["txtsshport"].to_i,
			"user" => @paras["txtsshuser"],
			"passwd" => @paras["txtsshpasswd"]
		)
		sshrobot.session
		
		if !sshrobot.fileExists("/usr/bin/lftp")
			raise "lftp is not installed on server."
		end
		
		output = sshrobot.exec("/usr/bin/lftp #{@paras["txtftphost"]} -p #{@paras["txtftpport"]} -u #{@paras["txtftpuser"]},#{@paras["txtftppasswd"]} -d -e \"ls;quit\"")
		
		if !output.index("<--- 226 Transfer complete")
			raise output
		end
	end
	
	def destroy
		@paras = nil
	end
end