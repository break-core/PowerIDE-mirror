local SharedClasses = require(script.Parent.SharedClasses)
local SyntaxBasics = require(script.Parent.SyntaxBasics)
--local EWI = require(script.Parent.ErrorsWarnsInfos)

function NewToken(Content:string, Type:string, TokenBegin:number, TokenEnd:number?)
	return {Content=Content, Type=Type, TokenBegin=TokenBegin, TokenEnd=TokenEnd}
end

function find(String:string, Pattern:string)
	return string.find(String,Pattern,nil,true)
end

local module = {
	Tokenize = function(Source:string)
		local MainPointer = SharedClasses.Pointer(Source)
		
		local CurrentlyParsing = ""
		local LastTypeBeforeWhitespace = nil
		local CurrentlyParsingTokenType = nil
		local TokenBegin = nil
		local TokenEnd = nil
		local Tokens = {}
		local function ApplyCurrentToken(TokenBegin:number, TokenEnd:number?)
			if not TokenEnd then
				TokenEnd = MainPointer.PointingTo
			end
			if CurrentlyParsingTokenType then
				if CurrentlyParsingTokenType == "Variable" then
					if table.find(SyntaxBasics.LogicGates, CurrentlyParsing) then
						CurrentlyParsingTokenType = "Operator"
						TokenBegin = MainPointer.PointingTo
					end
					if table.find({"true", "false", "nil"}, CurrentlyParsing) then
						CurrentlyParsingTokenType = "Boolean"
					end
					if table.find({"if", "else", "for", "while", "advwhile", "tableloop", "and", "or", "not", "break", "continue", "event", "function", "return", "in"}, CurrentlyParsing:lower()) then
						CurrentlyParsingTokenType = "Keyword"
					end
					
				end
				if CurrentlyParsingTokenType == "Number" and CurrentlyParsing == "-" then
					CurrentlyParsingTokenType = "Operator"
					TokenBegin = MainPointer.PointingTo
				end
				if CurrentlyParsingTokenType == "Number" or CurrentlyParsingTokenType == "Variable" then
					if CurrentlyParsing:lower():sub(1, 5) == "@flag" or CurrentlyParsing:lower():sub(1, 2) == "--" then
						local Comment = false
						if CurrentlyParsing:lower():sub(1, 2) == "--" then
							Comment = true
						end
						while true do
							local CurrentChar = MainPointer:GetPointedCharacter(Source)
							if table.find({";", "\n"}, CurrentChar) then
								if Comment then
									CurrentlyParsingTokenType = "Comment"
								else
									CurrentlyParsingTokenType = "Flag"
								end
								break
							end
							CurrentlyParsing = CurrentlyParsing .. CurrentChar
							if not MainPointer:Increment() then
								if Comment then
									CurrentlyParsingTokenType = "Comment"
								else
									CurrentlyParsingTokenType = "Flag"
								end
								break
							end
						end
					end
				end
				TokenEnd = MainPointer.PointingTo
				table.insert(Tokens, NewToken(CurrentlyParsing, CurrentlyParsingTokenType, TokenBegin, TokenEnd))
				CurrentlyParsing = ""
				CurrentlyParsingTokenType = nil
			end
		end
		while MainPointer.PointingTo < MainPointer.Maximum do
			local Character = MainPointer:GetPointedCharacter(Source)
			-- Specials

			if table.find(SyntaxBasics.Indentation, Character) and (not CurrentlyParsingTokenType or table.find({"Number", "Operator", "Variable"}, CurrentlyParsingTokenType)) then
				LastTypeBeforeWhitespace = CurrentlyParsingTokenType or LastTypeBeforeWhitespace
				ApplyCurrentToken(TokenBegin)
				MainPointer:Increment()
				continue
			end
			if Character == "," then
				ApplyCurrentToken(TokenBegin)
				TokenBegin = MainPointer.PointingTo
				TokenEnd = MainPointer.PointingTo
				table.insert(Tokens, NewToken(Character, "Operator", TokenBegin, TokenEnd))
				MainPointer:Increment()
				continue
			end
			if find(SyntaxBasics.Operators, Character) then
				local chk = true
				if (Character == ".") and CurrentlyParsingTokenType == "Number" then
					chk = false
				end
				if (Character == "-") and (#Tokens == 0 or CurrentlyParsingTokenType == "Operator" or (not CurrentlyParsingTokenType and LastTypeBeforeWhitespace == "Operator") or (not CurrentlyParsingTokenType and not LastTypeBeforeWhitespace)) then
					chk = false
				end
				if chk then
					if CurrentlyParsingTokenType ~= "Operator" then
						TokenBegin = MainPointer.PointingTo
					end
					if CurrentlyParsingTokenType and CurrentlyParsingTokenType ~= "Operator" then
						TokenEnd = MainPointer.PointingTo
						table.insert(Tokens, NewToken(CurrentlyParsing, CurrentlyParsingTokenType, TokenBegin, TokenEnd))
						CurrentlyParsing = ""
						CurrentlyParsingTokenType = nil
						
					end
					CurrentlyParsing = CurrentlyParsing .. Character
					CurrentlyParsingTokenType = "Operator"
					MainPointer:Increment()
					continue
				end
			end
			if find("()", Character) then
				ApplyCurrentToken(TokenBegin)
				TokenBegin = MainPointer.PointingTo
				TokenEnd = MainPointer.PointingTo
				table.insert(Tokens, NewToken(Character, "Bracket", TokenBegin, TokenEnd))
				MainPointer:Increment()
				continue
			end
			if find("[]", Character) then
				ApplyCurrentToken(TokenBegin)
				TokenBegin = MainPointer.PointingTo
				TokenEnd = MainPointer.PointingTo
				table.insert(Tokens, NewToken(Character, "Index", TokenBegin, TokenEnd))
				MainPointer:Increment()
				continue
			end
			-- Number
			if (not CurrentlyParsingTokenType or CurrentlyParsingTokenType == "Operator") and find("-1234567890", Character) then
				if not (CurrentlyParsing == "-" and Character == "-") then
					ApplyCurrentToken(TokenBegin)
					TokenBegin = MainPointer.PointingTo
					CurrentlyParsingTokenType = "Number"
					CurrentlyParsing = CurrentlyParsing .. Character
					MainPointer:Increment()
					continue
				else
					CurrentlyParsingTokenType = "Variable"
					CurrentlyParsing = CurrentlyParsing .. Character
					MainPointer:Increment()
					continue
				end
			end
			if CurrentlyParsingTokenType == "Number" then
				CurrentlyParsing = CurrentlyParsing .. Character
				if CurrentlyParsing == "--" then
					CurrentlyParsingTokenType = "Variable"
				end
				MainPointer:Increment()
				continue
			end
			-- String
			if (not CurrentlyParsingTokenType or CurrentlyParsingTokenType == "Operator") and find(SyntaxBasics.StringOpeners, Character) then
				ApplyCurrentToken(TokenBegin)
				TokenBegin = MainPointer.PointingTo
				CurrentlyParsingTokenType = "String"
				MainPointer:Increment()
				while MainPointer.PointingTo < MainPointer.Maximum do
					local Character = MainPointer:GetPointedCharacter(Source)
					if find(SyntaxBasics.StringOpeners, Character) then
						TokenEnd = MainPointer.PointingTo + 1
						table.insert(Tokens, NewToken(CurrentlyParsing, "String", TokenBegin, TokenEnd))
						CurrentlyParsing = ""
						CurrentlyParsingTokenType = nil
						MainPointer:Increment()
						break
					end
					if Character == "\\" then
						MainPointer:Increment()
						Character = MainPointer:GetPointedCharacter(Source)
					end
					CurrentlyParsing = CurrentlyParsing .. Character
					MainPointer:Increment()
					if MainPointer.PointingTo == MainPointer.Maximum then
						break
					end
				end
				continue
			end
			
			-- Variable
			if (not CurrentlyParsingTokenType or CurrentlyParsingTokenType == "Operator" or CurrentlyParsingTokenType == "Variable") and find(SyntaxBasics.AllowedCharsInVariables, string.upper(Character)) then
				if CurrentlyParsingTokenType ~= "Variable" then
					ApplyCurrentToken(TokenBegin)
					TokenBegin = MainPointer.PointingTo
				end
				CurrentlyParsingTokenType = "Variable"
				CurrentlyParsing = CurrentlyParsing .. Character
				MainPointer:Increment()
				continue
			end
			MainPointer:Increment()
		end
		if CurrentlyParsingTokenType then
			TokenEnd = MainPointer.PointingTo
			ApplyCurrentToken(TokenBegin, TokenEnd)
		end
		return Tokens
	end,
}

return module
