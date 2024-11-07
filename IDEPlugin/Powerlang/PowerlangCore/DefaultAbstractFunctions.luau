local VisualLibrary = require(script.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	-- GLOBALS
	
	["print"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "print() expects only one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "Text"
		local PrintBlock = VisualLibrary.NewBlock("Print", GenerateUniqueName("Print-"), {
			TupleArguments[1]
		})
		table.insert(BlocksCreatedHere, PrintBlock)
		return BlocksCreatedHere
	end,
	["warn"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "warn() expects only one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "Text"
		local PrintBlock = VisualLibrary.NewBlock("Warn", GenerateUniqueName("Print-"), {
			TupleArguments[1]
		})
		table.insert(BlocksCreatedHere, PrintBlock)
		return BlocksCreatedHere
	end,
	["tonumber"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "tonumber() expects only one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "String"
		SuboutputVariableNames[1].OutputName = "Number"
		local PrintBlock = VisualLibrary.NewBlock("ToNumber", GenerateUniqueName("Global-"), {
			TupleArguments[1],
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, PrintBlock)
		return BlocksCreatedHere
	end,
	["tostring"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "tostring() expects only one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "Input"
		SuboutputVariableNames[1].OutputName = "String"
		if TupleArguments[1].InputType == "Number" and not TupleArguments[1].InputValueIsVariableName then
			TupleArguments[1].InputValue = tonumber(TupleArguments[1].InputValue)
		end
		local PrintBlock = VisualLibrary.NewBlock("ToStringAny", GenerateUniqueName("Global-"), {
			TupleArguments[1],
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, PrintBlock)
		return BlocksCreatedHere
	end,
	["typeof"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "typeof() expects only one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "Variable"
		SuboutputVariableNames[1].OutputName = "Type"
		local PrintBlock = VisualLibrary.NewBlock("TypeOf", GenerateUniqueName("Global-"), {
			TupleArguments[1],
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, PrintBlock)
		return BlocksCreatedHere
	end,
	["tick"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 0 then
			EWI.Error(14, SharedContext, ExecutableContext, "tick() expects zero arguments, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		SuboutputVariableNames[1].OutputName = "Answer"
		local PrintBlock = VisualLibrary.NewBlock("TypeOf", GenerateUniqueName("Global-"), {
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, PrintBlock)
		return BlocksCreatedHere
	end,
	["wait"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "wait() expects only one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "Time"
		TupleArguments[1].InputValue = tonumber(TupleArguments[1].InputValue)
		TupleArguments[1].InputType = "Number"
		local WaitBlock = VisualLibrary.NewBlock("Wait", GenerateUniqueName("Global-"), {
			TupleArguments[1]
		})
		table.insert(BlocksCreatedHere, WaitBlock)
		return BlocksCreatedHere
	end,
	["spawn"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments < 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "spawn() expects at least one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		local ParamsTuple = nil
		TupleArguments[1].InputName = "Function"
		TupleArguments[1].InputValue = TupleArguments[1].InputValue
		TupleArguments[1].InputType = "Function"
		TupleArguments[1].InputValueIsVariableName = false
		if #TupleArguments > 1 then
			local TupleInputs = {}
			table.move(TupleArguments, 2, #TupleArguments, 1, TupleInputs)
			ParamsTuple = VisualLibrary.NewTuple("Parameters", TupleInputs)
		end
		local SpawnBlock = VisualLibrary.NewBlock("Spawn", GenerateUniqueName("Global-"), {
			TupleArguments[1],
			ParamsTuple
		})
		table.insert(BlocksCreatedHere, SpawnBlock)
		return BlocksCreatedHere
	end,
}
local OutputSizes = {
	["print"]=0,
	["tonumber"]=1,
	["tostring"]=1,
	["typeof"]=1,
	["tick"]=1,
	["wait"]=0,
	["warn"]=0,
	["spawn"]=0,
}

-- Discovery of other libraries
for _, lib in pairs(script.Parent.AbstractLibraries:GetDescendants()) do
	if not lib:IsA("ModuleScript") then
		continue
	end
	local libName = lib.Name
	local libData = require(lib)
	for key, f in pairs(libData[1]) do
		DefaultAbstractFunctions[`{libName}.{key}`] = f
	end
	for key, s in pairs(libData[2]) do
		OutputSizes[`{libName}.{key}`] = s
	end
end

return {DefaultAbstractFunctions, OutputSizes}