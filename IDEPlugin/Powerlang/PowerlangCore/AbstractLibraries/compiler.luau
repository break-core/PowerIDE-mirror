local VisualLibrary = require(script.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["InsertBlock"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- Arg 1: Block name
		-- Arg 2: Block ID
		-- Args 3+: Arguments
		if #TupleArguments < 2 then
			EWI.Error(14, SharedContext, ExecutableContext, "CompilerServices.InsertBlock() expects at least two arguments, got " .. #TupleArguments)
		end
		local BlockName = TupleArguments[1].InputValue
		local BlockID = TupleArguments[2].InputValue
		local Args = {}
		local PermissibleArgNames = {}
		if #TupleArguments > 2 then
			table.move(TupleArguments, 3, #TupleArguments, 1, Args)
		end
		local BlockData = ProgrammingBlocksData.BlocksList[BlockID]
		if not BlockData then
			EWI.Error(15, SharedContext, ExecutableContext, "The block type '" .. BlockID .. "' is unknown and therefore cannot be created")
		end
		local i = 1
		for argname, argument in pairs(BlockData["Inputs"]) do
			PermissibleArgNames[argument.ListOrder] = argname
			i += 1
		end
		local Inputs = {}
		for order, arg in pairs(Args) do
			local ArgName = PermissibleArgNames[order]
			if not ArgName then
				EWI.Error(15, SharedContext, ExecutableContext, "The block type '" .. BlockID .. "' does not have an input at position " .. order)
			end
			table.insert(Inputs, VisualLibrary.NewInput(ArgName, arg.InputValue, arg.InputValueIsVariableName))
		end
		local OutputNames = {}
		for _, outputName in pairs(BlockData["Outputs"]) do
			table.insert(OutputNames, outputName)
		end
		for i, output in pairs(SuboutputVariableNames) do
			if OutputNames[i] then
				table.insert(Inputs, VisualLibrary.NewOutput(OutputNames[i], output.OutputVariable))
			end
		end
		local Block = VisualLibrary.NewBlock(BlockID, BlockName, Inputs)

		return {Block}
	end,
	["InsertBlockConnectedLast"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- Arg 1: Block name
		-- Arg 2: Block ID
		-- Args 3+: Arguments
		if #TupleArguments < 2 then
			EWI.Error(14, SharedContext, ExecutableContext, "CompilerServices.InsertBlockConnectedLast() expects at least two arguments, got " .. #TupleArguments)
		end
		if not ExecutableContext.LastCreatedBlock then
			return
		end
		local BlockName = TupleArguments[1].InputValue
		local BlockID = TupleArguments[2].InputValue
		local Args = {}
		local PermissibleArgNames = {}
		if #TupleArguments > 2 then
			table.move(TupleArguments, 3, #TupleArguments, 1, Args)
		end
		local BlockData = ProgrammingBlocksData.BlocksList[BlockID]
		if not BlockData then
			EWI.Error(15, SharedContext, ExecutableContext, "The block type '" .. BlockID .. "' is unknown and therefore cannot be created")
		end
		local i = 1
		for argname, argument in pairs(BlockData["Inputs"]) do
			PermissibleArgNames[argument.ListOrder] = argname
			i += 1
		end
		local Inputs = {}
		for order, arg in pairs(Args) do
			local ArgName = PermissibleArgNames[order]
			if not ArgName then
				EWI.Error(15, SharedContext, ExecutableContext, "The block type '" .. BlockID .. "' does not have an input at position " .. order)
			end
			table.insert(Inputs, VisualLibrary.NewInput(ArgName, arg.InputValue, arg.InputValueIsVariableName))
		end
		local OutputNames = {}
		for _, outputName in pairs(BlockData["Outputs"]) do
			table.insert(OutputNames, outputName)
		end
		for i, output in pairs(SuboutputVariableNames) do
			if OutputNames[i] then
				table.insert(Inputs, VisualLibrary.NewOutput(OutputNames[i], output.OutputVariable))
			end
		end
		local Block = VisualLibrary.NewBlock(BlockID, BlockName, Inputs)
		ExecutableContext.LastCreatedBlock:ConnectToBlock(Block)
		print(Block)
		return {Block}, true
	end,
	["path"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return
		end
		if #TupleArguments ~= 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "The function 'path' expects one argument, got " .. #TupleArguments)
		end
		if TupleArguments[1].InputType ~= "String" or TupleArguments[1].InputValueIsVariableName then
			EWI.Error(7, SharedContext, ExecutableContext, "The function 'path' expects a non-variable string as its first argument, got a " .. TupleArguments[1].InputType .. " instead")
		end
		local path = TupleArguments[1].InputValue
		return {VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Version-"), {
			VisualLibrary.NewInput("Value", VisualLibrary.NewIPath(path)),
			VisualLibrary.NewOutput("VariableName", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["equation"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return
		end
		if #TupleArguments ~= 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "The function 'equation' expects one argument, got " .. #TupleArguments)
		end
		if TupleArguments[1].InputType ~= "String" or TupleArguments[1].InputValueIsVariableName then
			EWI.Error(7, SharedContext, ExecutableContext, "The function 'equation' expects a non-variable string as its first argument, got a " .. TupleArguments[1].InputType .. " instead")
		end
		local path = TupleArguments[1].InputValue
		return {VisualLibrary.NewBlock("SolveEquation", GenerateUniqueName("Generic-"), {
			VisualLibrary.NewInput("Equation", path),
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["version"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return
		end
		return {VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Version-"), {
			VisualLibrary.NewInput("Value", script.Parent.Parent.Version.Value),
			VisualLibrary.NewOutput("VariableName", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["credits"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return
		end
		return {VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Version-"), {
			VisualLibrary.NewInput("Value", script.Parent.Parent.Credits.Value),
			VisualLibrary.NewOutput("VariableName", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
}
local OutputSizes = {
	["version"]=1,
	["credits"]=1,
	["path"]=1,
	["equation"]=1,
}
return {DefaultAbstractFunctions, OutputSizes}