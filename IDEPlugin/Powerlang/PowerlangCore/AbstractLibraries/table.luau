local VisualLibrary = require(script.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["create"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- An unlimited amount of arguments (each argument will be a member of the table)
		local BlocksCreatedHere = {}
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #SuboutputVariableNames > 1 then
			EWI.Error(7, SharedContext, ExecutableContext, "table.create cannot be used to assign to a tuple")
		end
		local TableOutputVariable = SuboutputVariableNames[1]
		TableOutputVariable.OutputName = "TableVariable"
		local CreateTableBlock = VisualLibrary.NewBlock("CreateTable", GenerateUniqueName("Table-"), {TableOutputVariable})
		table.insert(BlocksCreatedHere, CreateTableBlock)
		for _, Argument in pairs(TupleArguments) do
			Argument.InputName = "Value"
			local AppendTableBlock = VisualLibrary.NewBlock("TableAppend", GenerateUniqueName("Table-"), {
				VisualLibrary.NewInput("Table", TableOutputVariable.OutputVariable),
				Argument
			})
			BlocksCreatedHere[#BlocksCreatedHere]:ConnectToBlock(AppendTableBlock)
			table.insert(BlocksCreatedHere, AppendTableBlock)
		end
		return BlocksCreatedHere
	end,
	["append"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		--table.append(tableName, elementToAppend)
		local BlocksCreatedHere = {}
		local TableArg = TupleArguments[1]
		TableArg.InputName = "Table"
		TableArg.InputValueIsVariableName = false
		local Argument = TupleArguments[2]
		Argument.InputName = "Value"
		local AppendTableBlock = VisualLibrary.NewBlock("TableAppend", GenerateUniqueName("Table-"), {
			TableArg,
			Argument
		})
		table.insert(BlocksCreatedHere, AppendTableBlock)
		return BlocksCreatedHere
	end,
	["insert"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		--table.append(tableName, elementToAppend)
		local BlocksCreatedHere = {}
		local TableArg = TupleArguments[1]
		TableArg.InputName = "Table"
		TableArg.InputValueIsVariableName = false
		local Argument = TupleArguments[2]
		Argument.InputName = "Value"
		local Position = TupleArguments[3]
		Position.InputName = "Position"
		local InsertTableBlock = VisualLibrary.NewBlock("TableInsert", GenerateUniqueName("Table-"), {
			TableArg,
			Argument,
			Position
		})
		table.insert(BlocksCreatedHere, InsertTableBlock)
		return BlocksCreatedHere
	end,
	["remove"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		--table.append(tableName, elementToAppend)
		local BlocksCreatedHere = {}
		local TableArg = TupleArguments[1]
		TableArg.InputName = "Table"
		TableArg.InputValueIsVariableName = false
		local Argument = TupleArguments[2]
		Argument.InputName = "Position"
		local RemoveTableBlock = VisualLibrary.NewBlock("TableRemove", GenerateUniqueName("Table-"), {
			TableArg,
			Argument,
		})
		table.insert(BlocksCreatedHere, RemoveTableBlock)
		return BlocksCreatedHere
	end,
	["find"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return
		end
		--table.append(tableName, elementToAppend)
		local BlocksCreatedHere = {}
		local TableArg = TupleArguments[1]
		TableArg.InputName = "Table"
		TableArg.InputValueIsVariableName = false
		local Argument = TupleArguments[2]
		Argument.InputName = "Value"
		local Position = TupleArguments[3] or VisualLibrary.NewInput("Init", 1)
		Position.InputName = "Init"
		local FindBlock = VisualLibrary.NewBlock("TableFind", GenerateUniqueName("Table-"), {
			TableArg,
			Argument,
			Position,
			VisualLibrary.NewOutput("Key", SuboutputVariableNames[1].OutputVariable)
		})
		table.insert(BlocksCreatedHere, FindBlock)
		return BlocksCreatedHere
	end,
	["sort"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		--table.append(tableName, elementToAppend)
		local BlocksCreatedHere = {}
		local TableArg = TupleArguments[1]
		TableArg.InputName = "Table"
		TableArg.InputValueIsVariableName = false
		local Argument = TupleArguments[2]
		Argument.InputName = "Order"
		local SortTableBlock = VisualLibrary.NewBlock("SortTable", GenerateUniqueName("Table-"), {
			TableArg,
			Argument,
		})
		table.insert(BlocksCreatedHere, SortTableBlock)
		return BlocksCreatedHere
	end,
	["length"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		--table.append(tableName, elementToAppend)
		local BlocksCreatedHere = {}
		local TableArg = TupleArguments[1]
		TableArg.InputName = "Table"
		TableArg.InputValueIsVariableName = false
		local LengthBlock = VisualLibrary.NewBlock("GetTableLength", GenerateUniqueName("Table-"), {
			TableArg,
			VisualLibrary.NewOutput("Length", SuboutputVariableNames[1].OutputVariable)
		})
		table.insert(BlocksCreatedHere, LengthBlock)
		return BlocksCreatedHere
	end,
}
local OutputSizes = {
	["create"]=1,
	["append"]=0,
	["insert"]=0,
	["remove"]=0,
	["find"]=1,
	["sort"]=0,
	["length"]=1,
}
return {DefaultAbstractFunctions, OutputSizes}