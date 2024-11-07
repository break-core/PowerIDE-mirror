local VisualLibrary = require(script.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["split"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to string.split()")
		end
		TupleArguments[1].InputName = "String"
		TupleArguments[2].InputName = "Seperator" --typo intentional
		return {VisualLibrary.NewBlock("SplitString", GenerateUniqueName("Str-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["find"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to string.find()")
		end
		TupleArguments[1].InputName = "String"
		TupleArguments[2].InputName = "Pattern"
		return {VisualLibrary.NewBlock("FindString", GenerateUniqueName("Str-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["sub"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 3 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to string.sub()")
		end
		TupleArguments[1].InputName = "String"
		TupleArguments[2].InputName = "StartPoint"
		TupleArguments[3].InputName = "EndPoint"
		return {VisualLibrary.NewBlock("Substring", GenerateUniqueName("Str-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["gsub"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 3 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to string.gsub()")
		end
		TupleArguments[1].InputName = "String"
		TupleArguments[2].InputName = "Pattern"
		TupleArguments[3].InputName = "Replacement"
		return {VisualLibrary.NewBlock("GSubString", GenerateUniqueName("Str-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["length"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to string.length()")
		end
		TupleArguments[1].InputName = "String"
		return {VisualLibrary.NewBlock("GetLength", GenerateUniqueName("Str-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Length", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["upper"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to string.upper()")
		end
		TupleArguments[1].InputName = "String"
		return {VisualLibrary.NewBlock("Upper", GenerateUniqueName("Str-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["lower"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to string.lower()")
		end
		TupleArguments[1].InputName = "String"
		return {VisualLibrary.NewBlock("Lower", GenerateUniqueName("Str-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["filter"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to string.filter()")
		end
		TupleArguments[1].InputName = "String"
		return {VisualLibrary.NewBlock("FilterString", GenerateUniqueName("Str-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
}
local OutputSizes = {
	["split"]=1,
	["find"]=1,
	["sub"]=1,
	["gsub"]=1,
	["length"]=1,
	["upper"]=1,
	["lower"]=1,
	["filter"]=1,
}
return {DefaultAbstractFunctions, OutputSizes}