local module = {
	LastGeneratedID = 0,
	GenerateUniqueName = function(self, prefix:string?)
		if not prefix then
			prefix = "Unknown-"
		end
		self.LastGeneratedID += 1
		return prefix .. self.LastGeneratedID
	end
}

return module
