class Service_reporterlink < Knj::Db_row
	def initialize(data)
		super("table" => "services_reporterlinks", "data" => data)
	end
	
	def self.list(paras = {})
		sql = "SELECT * FROM services_reporterlinks WHERE 1=1"
		
		if paras["service"]
			sql += " AND service_id = '#{paras["service"].id.sql}'"
		end
		
		if paras["reporter"]
			sql += " AND reporter_id = '#{paras["reporter"].id.sql}'"
		end
		
		ret = []
		q_links = $db.query(sql)
		while d_links = q_links.fetch
			ret << $objects.get("Service_reporterlink", d_links)
		end
		
		return ret
	end
	
	def self.add(data)
		service = $objects.get("Service", data["service_id"])
		reporter = $objects.get("Reporter", data["reporter_id"])
		
		link = $objects.list("Service_reporterlink", {"service" => service, "reporter" => reporter})
		if link.length > 0
			raise Errors::Notice, _("Such a reporter is already added for that service.")
		end
		
		$db.insert("services_reporterlinks", data)
		return $objects.get("Service_reporterlink", $db.last_id)
	end
	
	def reporter
		return $objects.get("Reporter", self["reporter_id"])
	end
	
	def service
		return $objects.get("Service", self["service_id"])
	end
	
	def title
		return self.reporter.title
	end
end