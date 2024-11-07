local VisualLibrary = require(script.Parent.Parent.Parent.VisualLibrary.Version2)
local EWI = require(script.Parent.Parent.Parent.ErrorsWarnsInfos)
local ProgrammingBlocksData = require(script.Parent.Parent.Parent.ProgrammingBlocksData)
local UniqueIDService = require(script.Parent.Parent.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

local DefaultAbstractFunctions = {
	["RegisterCollisionGroup"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 2 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to PhysicsService.RegisterCollisionGroup(). 2 are required")
		end
		TupleArguments[1].InputName = "GroupName"
		TupleArguments[2].InputName = "Unregister"
		return {VisualLibrary.NewBlock("RegisterCollisionGroup", GenerateUniqueName("Collision-"), {
			TupleArguments[1],
			TupleArguments[2],
		})}
	end,
	["SetCollidable"]=function(FunctionBeingCalled, TupleArguments:{VisualLibrary.BlockInput}, SuboutputVariableNames, ExecutableContext, SharedContext)
		if #SuboutputVariableNames == 0 then
			return {}
		end
		if #TupleArguments < 3 then
			EWI.Error(19, SharedContext, ExecutableContext, "Insufficient arguments given to PhysicsService.SetCollidable(). 3 are required")
		end
		TupleArguments[1].InputName = "GroupName1"
		TupleArguments[2].InputName = "GroupName2"
		TupleArguments[3].InputName = "Collidable"
		return {VisualLibrary.NewBlock("CollisionGroupSetCollidable", GenerateUniqueName("Collision-"), {
			TupleArguments[1],
			TupleArguments[2],
			TupleArguments[3]
		})}
	end,
}
local OutputSizes = {
	["RegisterCollisionGroup"]=0,
	["SetCollidable"]=0,
}
return {DefaultAbstractFunctions, OutputSizes}