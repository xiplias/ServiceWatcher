class ServiceWatcher
	def self.plugin_class(string)
		object_name = "KnjServiceCheckerPlugin" + ucwords(string)
		return Kernel.const_get(object_name)
	end
end