local module = {
	ParsePathForGet = function(path:string)
		local result = {
			Steps = {},
			InstanceCall = nil
		}
		for _, step in pairs(path:gsub(":", "."):split(".")) do
			table.insert(result.Steps, step)
		end
		if path:find(":", nil, true) then
			result.InstanceCall = result.Steps[#result.Steps]
			table.remove(result.Steps, #result.Steps)
		end
		return result
	end,
	ParsePathForSet = function(path:string)
		local result = {
			Steps = {},
			Property = nil
		}
		for _, step in pairs(path:gsub(":", "."):split(".")) do
			table.insert(result.Steps, step)
		end
		result.Property = result.Steps[#result.Steps]
		table.remove(result.Steps, #result.Steps)
		return result
	end,
}

return module
