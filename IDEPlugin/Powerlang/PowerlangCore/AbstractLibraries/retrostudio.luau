local VisualLibrary = require(script.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local SingleBlockFormatData = {}

local SingleBlockNames = {
	"InsertModel",
	"IsGameLoaded",
	"GetRobloxVersion",
	"IsStudio",
	"IsPlayingSolo",
	"IsGuest",
	"IsTouchscreen",
	"OsTime",
	"OsClock",
	"OsDate",
	"AddDebrisItem",
	"IsFriendsWith",
	"IsInGroup",
	"GetRankInGroup",
	"GetStudioSelection",
	"ReloadPlace",
	"InsertRetrostudioAvatar",
	"GetServerTimeNow",
	"DumpMemory"
}

local OutputSizes = {}

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
	for k, _ in pairs(BlockData.Inputs) do
		table.insert(Template.Inputs, k)
	end
	for _, k in pairs(BlockData.Outputs) do
		table.insert(Template.Outputs, k)
	end
	SingleBlockFormatData[PowerlangFriendlyName] = Template
	OutputSizes[PowerlangFriendlyName] = #Template.Outputs
end



function SingleBlockFunction(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
	FunctionBeingCalled = string.split(FunctionBeingCalled, ".")[2]
	local Data = SingleBlockFormatData[FunctionBeingCalled]
	if not Data then
		print(SingleBlockFormatData)
		EWI.Error(8, SharedContext, ExecutableContext, "retrostudio library fail. Please report to developers. Function being called: " .. FunctionBeingCalled)
		return
	end
	local InputsOutputs = {}
	for i = 1, #TupleArguments do
		local InputNameHere = Data.Inputs[i]
		if not InputNameHere then
			break
		end
		TupleArguments[i].InputName = InputNameHere
		table.insert(InputsOutputs, VisualLibrary.NewInput(InputNameHere, TupleArguments[i]))
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
	local OperationBlock = VisualLibrary.NewBlock(Data.TranslatesTo, GenerateUniqueName("retro-"), InputsOutputs)
	return {OperationBlock}
end

local DefaultAbstractFunctions = {}

for fName, _ in pairs(SingleBlockFormatData) do
	DefaultAbstractFunctions[fName] = SingleBlockFunction
end

return {DefaultAbstractFunctions, OutputSizes}