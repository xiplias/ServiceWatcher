class Group_reporterlink < Knj::Db_row
	def initialize(data)
		super("table" => "groups_reporterlinks", "data" => data)
	end
	
	def self.add(data)
		group = $objects.get("Group", data["group_id"])
		reporter = $objects.get("Reporter", data["reporter_id"])
		
		link = $objects.list("Group_reporterlink", {"group" => group, "reporter" => reporter})
		if link.length > 0
			raise Errors::Notice, _("Such a reporter is already added to that group.")
		end
		
		$db.insert("groups_reporterlinks", data)
		return $objects.get("Group_reporterlink", $db.last_id)
	end
	
	def self.list(paras = {})
		sql = "SELECT * FROM groups_reporterlinks WHERE 1=1"
		
		if paras["group"]
			sql += " AND group_id = '#{paras["group"].id.sql}'"
		end
		
		if paras["reporter"]
			sql += " AND reporter_id = '#{paras["reporter"].id.sql}'"
		end
		
		ret = []
		q_links = $db.query(sql)
		while d_links = q_links.fetch
			ret << $objects.get("Group_reporterlink", d_links)
		end
		
		return ret
	end
	
	def group
		return $objects.get("Group", self["group_id"])
	end
	
	def reporter
		return $objects.get("Reporter", self["reporter_id"])
	end
	
	def title
		return self.reporter.title
	end
end