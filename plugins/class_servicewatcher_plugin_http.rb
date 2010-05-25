class ServiceWatcherPluginHttp
	def self.paras
		return [
			{
				"title" => _("Port"),
				"name" => "txtport",
				"default" => "80"
			},
			{
				"title" => _("Hostname"),
				"name" => "txthost"
			},
			{
				"title" => _("Get address"),
				"name" => "txtaddr"
			},
			{
				"title" => _("SSL"),
				"name" => "chessl"
			}
		]
	end
	
	def self.check(paras)
		http = Net::HTTP.new(paras["txthost"], paras["txtport"])
		
		if (paras["chessl"] == "1")
			require "net/https"
			http.use_ssl = true
		end
		
		resp, data = http.get2("/" + paras["txtaddr"])
	end
end