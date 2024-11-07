local SharedClasses = require(script.Parent.SharedClasses)
local SyntaxBasics = require(script.Parent.SyntaxBasics)
local EWI = require(script.Parent.ErrorsWarnsInfos)
local Directives = require(script.Parent.Directives)
local VisualLibrary = require(script.Parent.VisualLibrary.Version2)
local VisualLibraryV3 = require(script.Parent.VisualLibrary.Version3SaveOnly)
local UniqueIDService = require(script.Parent.UniqueIDService)
local ProgrammingBlocksData = require(script.Parent.ProgrammingBlocksData)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

powerlang = {
	Parse = function(Source:string, Context:SharedClasses.ExecutableContext, ExtraPointer:SharedClasses.Pointer?, ParseUntil:string?)
		local TimeBegin = tick()
		-- Core only parses directives and handle context sharing.
		-- It does not process directive data
		
		local RootBlock = VisualLibrary.NewBlock("Comment2", GenerateUniqueName("ROOT-"), {
			VisualLibrary.NewInput("Comment", "ROOT"),
			VisualLibrary.NewInput("Color", BrickColor.new("Lime green"))
		})
		local BlocksCreatedHere = {RootBlock}
		
		local MainPointer:SharedClasses.Pointer = ExtraPointer or SharedClasses.Pointer(Source)
		local SharedContext:SharedClasses.SharedContext = SharedClasses.SharedContext(Context, MainPointer)
		local CurrentlyParsed = ""
		
		Context.Flags:SetFlag("AllowNoSemicolons")
		Context.Flags:SetFlag("MultilineCallsTest")

		local DirectiveBeginning = MainPointer.PointingTo
		
		while MainPointer.PointingTo < MainPointer.Maximum do
			local Character = MainPointer:GetPointedCharacter(Source)
			-- Indentation anyone?
			if #CurrentlyParsed == 0 and table.find(SyntaxBasics.Indentation, Character) then
				MainPointer:Increment()
				continue
			end
			if ParseUntil and string.find(ParseUntil, Character, nil, true) then
				MainPointer:Increment()
				break
			end
			-- Are we done parsing the directive?
			if Character == " " or Character == "\n" or Character == ";" then
				CurrentlyParsed = string.upper(CurrentlyParsed)
				-- hand over to directive handler if one found
				local DirectiveHandler = Directives[CurrentlyParsed]
				if not DirectiveHandler then
					MainPointer.PointingTo = DirectiveBeginning
					local BlocksCreatedByDirective:{VisualLibrary.AbstractBlock}, DoNotAttach = Directives.DECLARE(Source, MainPointer, SharedContext, Context, getfenv(debug.info(1, "f")))
					if #BlocksCreatedByDirective ~= 0 then
						if not DoNotAttach then
							RootBlock:ConnectToBlock(BlocksCreatedByDirective[1])
						end
						table.move(BlocksCreatedByDirective, 1, #BlocksCreatedByDirective, #BlocksCreatedHere + 1, BlocksCreatedHere)
					end
					CurrentlyParsed = ""
					DirectiveBeginning = MainPointer.PointingTo
					continue
				end
				
				-- Make sure this is future-extensible (there WILL be more outputs)
				local BlocksCreatedByDirective:{VisualLibrary.AbstractBlock}, DoNotAttach = DirectiveHandler(Source, MainPointer, SharedContext, Context, getfenv(debug.info(1, "f")))
				if #BlocksCreatedByDirective ~= 0 then
					if not DoNotAttach then
						RootBlock:ConnectToBlock(BlocksCreatedByDirective[1])
					end
					table.move(BlocksCreatedByDirective, 1, #BlocksCreatedByDirective, #BlocksCreatedHere + 1, BlocksCreatedHere)
				end
				CurrentlyParsed = ""
				DirectiveBeginning = MainPointer.PointingTo
				continue
			end
			-- If not, then is the directive so far valid?
			if not string.find(SyntaxBasics.AllowedCharsInDirectives, string.upper(Character), nil, true) then
				--EWI.Error(1, SharedContext, Context, "Unexpected character '" .. Character .. "' while parsing directive")
				--return
				MainPointer.PointingTo = DirectiveBeginning
				local BlocksCreatedByDirective:{VisualLibrary.AbstractBlock}, DoNotAttach = Directives.DECLARE(Source, MainPointer, SharedContext, Context, getfenv(debug.info(1, "f")))
				if #BlocksCreatedByDirective ~= 0 then
					if not DoNotAttach then
						RootBlock:ConnectToBlock(BlocksCreatedByDirective[1])
					end
					table.move(BlocksCreatedByDirective, 1, #BlocksCreatedByDirective, #BlocksCreatedHere + 1, BlocksCreatedHere)
				end
				CurrentlyParsed = ""
				DirectiveBeginning = MainPointer.PointingTo
				continue
			end

			CurrentlyParsed = CurrentlyParsed .. Character
			MainPointer:Increment()
			if #BlocksCreatedHere > 0 then
				Context.LastCreatedBlock = BlocksCreatedHere[#BlocksCreatedHere]
			end
		end
		if CurrentlyParsed ~= "" then
			EWI.Error(3, SharedContext, Context, "Reached end of file while parsing directive")
			return
		end
		local TimeEnd = tick()
		if not Context.IsSubBlock then
			-- Compiled with Powerlang on August 27th, 2014 at 1:50 PM EST
			if not Context.Flags:HasFlag("DoNotIncludeWatermark") then
				local CompileTimeStr = "Compiled with Powerlang on " .. os.date("%B %d, %Y at %I:%M %p %Z", TimeEnd)
				for i = 1, #CompileTimeStr do
					if string.byte(CompileTimeStr, i, i) > 127 then
						-- ascii-friendly
						CompileTimeStr = "Compiled with Powerlang on " .. os.date("%d.%m.%Y at %H:%M %z", TimeEnd)
						break
					end
				end
				local WatermarkBlock = VisualLibrary.NewBlock("Comment2", "Compiled with Powerlang", {
					VisualLibrary.NewInput("Comment", CompileTimeStr),
					VisualLibrary.NewInput("Color", BrickColor.new("Institutional white"))
				})
				WatermarkBlock.OwnTemplate = "%s%s0.00-1.27%s%s%s"
				table.insert(BlocksCreatedHere, WatermarkBlock)
			end
			if Context.Warns == 0 then
				print(string.format("Powerlang source compiled successfully. Time taken: %.2f seconds", TimeEnd - TimeBegin))
			else
				warn(string.format("Powerlang source compiled successfully with %d warning(s). Time taken: %.2f seconds", Context.Warns, TimeEnd - TimeBegin))
			end
			local VariableConversions = {}
			if not Context.Flags:HasFlag("BypassVariableAntiFilter") then
				for _, block in pairs(BlocksCreatedHere) do
					local inputs = {}
					if inputs then
						table.move(block.Inputs, 1, #block.Inputs, 1, inputs)
					end
					if block.InputTupleData then
						for _, tuple in pairs(block.InputTupleData) do
							for _, tupleinput in pairs(tuple.TupleValues) do
								table.insert(inputs, tupleinput)
							end
						end
					end
					
					local outputs = {}
					if outputs then
						table.move(block.Outputs, 1, #block.Outputs, 1, outputs)
					end
					if block.OutputTupleData then
						for _, tuple in pairs(block.OutputTupleData) do
							for _, tupleoutput in pairs(tuple.TupleValues) do
								table.insert(outputs, tupleoutput)
							end
						end
					end

					for _, input:VisualLibrary.BlockInput in pairs(inputs) do
						-- Only process inputs with variables or objects
						local IsSpecialDataType = false
						if ProgrammingBlocksData.BlocksList[block.BlockID].Inputs[input.InputName] and table.find({"Function", "Table", "EventConnection"}, ProgrammingBlocksData.BlocksList[block.BlockID].Inputs[input.InputName].VariableType) then
							IsSpecialDataType = true
						end
						if not input.InputValueIsVariableName and input.InputType ~= "Object" and not IsSpecialDataType then
							continue
						end
						if not input.ConvertedInputValue then
							warn("WARNING: " .. block.FriendlyName .. " has an invalid input")
							continue
						end
						-- If it's an object then
						if input.InputType == "Object" then
							local Elements = string.split(input.ConvertedInputValue, ".")
							local FirstElement = Elements[1]
							if table.find({"game", "script", "workspace"}, FirstElement) then
								continue
							end
							if VariableConversions[FirstElement] then
								Elements[1] = VariableConversions[FirstElement]
								input.ConvertedInputValue = table.concat(Elements, ".")
								continue
							end
							local GenericVariableName = UniqueIDService:GenerateUniqueName("var-")
							VariableConversions[FirstElement] = GenericVariableName
							Elements[1] = GenericVariableName
							input.ConvertedInputValue = table.concat(Elements, ".")
							continue
						end
						
						if table.find({"game", "script", "workspace"}, input.ConvertedInputValue) then
							continue
						end
						
						
						-- If it's a variable then
						if VariableConversions[input.ConvertedInputValue] then
							input.ConvertedInputValue = VariableConversions[input.ConvertedInputValue]
							continue
						end
						local GenericVariableName = UniqueIDService:GenerateUniqueName("var-")
						VariableConversions[input.ConvertedInputValue] = GenericVariableName
						input.ConvertedInputValue = GenericVariableName
					end
					for _, output:VisualLibrary.BlockOutput in pairs(outputs) do
						if VariableConversions[output.OutputVariable] then
							output.OutputVariable = VariableConversions[output.OutputVariable]
							continue
						end
						local GenericVariableName = UniqueIDService:GenerateUniqueName("var-")
						VariableConversions[output.OutputVariable] = GenericVariableName
						output.OutputVariable = GenericVariableName
					end
				end
			end
			if Context.Flags:HasFlag("UseVSV3") then
				UniqueIDService.LastGeneratedID = 0
				return VisualLibraryV3.SaveBlockArray(BlocksCreatedHere), Context.Warns
			else
				UniqueIDService.LastGeneratedID = 0
				return VisualLibrary.SaveBlockArray(BlocksCreatedHere), Context.Warns
			end
		else
			return BlocksCreatedHere
		end
	end,
}

return powerlang
