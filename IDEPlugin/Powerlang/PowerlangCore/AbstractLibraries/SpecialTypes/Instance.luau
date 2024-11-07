local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["new"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Instance.new(). 2 are required")
		end
		TupleArguments[1].InputName = "ClassName"
		TupleArguments[2].InputName = "Parent"
		return {VisualLibrary.NewBlock("CreateObject", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("Object", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
}
local OutputSizes = {
	["new"]=1,
}
return {DefaultAbstractFunctions, OutputSizes}