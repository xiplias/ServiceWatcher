class Group < Knj::Db_row
	def initialize(data)
		super("table" => "groups", "data" => data, "col_title" => "name")
	end
	
	def self.list(paras = {})
		sql = "SELECT * FROM groups WHERE 1=1 ORDER BY name"
		
		ret = []
		q_groups = $db.query(sql)
		while d_groups = q_groups.fetch
			ret << $objects.get("Group", d_groups)
		end
		
		return ret
	end
	
	def self.add(data)
		$db.insert("groups", data)
		return $objects.get("Group", $db.last_id)
	end
	
	def delete
		$db.delete("groups", {"id" => self["id"]})
	end
	
	def services
		return $objects.list("Service", {"group" => self})
	end
	
	def reporters
		return $objects.list("Group_reporterlink", {"group" => self})
	end
end