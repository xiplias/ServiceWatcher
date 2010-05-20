class Service < Knj::Db_row
	def initialize(data)
		super("table" => "services", "data" => data, "col_title" => "name")
	end
	
	def self.add(data)
		$db.insert("services", data)
		return $objects.get("Service", $db.last_id)
	end
	
	def self.list(paras = nil)
		sql = "SELECT * FROM services WHERE 1=1"
		
		if paras["group"]
			sql += " AND group_id = '" + paras["group"]["id"].sql + "'"
		end
		
		sql += " ORDER BY name"
		
		ret = []
		q_services = $db.query(sql)
		while d_services = q_services.fetch
			ret << $objects.get("Service", d_services)
		end
		
		return ret
	end
	
	def delete
		self.del_details
		$db.delete("services", {"id" => self["id"]})
	end
	
	def del_details
		$db.delete("services_options", {"service_id" => self["id"]})
	end
	
	def add_detail(name, data)
		$db.insert("services_options", {
			"service_id" => self["id"],
			"opt_name" => name,
			"opt_value" => data
		})
	end
	
	def details
		data = {}
		q_details = $db.select("services_options", {"service_id" => self["id"]})
		while d_details = q_details.fetch
			data[d_details["opt_name"]] = d_details["opt_value"]
		end
		
		return data
	end
	
	def reporters
		return $objects.list("Service_reporterlink", {"service" => self})
	end
	
	def reporters_merged
		reporters = []
		self.reporters.each do |link|
			reporters << link.reporter
		end
		
		group.reporters.each do |link|
			if !reporters.index(link.reporter)
				reporters << link.reporter
			end
		end
		
		return reporters
	end
	
	def group
		return $objects.get("Group", self["group_id"])
	end
end