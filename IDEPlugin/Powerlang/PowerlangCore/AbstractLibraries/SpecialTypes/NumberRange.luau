local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["new"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to NumberRange.new(). 2 are required")
		end
		TupleArguments[1].InputName = "Min"
		TupleArguments[2].InputName = "Max"
		return {VisualLibrary.NewBlock("ConstructNumberRange", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("NumberRange", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["split"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to NumberRange.split(). 1 is required")
		end
		TupleArguments[1].InputName = "NumberRange"
		return {VisualLibrary.NewBlock("SplitNumberRange", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Min", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("Max", SuboutputVariableNames[2].OutputVariable),
		})}
	end,
}
local OutputSizes = {
	["new"]=1,
	["split"]=2,
}
return {DefaultAbstractFunctions, OutputSizes}