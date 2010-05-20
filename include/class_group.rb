class Group < Knj::Db_row
	def initialize(data)
		super("db" => $db, "table" => "groups", "data" => data, "objects" => $objects, "col_title" => "name")
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
end