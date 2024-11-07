local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["ComputePath"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to ComputePath. 2 are required")
		end
		TupleArguments[1].InputName = "StartPosition"
		TupleArguments[2].InputName = "EndPosition"
		return {VisualLibrary.NewBlock("ComputePath", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("ComputedPath", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	
}
local OutputSizes = {
	["ComputePath"]=1,
}
return {DefaultAbstractFunctions, OutputSizes}