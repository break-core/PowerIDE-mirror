local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["GetTargetPart"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		return {VisualLibrary.NewBlock("GetMouseTargetPartLocal", GenerateUniqueName("Create-"), {
			VisualLibrary.NewOutput("TargetPart", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["GetTargetSurface"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		return {VisualLibrary.NewBlock("GetMouseTargetSurfaceLocal", GenerateUniqueName("Create-"), {
			VisualLibrary.NewOutput("Surface", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["GetPosition2D"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		return {VisualLibrary.NewBlock("GetMousePosition2DLocal", GenerateUniqueName("Create-"), {
			VisualLibrary.NewOutput("X", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("Y", SuboutputVariableNames[2].OutputVariable)
		})}
	end,
	["GetPosition3D"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		return {VisualLibrary.NewBlock("GetMousePosition3DLocal", GenerateUniqueName("Create-"), {
			VisualLibrary.NewOutput("Position", SuboutputVariableNames[1].OutputVariable),
		})}
	end,
	["SetTargetFilter"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "Expected at least 1 argument, got 0.")
		end
		return {VisualLibrary.NewBlock("SetMouseTargetFilterLocal", GenerateUniqueName("Create-"), {
			VisualLibrary.NewInput("Object", TupleArguments[1]),
		})}
	end,
	
}
local OutputSizes = {
	["GetTargetPart"]=1,
	["GetTargetSurface"]=1,
	["GetPosition2D"]=2,
	["GetPosition3D"]=1,
	["SetTargetFilter"]=0,
	
}
return {DefaultAbstractFunctions, OutputSizes}