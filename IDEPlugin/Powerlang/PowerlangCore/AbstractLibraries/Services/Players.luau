local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["GetPlayerFromCharacter"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to getPlayerFromModel. 1 is required")
		end
		TupleArguments[1].InputName = "Character"
		return {VisualLibrary.NewBlock("GetPlayerFromCharacter", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Player", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["SetMouseIconLocal"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to SetMouseIconLocal. 1 is required")
		end
		TupleArguments[1].InputName = "Icon"
		return {VisualLibrary.NewBlock("SetMouseIconLocal", GenerateUniqueName("Create-"), {
			TupleArguments[1],
		})}
	end,
	["GetNameFromUserIdAsync"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to GetNameFromUserIdAsync. 1 is required")
		end
		TupleArguments[1].InputName = "UserId"
		return {VisualLibrary.NewBlock("GetNameFromUserIdAsync", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Username", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["GetUserIdFromNameAsync"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to GetUserIdFromNameAsync. 1 is required")
		end
		TupleArguments[1].InputName = "Username"
		return {VisualLibrary.NewBlock("GetUserIdFromNameAsync", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("UserId", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	["UnbanPlayer"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to UnbanPlayer. 1 is required")
		end
		TupleArguments[1].InputName = "UserId"
		return {VisualLibrary.NewBlock("UnbanPlayerUID", GenerateUniqueName("Create-"), {
			TupleArguments[1],
		})}
	end,
	["IsPlayerBanned"] = function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 1 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to IsPlayerBanned. 1 is required")
		end
		TupleArguments[1].InputName = "UserId"
		return {VisualLibrary.NewBlock("CheckIfPlayerIsBanned", GenerateUniqueName("Create-"), {
			TupleArguments[1],
			VisualLibrary.NewOutput("Result", SuboutputVariableNames[1].OutputVariable)
		})}
	end,
	
}
local OutputSizes = {
	["GetPlayerFromCharacter"]=1,
	["SetMouseIconLocal"]=0,
	["GetNameFromUserIdAsync"]=1,
	["GetUserIdFromNameAsync"]=1,
	["UnbanPlayer"]=0,
	["IsPlayerBanned"]=1,
	
}
return {DefaultAbstractFunctions, OutputSizes}