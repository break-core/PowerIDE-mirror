local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["findPart"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 4 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to findPart. 4 are expected")
		end
		TupleArguments[1].InputName = "Origin"
		TupleArguments[2].InputName = "Direction"
		TupleArguments[3].InputName = "FilterType"
		TupleArguments[4].InputName = "FilterDescendantsTable"
		TupleArguments[4].InputType = "Table"
		TupleArguments[4].InputValueIsVariableName = false
		return {VisualLibrary.NewBlock("FindPartOnRay", GenerateUniqueName("Ray-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			TupleArguments[4],
			VisualLibrary.NewOutput("Instance", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("Position", SuboutputVariableNames[2].OutputVariable),
			VisualLibrary.NewOutput("Normal", SuboutputVariableNames[3].OutputVariable),
		})}
	end,
	
}
local OutputSizes = {
	["findPart"]=3,
}
return {DefaultAbstractFunctions, OutputSizes}