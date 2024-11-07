-- Library for interfacing with RetroStudio's
-- VisualSource scripting format
-- of version 2

-- Scripted by vopwn55 on 16/08/2024

-- Always add a bit of innocence to your code: 😇😇😇😇😇😇😇😇

local RetroCompress = require(script.RetroCompress)
local SpecialValueHandlers = require(script.SpecialValueHandlers)

export type BlockContainer = {
	Container:{AbstractBlock},
	LastBlock:AbstractBlock?,
	NewBlock:(self:BlockContainer, BlockID:string, FriendlyName:string?, InputsOutputs:{BlockInput | BlockTupleInput | BlockOutput | BlockTupleOutput}?)->(AbstractBlock),
	NewLastConnectedBlock:(self:BlockContainer, BlockID:string, FriendlyName:string?, InputsOutputs:{BlockInput | BlockTupleInput | BlockOutput | BlockTupleOutput}?)->(AbstractBlock),
	AddLastConnectedBlock:(self:BlockContainer, block:AbstractBlock)->(),
	SaveContainer:(self:BlockContainer) -> (string),
	LoadContainer:(self:BlockContainer, Source:string) -> ({AbstractBlock}),
}

export type BlockInput = {
	InputName:string,
	InputValue:any,
	InputType:any,
	InputValueIsVariableName:boolean,
	ConvertedInputValue:any
}

export type BlockTupleInput = {
	TupleValues:{BlockInput},
	TupleName:string
}

export type BlockTupleOutput = {
	TupleValues:{BlockOutput},
	TupleName:string,
	IsOutputTuple:boolean
}

export type BlockOutput = {
	OutputName:string,
	OutputVariable:any,
}

export type AbstractBlock = {
	FriendlyName:string,
	BlockID:string,
	ConnectedChildren:{string},
	Inputs:{BlockInput}?,
	TupleInputs:{BlockTupleInput}?,
	Outputs:{BlockOutput}?,
	TupleOutputs:{BlockTupleOutput}?,
	ToVisualSource:(self:AbstractBlock)->(string),
	ConnectToBlock:(self:AbstractBlock, AbstractBlock)->(),
	ConnectToFriendlyName:(self:AbstractBlock, string)->(),
	DisconnectFromBlock:(self:AbstractBlock, AbstractBlock)->(),
	DisconnectFromFriendlyName:(self:AbstractBlock, string)->(),
}

local Blocks = 0

function GenerateBlockName()
	Blocks += 1
	return "Unnamed-" .. Blocks
end

function IsInputValid(input:BlockInput)
	return input.ConvertedInputValue ~= nil and input.InputName ~= nil and input.InputType ~= nil and input.InputValueIsVariableName ~= nil
end

function IsOutputValid(output:BlockOutput)
	return output.OutputVariable ~= nil and output.OutputName ~= nil
end

function BooleanToInteger(boolean)
	if boolean == true then
		return 1
	end
	return 0
end

local Block = {}
function Block.NewIPath(path:string)
	return {
		Path=path,
		IsInstancePath=true
	}
end
function Block.NewChoice(choice:string)
	return {
		Choice=choice,
		IsChoice=true
	}
end
function Block.NewTuple(Name:string, Values:{}, IsOutput:boolean?)
	-- Create new tuple (input or output)
	if IsOutput then
		local NewTuple:BlockTupleOutput = {
			TupleName = Name,
			TupleValues = Values,
			IsOutputTuple = true
		}
		return NewTuple
	end
	local NewTuple:BlockTupleInput = {
		TupleName = Name,
		TupleValues = Values
	}
	return NewTuple
end
function Block.NewInput(InputName:string, InputValue:any, IsVariable:boolean?)
	-- Create new non-tuple input
	if not IsVariable then
		IsVariable = false
	end
	local ConvertedInputValue
	local TypeOfValue = string.gsub(typeof(InputValue), "boolean", "bool")
	local Handler = SpecialValueHandlers[TypeOfValue]
	if Handler then
		ConvertedInputValue = Handler(InputValue)
	else
		ConvertedInputValue = tostring(InputValue)
	end
	if TypeOfValue == "table" then
		if InputValue["IsInstancePath"] then
			TypeOfValue = "Object"
			ConvertedInputValue = InputValue["Path"]
		elseif InputValue["IsChoice"] then
			TypeOfValue = "Choice"
			ConvertedInputValue = InputValue["Choice"]
		end
		
	end 
	local NewInput:BlockInput = {
		InputName = InputName,
		InputValue = InputValue,
		ConvertedInputValue = ConvertedInputValue,
		InputType = string.gsub(TypeOfValue, "^%l", string.upper),
		InputValueIsVariableName = IsVariable
	}
	return NewInput
end
function Block.i(InputValue:any, IsVariable:boolean?)
	-- Shorthand for NewInput but does not require a name
	return Block.NewInput("NoneAssigned", InputValue, IsVariable)
end
function Block.o(OutputVariable:string)
	-- Shorthand for NewOutput but does not require a name
	return Block.NewOutput("NoneAssigned", OutputVariable)
end
function Block.NewOutput(OutputName:string, OutputVariable:string)
	-- Create new non-tuple output
	if not OutputVariable or not OutputName then
		warn(debug.traceback("Invalid parameters given by: "))
	end
	local NewOutput:BlockOutput = {
		OutputName = OutputName,
		OutputVariable = OutputVariable
	}
	return NewOutput
end
function Block.NewBlock(BlockID:string, FriendlyName:string?, InputsOutputs:{BlockInput | BlockTupleInput | BlockOutput | BlockTupleOutput}?)
	-- Creates new v2-compatible abstract Visual Block
	-- Editor position properties not supported
	if not FriendlyName then
		FriendlyName = GenerateBlockName()
	end
	local InputsReal = {}
	local InputsTuples = {}
	local OutputsReal = {}
	local OutputsTuples = {}
	if InputsOutputs then
		for _, InputOutput in pairs(InputsOutputs) do
			if InputOutput["IsOutputTuple"] then
				table.insert(OutputsTuples, InputOutput)
			elseif InputOutput["TupleName"] then
				table.insert(InputsTuples, InputOutput)
			elseif InputOutput["InputType"] then
				table.insert(InputsReal, InputOutput)
			else
				table.insert(OutputsReal, InputOutput)
			end
		end
	end
	local newBlock:AbstractBlock = {
		BlockID = BlockID,
		FriendlyName = FriendlyName,
		Inputs = InputsReal or {},
		Outputs = OutputsReal or {},
		InputTupleData = InputsTuples or {},
		OutputTupleData = OutputsTuples or {},
		ConnectedChildren = {},
		ToVisualSource = function(self)
			-- Convert this block to its VisualSource equivalent
			-- Does not include VisualSource header
			local DataTemplate = "%s%s0.000.00%s%s%s" or self.OwnTemplate
			local ConnectedChildrenFormatted = ""
			local InputsFormatted = ""
			local OutputsFormatted = ""
			-- Format children code
			for _, Child in pairs(self.ConnectedChildren) do
				ConnectedChildrenFormatted = ConnectedChildrenFormatted .. "" .. Child
			end
			-- Format input/output code
			for _, Input:BlockInput in pairs(self.Inputs) do
				local InputType = ""
				if not Input.InputValueIsVariableName then
					InputType = "" .. Input.InputType
				end
				if not IsInputValid(Input) then
					warn("A malformed input was used while creating a Visual Block. You are able to see the structure of the input below this message.")
					print(Input)
					error("Invalid input. Check output for more information")
				end
				InputsFormatted = InputsFormatted .. string.format("%s%i%s%s", Input.InputName, BooleanToInteger(Input.InputValueIsVariableName), InputType, Input.ConvertedInputValue)
			end
			for _, Output:BlockOutput in pairs(self.Outputs) do
				if not IsOutputValid(Output) then
					warn("A malformed output was used while creating a Visual Block. You are able to see the structure of the output below this message.")
					print(Output)
					error("Invalid output. Check output for more information")
				end
				OutputsFormatted = OutputsFormatted .. string.format("%s%s", Output.OutputName, Output.OutputVariable)
			end
			-- Format tuple input/output code
			for _, TupleInput:BlockTupleInput in pairs(self.InputTupleData) do
				local ThisTupleInputs = {}
				for _, Value:BlockInput in pairs(TupleInput.TupleValues) do
					local Name = "TUPLEPARAM_Parameters_" .. (#ThisTupleInputs + 1)
					local InputType = ""
					if not Value.InputValueIsVariableName then
						InputType = "" .. Value.InputType
					end
					if not IsInputValid(Value) then
						warn("A malformed tuple input was used while creating a Visual Block. You are able to see the structure of the input below this message.")
						print(Value)
						error("Invalid tuple input. Check output for more information")
					end
					InputsFormatted = InputsFormatted .. string.format("%s%i%s%s", Name, BooleanToInteger(Value.InputValueIsVariableName), InputType, Value.ConvertedInputValue)
					table.insert(ThisTupleInputs, Name)
				end
				InputsFormatted = InputsFormatted .. string.format("%s0Tuple%s", TupleInput.TupleName, table.concat(ThisTupleInputs, ","))
			end
			for _, TupleOutput:BlockTupleOutput in pairs(self.OutputTupleData) do
				local TotalItems = 0
				for _, Value in pairs(TupleOutput.TupleValues) do
					local Name = "TUPLEPARAM_" .. (TupleOutput.TupleName or "Parameters") .. "_" .. (TotalItems + 1)
					if not Value.OutputVariable then
						warn("A malformed output was used while creating a Visual Block. You are able to see the structure of the output below this message.")
						print(Value)
						error("Invalid output. Check output for more information")
					end
					OutputsFormatted = OutputsFormatted .. string.format("%s%s", Name, Value.OutputVariable)
					TotalItems += 1
				end
				OutputsFormatted = OutputsFormatted .. string.format("TUPLE_%s%i", TupleOutput.TupleName, TotalItems)
			end	
			local Data = string.format(DataTemplate, self.FriendlyName, self.BlockID, ConnectedChildrenFormatted, OutputsFormatted, InputsFormatted)
			return Data
		end,
		ConnectToBlock = function(self, childBlock:AbstractBlock)
			-- Connect a child block to this block
			local Name = childBlock.FriendlyName
			if not table.find(self.ConnectedChildren, Name) then
				table.insert(self.ConnectedChildren, Name)
			end
		end,
		ConnectToFriendlyName = function(self, childBlock:string)
			-- Connect a child block to this block using its name
			table.insert(self.ConnectedChildren, childBlock)
		end,
		DisconnectFromBlock = function(self, childBlock:AbstractBlock)
			-- Disconnect a child block from this block
			local Name = childBlock.FriendlyName
			local Index = table.find(self.ConnectedChildren, Name)
			assert(Index, "Block " .. Name .. " is not connected")
			table.remove(self.ConnectedChildren, Index)
		end,
		DisconnectFromFriendlyName = function(self, childBlock:string)
			-- Disconnect a child block from this block using its name
			local Index = table.find(self.ConnectedChildren, childBlock)
			assert(Index, "Block " .. childBlock .. " is not connected")
			table.remove(self.ConnectedChildren, Index)
		end,
	}
	return newBlock
end
function Block.SaveBlockArray(Blocks:{AbstractBlock})
	-- Convert an array of blocks into a complete VisualSource script
	local Data = "0000000000000002"
	for _, Block in pairs(Blocks) do
		Data = Data .. Block:ToVisualSource()
	end
	return "!" .. RetroCompress.compress(Data)
end
function Block.LoadBlockArray(BlockSource:string)
	-- Convert a VisualSource script into an array of blocks
	-- Both uncompressed and compressed v2 and v1 are accepted
	-- TODO
end
function Block.NewBlockContainer()
	-- Create a Block Container for easier block creation
	local BlockContainer:BlockContainer = {
		Container = {},
		LastBlock = nil,
		NewBlock = function(self, ...)
			local BlockCreated = Block.NewBlock(...)
			self.LastBlock = BlockCreated
			table.insert(self.Container, BlockCreated)
			return BlockCreated
		end,
		NewLastConnectedBlock = function(self, ...)
			local BlockCreated = Block.NewBlock(...)
			if self.LastBlock then
				self.LastBlock:ConnectToBlock(BlockCreated)
			end
			self.LastBlock = BlockCreated
			table.insert(self.Container, BlockCreated)
			return BlockCreated
		end,
		AddLastConnectedBlock = function(self, block:AbstractBlock)
			if self.LastBlock then
				self.LastBlock:ConnectToBlock(block)
			end
			self.LastBlock = block
			table.insert(self.Container, block)
		end,
		SaveContainer = function(self)
			return Block.SaveBlockArray(self.Container)
		end,
		LoadContainer = function(self, Source)
			self.Container = Block.LoadBlockArray(Source)
		end,
	}
	return BlockContainer
end

-- a few enums
Block.Choice = {}
Block.Choice.Equal = Block.NewChoice("==")
Block.Choice.NotEqual = Block.NewChoice("~=")
Block.Choice.LessThan = Block.NewChoice("<")
Block.Choice.GreaterThan = Block.NewChoice(">")
Block.Choice.LessThanOrEqual = Block.NewChoice("<=")
Block.Choice.GreaterThanOrEqual = Block.NewChoice(">=")
Block.Type = {}
Block.Type.Variable = true
Block.Type.Data = false

return Block