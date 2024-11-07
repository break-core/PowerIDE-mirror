local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["AddItem"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Debris.addItem(). 2 are required")
		end
		TupleArguments[1].InputName = "Object"
		TupleArguments[2].InputName = "Time"
		return {VisualLibrary.NewBlock("AddDebrisItem", GenerateUniqueName("Debris-"), {
			TupleArguments[1],
			TupleArguments[2],
		})}
	end,
}
local OutputSizes = {
	["AddItem"]=1,
}
return {DefaultAbstractFunctions, OutputSizes}