local VisualLibrary = require(script.Parent.VisualLibrary.Version2)

export type Pointer = {
	PointingTo:number,
	Maximum:number,
	LineBreaks:{number},
	Increment:(self:Pointer, HowMuch:number?) -> (boolean),
	GetPointedCharacter:(self:Pointer, str:string) -> (string),
}

export type Flags = {
	Flags:{string},
	HasFlag:(self:Flags, flag:string)->(boolean),
	SetFlag:(self:Flags, flag:string)->(),
}

export type ExecutableContext = {
	-- For executable blocks, like a script.
	ScriptName:string,
	InvokedStack:{ExecutableContext},
	DefinedVariables:{},
	IsScriptLocal:boolean,
	IsSubBlock:boolean,
	Flags:Flags,
	LastIfBlock:VisualLibrary.AbstractBlock?,
	LastLoopData:{ReEvalBlockName:string, StepOutBlockName:string, ContinueBlockName:string?}?,
	LastCreatedBlock:VisualLibrary.AbstractBlock?,
	Warns:number
}

export type SharedContext = {
	-- For progress in a script
	ParentExecutableContext:ExecutableContext,
	CurrentPointer:Pointer,
} 

local Construct = {}

function Construct.Pointer(source:string | number)
	local Maximum
	if typeof(source) == "string" then
		Maximum = #source
	else
		Maximum = source
	end
	local NewPointer:Pointer = {
		PointingTo=0,
		Maximum=Maximum,
		Increment=function(self, HowMuch)
			local Expected = self.PointingTo + (HowMuch or 1)
			self.PointingTo = math.clamp(self.PointingTo + (HowMuch or 1), 0, self.Maximum)
			return Expected == self.PointingTo
		end,
		GetPointedCharacter=function(self, str)
			return string.sub(str, self.PointingTo + 1, self.PointingTo + 1)
		end,
		LineBreaks={0}
	}
	if typeof(source) == "string" then
		for i=1, #source do
			if string.sub(source, i, i) == "\n" then
				table.insert(NewPointer.LineBreaks, i)
			end
		end
	end
	return NewPointer
end

function Construct.FlagSet()
	local NewFlagSet:Flags = {
		Flags={},
		HasFlag=function(self, flag)
			return table.find(self.Flags, flag) ~= nil
		end,
		SetFlag=function(self, flag)
			table.insert(self.Flags, flag)
		end,
	}
	return NewFlagSet
end

function Construct.SharedContext(parent:ExecutableContext, pointer:Pointer)
	local NewSharedContext:SharedContext = {
		ParentExecutableContext=parent,
		CurrentPointer=pointer,
	}
	return NewSharedContext
end

function Construct.ExecutableContext(scriptName:string, invokestack:{ExecutableContext}?, isSubBlock:boolean?, lastPointer:Pointer | {}?)
	local NewExecutableContext:ExecutableContext = {
		ScriptName=scriptName,
		InvokedStack={},
		DefinedVariables={},
		IsSubBlock=isSubBlock or false,
		IsScriptLocal=false,
		LastPointer=lastPointer,
		Flags=Construct.FlagSet(),
		Warns=0
	}
	if invokestack then
		NewExecutableContext.InvokedStack = invokestack
	end
	return NewExecutableContext
end

return Construct