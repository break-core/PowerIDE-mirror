local VisualLibrary = require(script.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

function SingleInput(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext, OwnFunction:string)
	if #TupleArguments ~= 1 then
		EWI.Error(19, SharedContext, ExecutableContext, "One argument expected for this math function")
	end
	TupleArguments[1].InputName = "Number"
	SuboutputVariableNames[1].OutputName = "Result"
	OwnFunction, _ = string.gsub(OwnFunction, "math.", "")
	local BlockCreated = VisualLibrary.NewBlock("MathLibrarySingleInput", GenerateUniqueName("math-"), {
		VisualLibrary.NewInput("Function", OwnFunction),
		TupleArguments[1],
		SuboutputVariableNames[1]
	})
	return {BlockCreated}
end

function DoubleInput(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext, OwnFunction)
	if #TupleArguments ~= 2 then
		EWI.Error(19, SharedContext, ExecutableContext, "Two arguments expected for this math function")
	end
	TupleArguments[1].InputName = "Number1"
	TupleArguments[2].InputName = "Number2"
	SuboutputVariableNames[1].OutputName = "Result"
	OwnFunction, _ = string.gsub(OwnFunction, "math.", "")
	local BlockCreated = VisualLibrary.NewBlock("MathLibraryDoubleInput", GenerateUniqueName("math-"), {
		VisualLibrary.NewInput("Function", OwnFunction),
		TupleArguments[1],
		TupleArguments[2],
		SuboutputVariableNames[1]
	})
	return {BlockCreated}
end

function TripleInput(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext, OwnFunction)
	if #TupleArguments ~= 3 then
		EWI.Error(19, SharedContext, ExecutableContext, "Three arguments expected for this math function")
	end
	TupleArguments[1].InputName = "Number1"
	TupleArguments[2].InputName = "Number2"
	TupleArguments[3].InputName = "Number3"
	SuboutputVariableNames[1].OutputName = "Result"
	OwnFunction, _ = string.gsub(OwnFunction, "math.", "")
	local BlockCreated = VisualLibrary.NewBlock("MathLibraryTripleInput", GenerateUniqueName("math-"), {
		VisualLibrary.NewInput("Function", OwnFunction),
		TupleArguments[1],
		TupleArguments[2],
		TupleArguments[3],
		SuboutputVariableNames[1]
	})
	return {BlockCreated}
end

local DefaultAbstractFunctions = {
	
}

local OutputSizes = {

}
for _, obj in pairs({"abs", "acos", "asin", "atan", "ceil", "cos", "cosh", "deg", "exp", "floor", "frexp", "log10", "modf", "rad", "randomseed", "round", "sign", "sin", "sinh", "sqrt", "tan", "tanh"}) do
	DefaultAbstractFunctions[obj] = SingleInput
	OutputSizes[obj] = 1
end

for _, obj in pairs({"atan2", "fmod", "idexp", "log", "max", "min", "pow", "random"}) do
	DefaultAbstractFunctions[obj] = DoubleInput
	OutputSizes[obj] = 1
end

for _, obj in pairs({"clamp", "noise"}) do
	DefaultAbstractFunctions[obj] = TripleInput
	OutputSizes[obj] = 1
end

return {DefaultAbstractFunctions, OutputSizes}