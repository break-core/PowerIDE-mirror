local VisualLibrary = require(script.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["clock"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		local BlocksCreatedHere = {}
	
		SuboutputVariableNames[1].OutputName = "Answer"
		local AppendTableBlock = VisualLibrary.NewBlock("OsClock", GenerateUniqueName("Generic-"), {
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, AppendTableBlock)
		return BlocksCreatedHere
	end,
	["date"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		--table.append(tableName, elementToAppend)
		local BlocksCreatedHere = {}
		if #TupleArguments < 2 then
			EWI.Error(14, SharedContext, ExecutableContext, "os.date() expects two arguments, got " .. #TupleArguments)
		end
		TupleArguments[1].InputName = "Time"
		TupleArguments[2].InputName = "Timezone"
		SuboutputVariableNames[1].OutputName = "DateTable"
		local AppendTableBlock = VisualLibrary.NewBlock("OsDate", GenerateUniqueName("Generic-"), {
			TupleArguments[1],
			TupleArguments[2],
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, AppendTableBlock)
		return BlocksCreatedHere
	end,
	["time"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		local BlocksCreatedHere = {}

		SuboutputVariableNames[1].OutputName = "Answer"
		local AppendTableBlock = VisualLibrary.NewBlock("OsTime", GenerateUniqueName("Generic-"), {
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, AppendTableBlock)
		return BlocksCreatedHere
	end,
	
}
local OutputSizes = {
	["clock"]=1,
	["date"]=1,
	["time"]=1
}
return {DefaultAbstractFunctions, OutputSizes}