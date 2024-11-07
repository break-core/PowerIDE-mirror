local VisualLibrary = require(script.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local SingleBlockFormatData = {}

local SingleBlockNames = {
	"MakeJoints",
	"BreakJoints",
	"SetNetworkOwner",

	"IsTouching",
	"GetTouchingParts",
	"GetConnectedParts",

	"SetPartPhysicalProperties",
	"GetPartPhysicalProperties",
	"FireRocketPropulsion",
	"AbortRocketPropulsion",
	--"RegisterCollisionGroup",
	--"CollisionGroupSetCollidable",
	"AssignCollisionGroup",
	"MoveModelTo",
	"SetModelPrimaryPartCFrame",
	"GetModelBoundingBox",
	Play="PlaySound",
	Stop="StopSound",
	Pause="PauseSound",
	Resume="ResumeSound",
	CaptureFocus="TextBoxCaptureFocus",
	ReleaseFocus="TextBoxReleaseFocus",
	"GetPlayersOnTeam",
	Teleport="TeleportToPlace",
	Kick="KickPlayer",
	"GetPlayerFromCharacter",
	"HasBadge",
	"GiveBadge",
	"HasGamepass",
	Mute="MutePlayer",
	Ban="BanPlayer",
	IsEquipped="CheckToolEquipped",
	"TakeDamage",
	MoveTo="HumanoidMoveTo",
	"ChangeHumanoidState",
	"GetHumanoidState",
	TeleportToPosition="TeleportPlayerToPosition",
	"LoadCharacter",
	"GetPartDirection",
	
	Disconnect="DisconnectEvent",
	"IsConnected"
}

for key, value in pairs(SingleBlockNames) do
	local BlockName = value
	local PowerlangFriendlyName = value
	if key and not tonumber(key) then
		PowerlangFriendlyName = key
	end
	local BlockData = ProgrammingBlocksData.BlocksList[BlockName]
	if not BlockData then
		warn("Invalid block: " .. BlockName)
		continue
	end
	local Template = {TranslatesTo=BlockName, Inputs={}, Outputs={}}
	for k, inp in pairs(BlockData.Inputs) do
		Template.Inputs[inp.ListOrder] = k
	end
	for _, k in pairs(BlockData.Outputs) do
		table.insert(Template.Outputs, k)
	end
	if #Template.Inputs == 0 then
		warn("Not instance function!!: " .. value)
	end
	SingleBlockFormatData[PowerlangFriendlyName] = Template
end



function SingleBlockFunction(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext, OwnFunction)
	local Data = SingleBlockFormatData[OwnFunction]
	if not Data then
		EWI.Error(8, SharedContext, ExecutableContext, "Event fail. Please report to developers")
		return
	end
	local InputsOutputs = {}
	for i = 1, #TupleArguments + 1 do
		local InputNameHere = Data.Inputs[i]
		if i == 1 then
			if OwnFunction == "Disconnect" or OwnFunction == "IsConnected" then
				local newInput = VisualLibrary.NewInput(InputNameHere, FunctionParent)
				newInput.InputType = "EventConnection"
				newInput.InputValueIsVariableName = false
				table.insert(InputsOutputs, newInput)
				continue
			end
			table.insert(InputsOutputs, VisualLibrary.NewInput(InputNameHere, VisualLibrary.NewIPath(FunctionParent)))
			continue
		end
		if not InputNameHere then
			break
		end
		TupleArguments[i - 1].InputName = InputNameHere
		table.insert(InputsOutputs, TupleArguments[i - 1])
	end
	if #SuboutputVariableNames > 0 then
		for o = 1, #SuboutputVariableNames do
			SuboutputVariableNames[o].OutputName = Data.Outputs[o]
			if not Data.Outputs[o] then
				continue
			end
			table.insert(InputsOutputs, SuboutputVariableNames[o])
		end
	end
	local OperationBlock = VisualLibrary.NewBlock(Data.TranslatesTo, GenerateUniqueName("instop-"), InputsOutputs)
	return {OperationBlock}
end

local InstanceFunctions = {
	["Clone"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 0 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:Clone() expects zero arguments, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		local OperationBlock = VisualLibrary.NewBlock("CloneObject", GenerateUniqueName("instop-"), {
			VisualLibrary.NewInput("Object", VisualLibrary.NewIPath(FunctionParent)),
			VisualLibrary.NewInput("Parent", VisualLibrary.NewIPath("game.Lighting")),
			VisualLibrary.NewOutput("NewObject", SuboutputVariableNames[1].OutputVariable)
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["Destroy"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 0 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:Destroy() expects zero arguments, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		local OperationBlock = VisualLibrary.NewBlock("DestroyObject", GenerateUniqueName("instop-"), {
			VisualLibrary.NewInput("Object", VisualLibrary.NewIPath(FunctionParent))
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["FindFirstChild"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments < 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:FindFirstChild() expects one to two arguments, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "ChildName"
		if TupleArguments[2] then
			TupleArguments[2].InputName = "Recursive"
		else
			TupleArguments[2] = VisualLibrary.NewInput("Recursive", false)
		end
		SuboutputVariableNames[1].OutputName = "Result"
		local OperationBlock = VisualLibrary.NewBlock("FindFirstChild", GenerateUniqueName("instop-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewInput("Parent", VisualLibrary.NewIPath(FunctionParent)),
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["FindFirstChildOfClass"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments < 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:FindFirstChildOfClass() expects one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "ChildClass"
		SuboutputVariableNames[1].OutputName = "Result"
		local OperationBlock = VisualLibrary.NewBlock("FindFirstChildOfClass", GenerateUniqueName("instop-"), {
			TupleArguments[1],
			VisualLibrary.NewInput("Parent", VisualLibrary.NewIPath(FunctionParent)),
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["FindFirstChildWhichIsA"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments < 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:FindFirstChildWhichIsA() expects one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "ChildClass"
		SuboutputVariableNames[1].OutputName = "Result"
		local OperationBlock = VisualLibrary.NewBlock("FindFirstChildWhichIsA", GenerateUniqueName("instop-"), {
			TupleArguments[1],
			VisualLibrary.NewInput("Parent", VisualLibrary.NewIPath(FunctionParent)),
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["GetChildren"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 0 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:GetChildren() expects zero arguments, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		SuboutputVariableNames[1].OutputName = "ChildrenTable"
		local OperationBlock = VisualLibrary.NewBlock("GetChildren", GenerateUniqueName("instop-"), {
			VisualLibrary.NewInput("Parent", VisualLibrary.NewIPath(FunctionParent)),
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["GetDescendants"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments ~= 0 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:GetDescendants() expects zero arguments, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		SuboutputVariableNames[1].OutputName = "DescendantTable"
		local OperationBlock = VisualLibrary.NewBlock("GetDescendants", GenerateUniqueName("instop-"), {
			VisualLibrary.NewInput("Parent", VisualLibrary.NewIPath(FunctionParent)),
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["IsA"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments < 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:IsA() expects one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "Class"
		SuboutputVariableNames[1].OutputName = "Result"
		local OperationBlock = VisualLibrary.NewBlock("IsA", GenerateUniqueName("instop-"), {
			TupleArguments[1],
			VisualLibrary.NewInput("Object", VisualLibrary.NewIPath(FunctionParent)),
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["IsAncestorOf"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments < 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:IsAncestorOf() expects one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1] = VisualLibrary.NewInput("Descendant", VisualLibrary.NewIPath(TupleArguments[1].InputValue))
		SuboutputVariableNames[1].OutputName = "OutputValue"
		local OperationBlock = VisualLibrary.NewBlock("IsAncestorOf", GenerateUniqueName("instop-"), {
			TupleArguments[1],
			VisualLibrary.NewInput("Ancestor", VisualLibrary.NewIPath(FunctionParent)),
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["IsDescendantOf"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments < 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:IsDescendantOf() expects one argument, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1] = VisualLibrary.NewInput("Ancestor", VisualLibrary.NewIPath(TupleArguments[1].InputValue))
		SuboutputVariableNames[1].OutputName = "OutputValue"
		local OperationBlock = VisualLibrary.NewBlock("IsDescendantOf", GenerateUniqueName("instop-"), {
			TupleArguments[1],
			VisualLibrary.NewInput("Descendant", VisualLibrary.NewIPath(FunctionParent)),
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["WaitForChild"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #TupleArguments < 1 then
			EWI.Error(14, SharedContext, ExecutableContext, "Instance:WaitForChild() expects one to two arguments, got " .. #TupleArguments)
		end
		local BlocksCreatedHere = {}
		TupleArguments[1].InputName = "ChildName"
		if TupleArguments[2] then
			TupleArguments[2].InputName = "TimeOut"
		else
			TupleArguments[2] = VisualLibrary.NewInput("TimeOut", 5)
		end
		SuboutputVariableNames[1].OutputName = "Result"
		local OperationBlock = VisualLibrary.NewBlock("WaitForChild", GenerateUniqueName("instop-"), {
			TupleArguments[1],
			TupleArguments[2],
			VisualLibrary.NewInput("Parent", VisualLibrary.NewIPath(FunctionParent)),
			SuboutputVariableNames[1]
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	-- Instance functions over
	--TODO: fix this causing a retrostudio meltdown
	["FireServer"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- RemoteFireServer2
		local BlocksCreatedHere = {}

		local OperationBlock = VisualLibrary.NewBlock("RemoteFireServer2", GenerateUniqueName("fire-"), {
			VisualLibrary.NewInput("RemoteEvent", VisualLibrary.NewIPath(FunctionParent)),
			VisualLibrary.NewTuple("Parameters", TupleArguments)
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["FireClient"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- RemoteFireClient2
		local BlocksCreatedHere = {}
		local Args = {}
		if #TupleArguments > 1 then
			table.move(TupleArguments, 2, #TupleArguments, 1, Args)
		end
		local OperationBlock = VisualLibrary.NewBlock("RemoteFireClient2", GenerateUniqueName("fire-"), {
			VisualLibrary.NewInput("RemoteEvent", VisualLibrary.NewIPath(FunctionParent)),
			VisualLibrary.NewInput("Player", VisualLibrary.NewIPath(TupleArguments[1].InputValue)),
			VisualLibrary.NewTuple("Parameters", Args)
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["Fire"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- BindableFire2
		local BlocksCreatedHere = {}
		local OperationBlock = VisualLibrary.NewBlock("BindableFire2", GenerateUniqueName("fire-"), {
			VisualLibrary.NewInput("BindableEvent", VisualLibrary.NewIPath(FunctionParent)),
			VisualLibrary.NewTuple("Parameters", TupleArguments)
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["Invoke"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		local BlocksCreatedHere = {}

		local OperationBlock = VisualLibrary.NewBlock("BindableFunctionInvoke", GenerateUniqueName("invoke-"), {
			VisualLibrary.NewInput("BindableFunction", VisualLibrary.NewIPath(FunctionParent)),
			VisualLibrary.NewTuple("Parameters", TupleArguments),
			VisualLibrary.NewTuple("Output", SuboutputVariableNames, true)
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["InvokeServer"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- RemoteFunctionInvokeServer
		local BlocksCreatedHere = {}

		local OperationBlock = VisualLibrary.NewBlock("RemoteFunctionInvokeServer", GenerateUniqueName("fire-"), {
			VisualLibrary.NewInput("RemoteFunction", VisualLibrary.NewIPath(FunctionParent)),
			VisualLibrary.NewTuple("Parameters", TupleArguments),
			VisualLibrary.NewTuple("Output", SuboutputVariableNames, true)
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
	["InvokeClient"]=function(FunctionParent, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		-- RemoteFunctionInvokeClient
		local BlocksCreatedHere = {}
		local Args = {}
		if #TupleArguments > 1 then
			table.move(TupleArguments, 2, #TupleArguments, 1, Args)
		end
		local OperationBlock = VisualLibrary.NewBlock("RemoteFunctionInvokeClient", GenerateUniqueName("fire-"), {
			VisualLibrary.NewInput("RemoteFunction", VisualLibrary.NewIPath(FunctionParent)),
			VisualLibrary.NewInput("Player", VisualLibrary.NewIPath(TupleArguments[1].InputValue)),
			VisualLibrary.NewTuple("Parameters", Args),
			VisualLibrary.NewTuple("Output", SuboutputVariableNames, true)
		})
		table.insert(BlocksCreatedHere, OperationBlock)
		return BlocksCreatedHere
	end,
}

for fName, _ in pairs(SingleBlockFormatData) do
	InstanceFunctions[fName] = SingleBlockFunction
end

return InstanceFunctions