local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["fromRGB"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 3 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Color3.fromRGB(). 3 are required")
		end
		TupleArguments[1].InputName = "R"
		TupleArguments[2].InputName = "G"
		TupleArguments[3].InputName = "B"
		return {VisualLibrary.NewBlock("ConstructColor3", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			VisualLibrary.NewOutput("Color3", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["split"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Color3.split(). 1 is required")
		end
		TupleArguments[1].InputName = "Color3"
		return {VisualLibrary.NewBlock("SplitColor3", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("R", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("G", SuboutputVariableNames[2].OutputVariable),
			VisualLibrary.NewOutput("B", SuboutputVariableNames[3].OutputVariable)
		})}
	end,
	["toBrickColor"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Color3.toBrickColor(). 1 is required")
		end
		TupleArguments[1].InputName = "Color3"
		return {VisualLibrary.NewBlock("Color3ToBrickColor", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("BrickColor", SuboutputVariableNames[1].OutputVariable),
		})}
	end,
	["fromBrickColor"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Color3.fromBrickColor(). 1 is required")
		end
		TupleArguments[1].InputName = "BrickColor"
		return {VisualLibrary.NewBlock("BrickColorToColor3", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Color3", SuboutputVariableNames[1].OutputVariable),
		})}
	end,
	["toHSV"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Color3.toHSV(). 1 is required")
		end
		TupleArguments[1].InputName = "Color3"
		return {VisualLibrary.NewBlock("Color3ToHSV", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Hue", SuboutputVariableNames[1].OutputVariable),
			VisualLibrary.NewOutput("Saturation", SuboutputVariableNames[2].OutputVariable),
			VisualLibrary.NewOutput("Value", SuboutputVariableNames[3].OutputVariable)
		})}
	end,
	["fromHSV"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 3 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to Color3.fromHSV(). 3 are required")
		end
		TupleArguments[1].InputName = "Hue"
		TupleArguments[2].InputName = "Saturation"
		TupleArguments[3].InputName = "Value"
		return {VisualLibrary.NewBlock("HSVToColor3", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			VisualLibrary.NewOutput("Color3", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
}
local OutputSizes = {
	["fromRGB"]=1,
	["split"]=3,
	["toBrickColor"]=1,
	["fromBrickColor"]=1,
	["toHSV"]=3,
	["fromHSV"]=1,
}
return {DefaultAbstractFunctions, OutputSizes}