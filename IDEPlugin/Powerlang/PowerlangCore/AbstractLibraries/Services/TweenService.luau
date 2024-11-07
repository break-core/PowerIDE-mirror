local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["TweenProperty"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 4 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Tween. 4 to 8 are expected")
		end
		--TODO: this is just copied pls finish
		TupleArguments[1].InputName = "Object"
		TupleArguments[2].InputName = "Property"
		TupleArguments[3].InputName = "Value"
		TupleArguments[4].InputName = "Time"
		if TupleArguments[5] then
			TupleArguments[5].InputName = "EasingStyle"
		else
			TupleArguments[5] = VisualLibrary.NewInput("EasingStyle", "Linear")
		end
		if TupleArguments[6] then
			TupleArguments[6].InputName = "EasingDirection"
		else
			TupleArguments[6] = VisualLibrary.NewInput("EasingDirection", "InOut")
		end
		if TupleArguments[7] then
			TupleArguments[7].InputName = "RepeatCount"
		else
			TupleArguments[7] = VisualLibrary.NewInput("RepeatCount", 1)
		end
		if TupleArguments[8] then
			TupleArguments[8].InputName = "Reverses"
		else
			TupleArguments[8] = VisualLibrary.NewInput("Reverses", false)
		end
		return {VisualLibrary.NewBlock("TweenObjectProperty", GenerateUniqueName("Tween-"), TupleArguments)}
	end,
	
}
local OutputSizes = {
	["TweenProperty"]=0,
}
return {DefaultAbstractFunctions, OutputSizes}