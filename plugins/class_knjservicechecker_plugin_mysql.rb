class KnjServiceCheckerPluginMysql
	def self.paras
		return [
			{
				"type" => "text",
				"title" => _("Hostname"),
				"name" => "txthost"
			},
			{
				"type" => "text",
				"title" => _("Port"),
				"name" => "txtport",
				"default" => "3306"
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
				"title" => _("Database"),
				"name" => "txtdb",
				"default" => "mysql"
			}
		]
	end
	
	def self.check(paras)
		begin
			conn = Mysql.real_connect(paras["txthost"], paras["txtuser"], paras["txtpasswd"], paras["txtdb"], paras["txtport"].to_i)
		rescue => e
			raise "MySQL connection failed for #{paras["txtuser"]}@#{paras["txthost"]}:#{paras["txtdb"]}! - " + e.inspect
		end
	end
end