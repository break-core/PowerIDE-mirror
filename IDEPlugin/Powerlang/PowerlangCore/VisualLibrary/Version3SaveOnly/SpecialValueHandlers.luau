local module = {
	["BrickColor"] = function(In:BrickColor)
		return string.format("%X", In.Number)
	end,
	["Instance"] = function(In:Instance)
		return "game." .. In:GetFullName()
	end,
	["number"] = function(In:number)
		return string.format("%X", In)
	end,
	["bool"] = function(In:boolean)
		if In == true then
			return "1"
		end
		return "0"
	end,
}

return module
