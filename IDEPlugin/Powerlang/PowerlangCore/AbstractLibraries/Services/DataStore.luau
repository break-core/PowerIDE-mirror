local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["SaveVariable"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to DataStore.SaveVariable(). 2 to 3 are required")
		end
		TupleArguments[1].InputName = "Value"
		TupleArguments[2].InputName = "Key"
		if TupleArguments[3] then
			TupleArguments[3].InputName = "Shared"
		else
			TupleArguments[3] = VisualLibrary.NewInput("Shared", false)
		end
		return {VisualLibrary.NewBlock("SaveVariable", GenerateUniqueName("Save-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			VisualLibrary.NewOutput("Success", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["LoadVariable"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to DataStore.LoadVariable(). 1 to 2 are required")
		end
		TupleArguments[1].InputName = "Key"
		if TupleArguments[2] then
			TupleArguments[2].InputName = "Shared"
		else
			TupleArguments[2] = VisualLibrary.NewInput("Shared", false)
		end
		return {VisualLibrary.NewBlock("LoadVariable", GenerateUniqueName("Load-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("Success", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("LoadedData", SuboutputVariableNames[2].OutputVariable),
		})}
	end,
	["SaveInstance"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to DataStore.SaveInstance(). 2 to 3 are required")
		end
		TupleArguments[1].InputName = "Model"
		TupleArguments[2].InputName = "Key"
		if TupleArguments[3] then
			TupleArguments[3].InputName = "Shared"
		else
			TupleArguments[3] = VisualLibrary.NewInput("Shared", false)
		end
		return {VisualLibrary.NewBlock("SaveInstance", GenerateUniqueName("Save-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			VisualLibrary.NewOutput("Success", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["LoadInstance"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to DataStore.LoadInstance(). 2 to 3 are required")
		end
		TupleArguments[1].InputName = "Key"
		TupleArguments[2].InputName = "Parent"
		if TupleArguments[3] then
			TupleArguments[3].InputName = "Shared"
		else
			TupleArguments[3] = VisualLibrary.NewInput("Shared", false)
		end
		return {VisualLibrary.NewBlock("LoadInstance", GenerateUniqueName("Load-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			VisualLibrary.NewOutput("Success", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("LoadedModel", SuboutputVariableNames[2].OutputVariable),
		})}
	end,
}
local OutputSizes = {
	["SaveVariable"]=1,
	["LoadVariable"]=2,
	["SaveInstance"]=1,
	["LoadInstance"]=2,
}
return {DefaultAbstractFunctions, OutputSizes}