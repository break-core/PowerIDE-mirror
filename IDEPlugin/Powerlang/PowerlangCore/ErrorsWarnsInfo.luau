local SharedClasses = require(script.Parent.SharedClasses)
local CodeList = {
	"UnexpectedCharacter",
	"UnknownDirective",
	"EndOfFile",
	"InvalidVariableDefinition",
	"UnclosedString", -- 5
	"MisplacedOperator",
	"InvalidOperation",
	"NotYourFault",
	"InvalidAssignment",
	"NotImplemented", -- 10
	"InvalidMultiAssignment",
	"InvalidFlag",
	"UndefinedFunctionSize",
	"InvalidArgumentCount",
	"CompilerServicesError", -- 15
	"InvalidReturn",
	"UnknownInstanceOperation",
	"DirectiveNotValidHere",
	"InsufficientArguments",
	"InternalImplementation", -- 20
	"UnknownEvent",
	"DeprecatedFeature",
	"NestedThread",
}

local module = {
	--template code, to be improved later
	Error = function(code:number, context:SharedClasses.SharedContext, econtext:SharedClasses.ExecutableContext, msg:string?)
		local CrtPointerPosition = context.CurrentPointer.PointingTo
		local ErrorLine = 1
		for Line, LineStart in pairs(context.CurrentPointer.LineBreaks) do
			if Line > ErrorLine and LineStart < CrtPointerPosition then
				ErrorLine = Line
			end
		end
		local StackTrace = ""
		local i = 0
		for _, parent in pairs(econtext.InvokedStack) do
			local ScriptName = `{parent.ScriptName}`
			if parent.LastPointer then
				local CrtPointerPosition = parent.LastPointer.PointingTo
				local ErrorLine = 1
				for Line, LineStart in pairs(parent.LastPointer.LineBreaks) do
					if Line > ErrorLine and LineStart < CrtPointerPosition then
						ErrorLine = Line
					end
				end
				ScriptName = `{parent.ScriptName}:{ErrorLine}:{CrtPointerPosition - parent.LastPointer.LineBreaks[ErrorLine] + 1}`
			end
			StackTrace = string.rep("  ", i) .. ScriptName .. " ->\n" .. StackTrace
			i += 1
		end
		StackTrace = StackTrace .. string.rep("  ", i) .. `{econtext.ScriptName}:{ErrorLine}:{CrtPointerPosition - context.CurrentPointer.LineBreaks[ErrorLine] + 1}`
		local Message = string.format("\n%s:\n%s (%s)", StackTrace, msg or "Error message not provided", CodeList[code])
		error(Message)
	end,
	Warn = function(code:number, context:SharedClasses.SharedContext, econtext:SharedClasses.ExecutableContext, msg:string?)
		local CrtPointerPosition = context.CurrentPointer.PointingTo
		local ErrorLine = 1
		for Line, LineStart in pairs(context.CurrentPointer.LineBreaks) do
			if Line > ErrorLine and LineStart < CrtPointerPosition then
				ErrorLine = Line
			end
		end
		local StackTrace = ""
		local i = 0
		for _, parent in pairs(econtext.InvokedStack) do
			local ScriptName = `{parent.ScriptName}`
			if parent.LastPointer then
				local CrtPointerPosition = parent.LastPointer.PointingTo
				local ErrorLine = 1
				for Line, LineStart in pairs(parent.LastPointer.LineBreaks) do
					if Line > ErrorLine and LineStart < CrtPointerPosition then
						ErrorLine = Line
					end
				end
				ScriptName = `{parent.ScriptName}:{ErrorLine}:{CrtPointerPosition - parent.LastPointer.LineBreaks[ErrorLine] + 1}`
			end
			StackTrace = string.rep("  ", i) .. ScriptName .. " ->\n" .. StackTrace
			i += 1
		end
		StackTrace = StackTrace .. string.rep("  ", i) .. `{econtext.ScriptName}:{ErrorLine}:{CrtPointerPosition - context.CurrentPointer.LineBreaks[ErrorLine] + 1}`
		local Message = string.format("\n%s:\n%s (%s)", StackTrace, msg or "Error message not provided", CodeList[code])
		warn(Message)
		local firstecontext = econtext
		if #econtext.InvokedStack > 0 then
			firstecontext = econtext.InvokedStack[#econtext.InvokedStack]
		end
		firstecontext.Warns += 1
	end,
	Info = function(code:number, context:SharedClasses.SharedContext, msg:string?)
		print(CodeList[code])
	end,
	CodeList = CodeList
}

return module
