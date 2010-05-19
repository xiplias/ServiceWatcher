class Reporter < Knj::Db_row
	def initialize(data)
		super("db" => $db, "table" => "reporters", "data" => data, "col_title" => "plugin")
	end
	
	def self.add(data)
		$db.insert("reporters", data)
		return $objects.get("Reporter", $db.last_id)
	end
	
	def self.list(paras = {})
		sql = "SELECT * FROM reporters WHERE 1=1 ORDER BY id"
		
		ret = []
		q_reps = $db.query(sql)
		while d_reps = q_reps.fetch
			ret << $objects.get("Reporter", d_reps)
		end
		
		return ret
	end
	
	def delete
		self.del_details
		$db.delete("reporters", {"id" => self["id"]})
	end
	
	def del_details
		$db.delete("reporters_options", {"reporter_id" => self["id"]})
	end
	
	def details
		data = {}
		q_details = $db.select("reporters_options", {"reporter_id" => self["id"]})
		while(d_details = q_details.fetch)
			data[d_details["opt_name"]] = d_details["opt_value"]
		end
		
		return data
	end
	
	def add_detail(name, value)
		$db.insert("reporters_options", {"reporter_id" => self["id"], "opt_name" => name, "opt_value" => value})
	end
	
	def reporter_plugin
		obj_name = "ServiceWatcherReporter" + Php::ucwords(self["plugin"])
		return Kernel.const_get(obj_name).new(self.details)
	end
end