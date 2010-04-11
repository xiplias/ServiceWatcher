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
				"name" => "txtdb"
			}
		]
	end
	
	def initialize(paras)
		@paras = paras
	end
	
	def check
		begin
			conn = Mysql.real_connect(@paras["txthost"], @paras["txtuser"], @paras["txtpasswd"], @paras["txtdb"])
		rescue => e
			raise "MySQL connection failed for #{@paras["txtuser"]}@#{@paras["txthost"]}:#{@paras["txtdb"]}! - " + e.inspect
		end
	end
	
	def destroy
		@paras = nil
	end
end