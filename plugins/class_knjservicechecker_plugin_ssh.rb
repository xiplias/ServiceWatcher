class KnjServiceCheckerPluginSsh
	def self.paras
		return [
			{
				"type" => "text",
				"title" => _("Port"),
				"name" => "txtport"
			}
		]
	end
	
	def initialize(paras)
		@paras = paras
	end
	
	def check
		
	end
	
	def destroy
		@paras = nil
	end
end