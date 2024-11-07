local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["new"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- this takes in 2 vector3's
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.new(). 2 are required")
		end
		TupleArguments[1].InputName = "Position"
		TupleArguments[2].InputName = "Rotation"
		return {VisualLibrary.NewBlock("ConstructCFrame", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("CFrame", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["split"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.split(). 1 is required")
		end
		TupleArguments[1].InputName = "CFrame"
		return {VisualLibrary.NewBlock("SplitCFrame", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Position", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("Rotation", SuboutputVariableNames[2].OutputVariable),
		})}
	end,
	["lerp"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- start, goal, alpha
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 3 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.lerp(). 3 are required")
		end
		TupleArguments[1].InputName = "StartCFrame"
		TupleArguments[2].InputName = "GoalCFrame"
		TupleArguments[3].InputName = "Alpha"
		return {VisualLibrary.NewBlock("Lerp1", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["inverse"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- 1 in 1 out
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.inverse(). 1 is required")
		end
		TupleArguments[1].InputName = "CFrame"
		return {VisualLibrary.NewBlock("InverseCFrame1", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["toObjectSpace"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.toObjectSpace(). 2 are required")
		end
		TupleArguments[1].InputName = "CFrame"
		TupleArguments[2].InputName = "ObjectCFrame"
		return {VisualLibrary.NewBlock("ToObjectSpace1", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["toWorldSpace"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.toWorldSpace(). 2 are required")
		end
		TupleArguments[1].InputName = "CFrame"
		TupleArguments[2].InputName = "ObjectCFrame"
		return {VisualLibrary.NewBlock("ToWorldSpace1", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["direction"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.direction(). 2 are required")
		end
		TupleArguments[1].InputName = "CFrame"
		TupleArguments[2].InputName = "Direction" -- Forward, Backward, Left, Right, Up, Down
		return {VisualLibrary.NewBlock("GetCFrameDirection", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("Direction", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["Angles"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 3 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.Angles(). 3 are required")
		end
		TupleArguments[1].InputName = "rx"
		TupleArguments[2].InputName = "ry"
		TupleArguments[3].InputName = "rz"
		return {VisualLibrary.NewBlock("Angles", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["toEulerAnglesXYZ"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.toEulerAnglesXYZ(). 1 is required")
		end
		TupleArguments[1].InputName = "CFrame"
		return {VisualLibrary.NewBlock("ToEulerAnglesXYZ", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("rx", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("ry", SuboutputVariableNames[2].OutputVariable),
			VisualLibrary.NewOutput("rz", SuboutputVariableNames[3].OutputVariable)
		})}
	end,
	["fromMatrix"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- this takes in a vector3, vx, vy, vz
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 4 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.fromMatrix(). 4 are required")
		end
		TupleArguments[1].InputName = "pos"
		TupleArguments[2].InputName = "vX"
		TupleArguments[3].InputName = "vY"
		TupleArguments[4].InputName = "vZ"
		return {VisualLibrary.NewBlock("FromMatrix", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			TupleArguments[4],
			VisualLibrary.NewOutput("CFrame", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["fromAxisAngle"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- i have no idea what this does but it's in the original iteration so i have to add it
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to CFrame.fromAxisAngle(). 2 are required")
		end
		TupleArguments[1].InputName = "v"
		TupleArguments[2].InputName = "r"
		return {VisualLibrary.NewBlock("FromAxisAngle", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("CFrame", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
}
local OutputSizes = {
	["new"]=1,
	["split"]=2,
	["lerp"]=1,
	["inverse"]=1,
	["toObjectSpace"]=1,
	["toWorldSpace"]=1,
	["direction"]=1,
	["Angles"]=1,
	["toEulerAnglesXYZ"]=3,
	["fromMatrix"]=1,
	["fromAxisAngle"]=1,
}
return {DefaultAbstractFunctions, OutputSizes}