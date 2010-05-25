class KnjServiceCheckerPluginHttp
	def self.paras
		return [
			{
				"type" => "text",
				"title" => _("Port"),
				"name" => "txtport",
				"default" => "80"
			},
			{
				"type" => "text",
				"title" => _("Hostname"),
				"name" => "txthost"
			},
			{
				"type" => "text",
				"title" => _("Get address"),
				"name" => "txtaddr"
			},
			{
				"type" => "check",
				"title" => _("SSL"),
				"name" => "chessl"
			}
		]
	end
	
	def check(paras)
		http = Net::HTTP.new(paras["txthost"], paras["txtport"])
		
		if (paras["chessl"] == "1")
			require "net/https"
			http.use_ssl = true
		end
		
		resp, data = http.get2("/" + paras["txtaddr"])
	end
end