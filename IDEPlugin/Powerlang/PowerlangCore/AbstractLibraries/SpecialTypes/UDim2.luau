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
		if #TupleArguments < 4 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to UDim2.new(). 3 are required")
		end
		TupleArguments[1].InputName = "XScale"
		TupleArguments[2].InputName = "XOffset"
		TupleArguments[3].InputName = "YScale"
		TupleArguments[4].InputName = "YOffset"
		return {VisualLibrary.NewBlock("ConstructUDim2", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			TupleArguments[4],
			VisualLibrary.NewOutput("UDim2", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["split"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to UDim2.split(). 1 is required")
		end
		TupleArguments[1].InputName = "UDim2"
		return {VisualLibrary.NewBlock("SplitUDim2", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("XScale", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("XOffset", SuboutputVariableNames[2].OutputVariable),
			VisualLibrary.NewOutput("YScale", SuboutputVariableNames[3].OutputVariable),
			VisualLibrary.NewOutput("YOffset", SuboutputVariableNames[4].OutputVariable)
		})}
	end,
}
local OutputSizes = {
	["new"]=1,
	["split"]=4,
}
return {DefaultAbstractFunctions, OutputSizes}