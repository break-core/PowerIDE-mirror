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
		if #TupleArguments < 3 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Vector3.new(). 3 are required")
		end
		TupleArguments[1].InputName = "X"
		TupleArguments[2].InputName = "Y"
		TupleArguments[3].InputName = "Z"
		return {VisualLibrary.NewBlock("ConstructVector3", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			VisualLibrary.NewOutput("Vector3", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["split"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Vector3.split(). 1 is required")
		end
		TupleArguments[1].InputName = "Vector3"
		return {VisualLibrary.NewBlock("SplitVector3", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("X", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("Y", SuboutputVariableNames[2].OutputVariable),
			VisualLibrary.NewOutput("Z", SuboutputVariableNames[3].OutputVariable)
		})}
	end,
	["magnitude"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Vector3.magnitude(). 2 are required")
		end
		TupleArguments[1].InputName = "Point 1"
		TupleArguments[2].InputName = "Point 2"
		return {VisualLibrary.NewBlock("DistanceBetweenPoints", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("Distance", SuboutputVariableNames[1].OutputVariable),
		})}
	end,
	["rotation"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Vector3.rotation(). 2 are required")
		end
		TupleArguments[1].InputName = "Point 1"
		TupleArguments[2].InputName = "Point 2"
		return {VisualLibrary.NewBlock("RotationBetweenPoints", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("RotationVector3", SuboutputVariableNames[1].OutputVariable),
		})}
	end,
	["normalize"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Vector3.normalize(). 1 is required")
		end
		TupleArguments[1].InputName = "Vector3"
		return {VisualLibrary.NewBlock("NormalizeVector3", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable),
		})}
	end,
	["dot"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Vector3.dot(). 2 are required")
		end
		TupleArguments[1].InputName = "VectorA"
		TupleArguments[2].InputName = "VectorB"
		return {VisualLibrary.NewBlock("Vector3Dot", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable),
		})}
	end,
	["cross"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Vector3.cross(). 2 are required")
		end
		TupleArguments[1].InputName = "VectorA"
		TupleArguments[2].InputName = "VectorB"
		return {VisualLibrary.NewBlock("Vector3Cross", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable),
		})}
	end,
}
local OutputSizes = {
	["new"]=1,
	["split"]=3,
	["magnitude"]=1,
	["distance"]=1,
	["rotation"]=1,
	["normalize"]=1,
	["dot"]=1,
	["cross"]=1,
}
return {DefaultAbstractFunctions, OutputSizes}