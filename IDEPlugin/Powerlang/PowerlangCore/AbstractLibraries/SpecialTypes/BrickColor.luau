local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["new"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to BrickColor.new(). 1 is required")
		end
		TupleArguments[1] = VisualLibrary.NewInput("Value", BrickColor.new(TupleArguments[1].InputValue))
		return {VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Color-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("VariableName", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["random"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		return {VisualLibrary.NewBlock("RandomBrickColor", GenerateUniqueName("Color-"), {
			VisualLibrary.NewOutput("BrickColor", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
}
local OutputSizes = {
	["new"]=1,
	["random"]=1,
}
return {DefaultAbstractFunctions, OutputSizes}