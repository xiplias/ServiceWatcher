class Server < Knj::Db_row
	def initialize(data)
		super("db" => $db, "table" => "servers", "data" => data, "col_title" => "name")
	end
	
	def self.add(data)
		$db.insert("servers", data)
		return $objects.get("Server", $db.last_id)
	end
	
	def delete
		$db.delete("servers", {"id" => self["id"]})
	end
	
	def services
		return $objects.list("Service", {"server" => self})
	end
end