local SharedClasses = require(script.Parent.SharedClasses)
local SyntaxBasics = require(script.Parent.SyntaxBasics)
local EWI = require(script.Parent.ErrorsWarnsInfos)
local Tokenizer = require(script.Parent.Tokenizer)
local Operators = require(script.Parent.Operators)
local VisualLibrary = require(script.Parent.VisualLibrary.Version2)
local PathTraversal = require(script.Parent.PathTraversal)
local DefaultAbstractFunctions = require(script.Parent.DefaultAbstractFunctions)[1]
local DefaultAbstractOutputSizes = require(script.Parent.DefaultAbstractFunctions)[2]
local InstanceFunctions = require(script.Parent.InstanceFunctions)
local UniqueIDService = require(script.Parent.UniqueIDService)
local Events = require(script.Parent.Events)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

function GetPathToBlocks(StringPath, BlocksCreated, IsFunction)
	local Path = PathTraversal.ParsePathForGet(StringPath)
	local LastStep = Path.Steps[1]
	for i, Step in pairs(Path.Steps) do
		if i == 1 then
			continue
		end
		local OutputVariable = GenerateUniqueName("InstanceProp-")
		local TraversalBlock = VisualLibrary.NewBlock("GetTableValue", GenerateUniqueName("Traversal-"), {
			VisualLibrary.NewInput("Table", LastStep),
			VisualLibrary.NewInput("Key", Step),
			VisualLibrary.NewOutput("Value", OutputVariable)
		})
		if #BlocksCreated > 0 then
			BlocksCreated[#BlocksCreated]:ConnectToBlock(TraversalBlock)
		end
		table.insert(BlocksCreated, TraversalBlock)
		LastStep = OutputVariable
	end
	if IsFunction then
		return LastStep, Path.InstanceCall
	end
	return LastStep
end

function PrintTokenTable(tokens)
	local result = ""
	for _, token in pairs(tokens) do
		result = result .. tostring(token.Content)
	end
	--print(result)
end

function DECLARE(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, CalledFromAnotherDirective:any?, IgnoreAssignment:boolean?, AllowAnonymousFunctions:boolean?, EventOverride:boolean?)
	-- Let the tokenizer do its thing
	local Core = nil
	local IsFirstBlockSeparate = false --if true, this declare will not be connected to root
	-- hack
	if typeof(CalledFromAnotherDirective) == "table" then
		AllowAnonymousFunctions = true
		Core = CalledFromAnotherDirective
	end
	local AllowedBreakChars = {";", "{"}
	if ExecutableContext.Flags:HasFlag("AllowNoSemicolons") then
		AllowedBreakChars = {";", "{", "\n"}
	end
	if EventOverride then
		table.insert(AllowedBreakChars, "(")
		table.insert(AllowedBreakChars, ")")
	end
	if AllowAnonymousFunctions then
		table.remove(AllowedBreakChars, 2)
	end
	local Tokens = Tokenizer.Parse(Source, MainPointer, SharedContext, ExecutableContext, AllowedBreakChars, Core)
	local BlocksCreatedHere:{VisualLibrary.AbstractBlock} = {}
	-- convert negative variables
	for i, Token in pairs(Tokens) do
		if Token.Type == "Variable" and string.sub(Token.Content, 1, 1) == "-" then
			local OutputTo = GenerateUniqueName("Operator-")
			local NegateBlock = VisualLibrary.NewBlock("Subtraction", "Operator-", {
				VisualLibrary.NewInput("Number1", 0),
				VisualLibrary.NewInput("Number2", string.sub(Token.Content, 2), true),
				VisualLibrary.NewOutput("Result", OutputTo)
			})
			table.insert(BlocksCreatedHere, NegateBlock)
			Token.Content = OutputTo
		end
	end
	
	-- Process bracket pairs
	local _TempStack = {}
	local BracketPairs = {}
	for i, Token in pairs(Tokens) do
		if Token.Type ~= "Bracket" then
			continue
		end
		if Token.Content == "(" then
			table.insert(_TempStack, i)
		elseif Token.Content == ")" then
			local StartToken = _TempStack[#_TempStack]
			if not StartToken then
				EWI.Error(1, SharedContext, ExecutableContext, "Unexpected closing bracket")
				continue
			end
			table.insert(BracketPairs, {StartToken, i})
			table.remove(_TempStack, #_TempStack)
		end
	end
	if #_TempStack > 0 then
		EWI.Error(1, SharedContext, ExecutableContext, "Unclosed bracket")
	end
	table.insert(BracketPairs, {0, #Tokens + 1})
	-- Now we process the bracket pairs!
	local BracketTupleData = {
		Example = {"token1here", "token2here"}
	}
	local leftshift = 0
	for _, BracketPair in pairs(BracketPairs) do
		local IsTuple = false
		local TupleTokenItems = {}
		local LastComma = 1
		local OwnTokensUnfiltered = {}
		table.move(Tokens, BracketPair[1] + 1, BracketPair[2] - 1, 1, OwnTokensUnfiltered)
		local OwnTokens = {}
		local LocalShift = 0
		for _, tkn in pairs(OwnTokensUnfiltered) do
			if tkn ~= 0 then
				table.insert(OwnTokens, tkn)
			else
				LocalShift += 1
			end
		end
		local FormerlyTokens = #Tokens
		local TokensOnceInBracket = #OwnTokensUnfiltered
		local FutureBracketTokenName = GenerateUniqueName("Bracket-")
		-- Let's process indexes
		local _TempStack = {}
		local TableIndexPairs = {}
		for i, Token in pairs(OwnTokens) do
			if Token.Type ~= "Index" then
				continue
			end
			if Token.Content == "[" then
				table.insert(_TempStack, i)
			elseif Token.Content == "]" then
				local StartToken = _TempStack[#_TempStack]
				if not StartToken then
					EWI.Error(1, SharedContext, ExecutableContext, "Unexpected closing table index")
					continue
				end
				table.insert(TableIndexPairs, {StartToken, i})
				table.remove(_TempStack, #_TempStack)
			end
		end
		if #_TempStack > 0 then
			EWI.Error(1, SharedContext, ExecutableContext, "Unclosed index")
		end
		table.insert(TableIndexPairs, {0, #OwnTokens + 1})
		-- i LOVE loops in loops!!
		for _, IndexPair in pairs(TableIndexPairs) do
			local isRealTableIndex = true
			if IndexPair[1] == 0 then
				isRealTableIndex = false
			end
			local FutureTokenName = GenerateUniqueName("TableIndex-") -- needed to save result
			local IndexTokens = {}
			local IndexTokensUnfiltered = {}
			
			table.move(OwnTokens, IndexPair[1] + 1, IndexPair[2] - 1, 1, IndexTokensUnfiltered)
			for _, tkn in pairs(IndexTokensUnfiltered) do
				if tkn and tkn ~= 0 then
					table.insert(IndexTokens, tkn)
				end
			end
			local TokensWeHad = #IndexTokensUnfiltered
			-- Preprocess dot indexes to avoid issues with function calls for Instances/Tables
			local i = 1
			while i <= #IndexTokens do
				local Token = IndexTokens[i]
				if not Token then
					i+=1
					continue
				end
				if Token.Type == "Operator" and (Token.Content == "." or Token.Content == ":") then
					local TokenPrev = IndexTokens[i-1]
					local TokenNext = IndexTokens[i+1]
					if not TokenPrev or not TokenNext then
						EWI.Error(6, SharedContext, ExecutableContext, ". not permitted here")
					end
					if not table.find({"Variable", "BracketResultTuple"}, TokenPrev.Type) or TokenNext.Type ~= "Variable" then
						i+=1
						continue
						--EWI.Error(7, SharedContext, ExecutableContext, "Cannot index " .. TokenPrev.Type .. " with " .. TokenNext.Type)
					end
					if TokenPrev.Type == "BracketResultTuple" then
						i+=1
						continue
					end
					if TokenPrev.AssociatedWithFunction then
						i+=1
						continue
					end
					local NewToken = {Type="Variable", Content=`{TokenPrev.Content}{Token.Content}{TokenNext.Content}`}
					for _ = 1,3 do
						table.remove(IndexTokens, i-1)
					end
					table.insert(IndexTokens, i-1, NewToken)
					local NextToken = IndexTokens[i]
					if NextToken and NextToken.IsBracket then
						NextToken.AssociatedWithFunction = true
					end
					i-=3
				end
				i+=1
			end
			-- Now process function calls and indexes from left to right
			-- Types of brackets: BracketResult, TableIndex
			local i = 1
			local LastToken = nil
			while i <= #IndexTokens do
				local Token = IndexTokens[i]
				local MaybeLastToken = IndexTokens[i-1]
				if MaybeLastToken then
					LastToken = MaybeLastToken
				end
				if not Token or Token == 0 then
					i+=1
					continue
				end
				if table.find({"BracketResultTuple", "FunctionTuple", "BracketResult", "TableIndex", "Variable"}, Token.Type) or Token.IsBracket then
					if Token.Type == "Variable" and not Token.IsBracket then
						i+=1
						LastToken = Token
						continue
					end
					if not LastToken or not table.find({"Variable", "TableIndex"}, LastToken.Type) then
						i+=1
						LastToken = Token
						continue
					end
					local CallOutputName = GenerateUniqueName("CallIndexOutput-")
					if Token.Type == "TableIndex" then
						local TokenAfter = IndexTokens[i+1]
						--print(`Table index: {LastToken.Content}[{Token.Content}] -> {CallOutputName}`)
						local NextTokenContent = Token.Content
						if Token.OriginalType == "Number" then
							NextTokenContent = tonumber(NextTokenContent)
						elseif Token.OriginalType == "Boolean" then
							NextTokenContent = NextTokenContent == "true"
						elseif Token.OriginalType == "Variable" and string.find(Token.Content, ".", nil, true) then
							NextTokenContent = GetPathToBlocks(Token.Content, BlocksCreatedHere)
						end
						if not (TokenAfter and TokenAfter.Type == "Operator" and TokenAfter.Content == "=") then
							local IndexBlock = VisualLibrary.NewBlock("GetTableValue", GenerateUniqueName("Traversal-"), {
								VisualLibrary.NewInput("Table", LastToken.Content),
								VisualLibrary.NewInput("Key", NextTokenContent, Token.OriginalType == "Variable"),
								VisualLibrary.NewOutput("Value", CallOutputName)
							})
							if #BlocksCreatedHere > 0 then
								BlocksCreatedHere[#BlocksCreatedHere]:ConnectToBlock(IndexBlock)
							end
							table.insert(BlocksCreatedHere, IndexBlock)
						end
						for _ = 1,2 do
							table.remove(IndexTokens, i-1)
						end
						table.insert(IndexTokens, i-1, {Type="Variable", Content=CallOutputName, OriginalTableToken=LastToken, OriginalKey=NextTokenContent, IsKeyVariable=(Token.OriginalType == "Variable")})
						i-=1
					else
						-- oh lord

						-- WIP WIP WIP WIP WIP WIP TODO TODO TODO!!!!!!!!!
						local FunctionBeingCalled = LastToken.Content
						local IsInstanceFunction = (string.find(LastToken.Content, ":", nil, true) ~= nil)
						local FunctionParent = nil
						local Arguments = Token.Content
						local OutputVariable = GenerateUniqueName("FunctionOutput-")
						if not DefaultAbstractFunctions[LastToken.Content] then
							if (string.find(FunctionBeingCalled, ".", nil, true) or string.find(FunctionBeingCalled, ":", nil, true)) and IsInstanceFunction then
								local LastStep, InstanceCall = GetPathToBlocks(FunctionBeingCalled, BlocksCreatedHere, true)
								FunctionBeingCalled = InstanceCall
								FunctionParent = LastStep
							end
							if (string.find(FunctionBeingCalled, ".", nil, true) or string.find(FunctionBeingCalled, ":", nil, true)) and not IsInstanceFunction then
								local LastStep = GetPathToBlocks(FunctionBeingCalled, BlocksCreatedHere)
								FunctionBeingCalled = LastStep
							end
						end
						--print(`Call: {FunctionParent}:{FunctionBeingCalled}({Arguments}) -> {OutputVariable}`)
						-- calling a function isn't the hardest part,
						-- collecting its result is 😡😡😡
						
						local TupleArguments = {}
						if string.find(Token.Type, "Tuple") then
							for _, Tokon in pairs(Token.Content) do
								local ThisItemContent = Tokon.Content
								if Tokon.Type == "Number" then
									ThisItemContent = tonumber(Tokon.Content)
								elseif Tokon.Type == "Boolean" then
									ThisItemContent = Tokon.Content == "true"
								elseif Tokon.Type == "Variable" and string.find(Tokon.Content, ".", nil, true) then
									ThisItemContent = GetPathToBlocks(Tokon.Content, BlocksCreatedHere)
								elseif string.find(Tokon.Type, "Tuple") then
									EWI.Error(10, SharedContext, ExecutableContext, "Passing tuples as function arguments is not yet possible in this version of Powerlang")
								elseif Tokon.Type == "AnonymousFunction" then
									EWI.Error(10, SharedContext, ExecutableContext, "Passing an anonymous function as an argument here is not yet supported in this version of Powerlang")
								end

								table.insert(TupleArguments, VisualLibrary.NewInput("", ThisItemContent, Tokon.Type == "Variable"))
							end
						else
							local ThisItemContent = Token.Content 
							if Token.Type == "Number" then
								ThisItemContent = tonumber(Token.Content)
							elseif Token.Type == "Boolean" then
								ThisItemContent = Token.Content == "true"
							elseif Token.Type == "Variable" and string.find(Token.Content, ".", nil, true) then
								ThisItemContent = GetPathToBlocks(Token.Content, BlocksCreatedHere)
							elseif Token.Type == "AnonymousFunction" then
								EWI.Error(10, SharedContext, ExecutableContext, "Passing an anonymous function as an argument here is not yet supported in this version of Powerlang")
							end
							table.insert(TupleArguments, VisualLibrary.NewInput("", ThisItemContent, Token.Type == "Variable"))
						end
						
						if not IsInstanceFunction then
							
							local OutputSize = ExecutableContext.DefinedVariables[LastToken.Content] or DefaultAbstractOutputSizes[LastToken.Content]
							if not OutputSize then
								OutputSize = 1
								EWI.Warn(13, SharedContext, ExecutableContext, `Function '{LastToken.Content}' return size unknown, only the first returned value will be considered.`)
							end
							local SuboutputVariableNames = {}
							if OutputSize > 1 then
								for _=1,OutputSize do
									table.insert(SuboutputVariableNames, VisualLibrary.NewOutput("", GenerateUniqueName("FunctionTupleOutput-")))
								end
							else
								table.insert(SuboutputVariableNames, VisualLibrary.NewOutput("", OutputVariable))
							end
							if DefaultAbstractFunctions[LastToken.Content] then
								--print("Found abstract function handler for " .. LastToken.Content)
								local BlocksCreatedDown, DoNotConnect = DefaultAbstractFunctions[LastToken.Content](FunctionBeingCalled, TupleArguments, SuboutputVariableNames, ExecutableContext, SharedContext, LastToken.Content)
								if #BlocksCreatedHere ~= 0 and #BlocksCreatedDown > 0 and not DoNotConnect then
									BlocksCreatedHere[#BlocksCreatedHere]:ConnectToBlock(BlocksCreatedDown[1])
								end
								if DoNotConnect and #BlocksCreatedHere == 0 then
									IsFirstBlockSeparate = true
								end
								table.move(BlocksCreatedDown, 1, #BlocksCreatedDown, #BlocksCreatedHere + 1, BlocksCreatedHere)
							else
								local CallFunctionBlock = VisualLibrary.NewBlock("ExecuteFunction", GenerateUniqueName("FunctionCall-"), {
									VisualLibrary.NewInput("Function", FunctionBeingCalled),
									VisualLibrary.NewTuple("Parameters", TupleArguments, false),
									VisualLibrary.NewTuple("ReturnedValues", SuboutputVariableNames, true),
								})
								if #BlocksCreatedHere ~= 0 then
									BlocksCreatedHere[#BlocksCreatedHere]:ConnectToBlock(CallFunctionBlock)
								end
								table.insert(BlocksCreatedHere, CallFunctionBlock)
							end
							for _ = 1,2 do
								table.remove(IndexTokens, i-1)
							end

							if #SuboutputVariableNames == 1 then
								table.insert(IndexTokens, i-1, {Type="Variable", Content=OutputVariable})
							elseif #SuboutputVariableNames > 1 then
								local SuboutputTokens = {}
								for _, Suboutput in pairs(SuboutputVariableNames) do
									table.insert(SuboutputTokens, {Type="Variable", Content=Suboutput.OutputVariable})
								end
								table.insert(IndexTokens, i-1, {Type="FunctionTuple", Content=SuboutputTokens})
							end
							
						else
							if InstanceFunctions[FunctionBeingCalled] then
								local SuboutputVariableNames = {VisualLibrary.NewOutput("", OutputVariable)}
								local BlocksCreatedDown = InstanceFunctions[FunctionBeingCalled](FunctionParent, TupleArguments, SuboutputVariableNames, ExecutableContext, SharedContext, FunctionBeingCalled)
								if #BlocksCreatedHere ~= 0 and #BlocksCreatedDown > 0 then
									BlocksCreatedHere[#BlocksCreatedHere]:ConnectToBlock(BlocksCreatedDown[1])
								end
								table.move(BlocksCreatedDown, 1, #BlocksCreatedDown, #BlocksCreatedHere + 1, BlocksCreatedHere)
								for _ = 1,2 do
									table.remove(IndexTokens, i-1)
								end

								if #SuboutputVariableNames == 1 then
									table.insert(IndexTokens, i-1, {Type="Variable", Content=OutputVariable})
								elseif #SuboutputVariableNames > 1 then
									local SuboutputTokens = {}
									for _, Suboutput in pairs(SuboutputVariableNames) do
										table.insert(SuboutputTokens, {Type="Variable", Content=Suboutput.OutputVariable})
									end
									table.insert(IndexTokens, i-1, {Type="FunctionTuple", Content=SuboutputTokens})
								end
							else
								EWI.Error(17, SharedContext, ExecutableContext, `The instance operation {FunctionBeingCalled} is unknown`)
							end
						end
					end
					-- TODO: the tokens are replaced with result variable or tuple
					-- if there is a dot or : in front, evaluate it as well
				end
				i+=1
				LastToken = Token
			end

			for _, OperatorSet in pairs(SyntaxBasics.OrderOfOperations) do
				local i = 1
				while i <= #IndexTokens do
					local Token = IndexTokens[i]
					if not Token then
						i+=1
						continue
					end
					if Token.Type == "Operator" and table.find(OperatorSet, Token.Content) then
						if Token.Content == "=" and BracketPair[1] ~= 0 then
							EWI.Error(9, SharedContext, ExecutableContext, "Cannot use = character in brackets or indexes")
							return
						end
						if Token.Content ~= "," then
							local Ignore = false
							if Token.Content == "=" and IgnoreAssignment then
								Ignore = true
							end
							if not Ignore then
								local BlocksCreatedByOperator = Operators[Token.Content](IndexTokens, i, GenerateUniqueName("EquationPiece-"), SharedContext, ExecutableContext)
								if IndexTokens[1].Type == "AssignmentResult" then
									IndexTokens = {IndexTokens[1]}
									OwnTokens = {IndexTokens[1]}
								end
								if #BlocksCreatedHere > 0 then
									BlocksCreatedHere[#BlocksCreatedHere]:ConnectToBlock(BlocksCreatedByOperator[1])
								end
								table.move(BlocksCreatedByOperator, 1, #BlocksCreatedByOperator, #BlocksCreatedHere + 1, BlocksCreatedHere)
							end
							if Token.Content == "not" or Token.Content == "=" then
								i+=1
							end
						else
							if IndexPair[1] ~= 0 then
								EWI.Error(1, SharedContext, ExecutableContext, "The , character was not expected here")
								return
							end
							IsTuple = true
							--local TokensForThisPart = {}
							--table.move(OwnTokens, LastComma, i, 1, TokensForThisPart)
							--table.insert(TupleTokenItems, TokensForThisPart)
							--LastComma = i
							i+=1
						end
						continue
					end
					i+=1
				end
			end
			-- This goes at the very end, to save the contents
			if IndexPair[1] == 0 then
				for _=1,TokensWeHad do
					table.remove(OwnTokens, IndexPair[1] + 1)
				end
			else
				for _=1,TokensWeHad+2 do
					table.remove(OwnTokens, IndexPair[1])
				end
			end
			if IsTuple and #IndexTokens > 1 and IndexPair[1] ~= 0 then
				EWI.Error(4, SharedContext, ExecutableContext, "Cannot define tuples in table indexes")
			end
			if (#IndexTokens ~= 1 and not IsTuple) and BracketPair[1] ~= BracketPair[2] - 1 then
				EWI.Error(7, SharedContext, ExecutableContext, "Invalid equation")
			end
			if not IsTuple and IndexPair[1] ~= 0 then
				IndexTokens[1].OriginalType = IndexTokens[1].Type
				IndexTokens[1].Type = "TableIndex"
			end

			if IndexPair[1] == 0 then
				for iii = 1, #IndexTokens do
					table.insert(OwnTokens, math.max(1, IndexPair[1] + 1) + iii - 1, IndexTokens[iii])
				end
			else
	
				for iii = 1, #IndexTokens do
					table.insert(OwnTokens, math.max(0, IndexPair[1]) + iii - 1, IndexTokens[iii])
				end
			end
			
			if IndexPair[1] ~= 0 then
				local diff = TokensWeHad+2 - #IndexTokens
				if diff > 0 then
					for _ = 1, diff do
						table.insert(OwnTokens, math.max(0, IndexPair[1]) + 1, 0)
					end
				end
			end
		end
		for _=1,TokensOnceInBracket+2 do
			table.remove(Tokens, math.max(1, BracketPair[1]))
			leftshift += 1
		end
		if (#OwnTokens ~= 1 and not IsTuple) and BracketPair[1] ~= BracketPair[2] - 1 then
			EWI.Error(7, SharedContext, ExecutableContext, "Invalid equation")
		end
		if BracketPair[1] ~= 0 and #OwnTokens ~= 0 then
			if IsTuple then
				BracketTupleData[OwnTokens[1].Content] = OwnTokens
				local TupleResult = {}
				for _, Token in pairs(OwnTokens) do
					if Token.Content == "," and Token.Type == "Operator" then
						continue
					end
					table.insert(TupleResult, {Content=Token.Content, Type=Token.Type, IsBracket=Token.IsBracket, AssociatedWithFunction=Token.AssociatedWithFunction})
				end
				OwnTokens[1].Content = TupleResult
				OwnTokens[1].Type = "BracketResultTuple"
			else
				OwnTokens[1].IsBracket = true
			end
		end
		if BracketPair[1] == BracketPair[2] - 1 then
			table.insert(Tokens, math.max(1, BracketPair[1]), {Content={}, Type="BracketResultTuple", IsBracket=true})
		else
			if not IsTuple then
				for iii = 1, #OwnTokens do
					table.insert(Tokens, math.max(1, BracketPair[1]) + iii - 1, OwnTokens[iii])
				end
			else
				if BracketPair[1] ~= 0 then
					table.insert(Tokens, math.max(1, BracketPair[1]), OwnTokens[1])
				else
					table.move(OwnTokens, 1, #OwnTokens, #Tokens + 1, Tokens)
				end
			end
			for _=1,TokensOnceInBracket+1 do
				table.insert(Tokens, math.max(1, BracketPair[1]) + 1, 0)
			end
		end
		if FormerlyTokens - #Tokens > 0 and BracketPair[1] ~= 0 then
			for _ = 1, FormerlyTokens - #Tokens do
				table.insert(Tokens, BracketPair[1], 0)
			end
		end
		leftshift -= 1
	end
	local TokensFiltered = {}
	for _, tokn in pairs(Tokens) do
		if tokn ~= 0 then
			table.insert(TokensFiltered, tokn)
		end
	end
	if CalledFromAnotherDirective == true then
		return TokensFiltered, BlocksCreatedHere
	end
	return BlocksCreatedHere, IsFirstBlockSeparate
end

local module = {
	["@FLAG"]=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext)
		local FlagToBeDeclared = ""
		while MainPointer.PointingTo < MainPointer.Maximum do
			local Character = MainPointer:GetPointedCharacter(Source)
			if Character == " " and #FlagToBeDeclared == 0 then
				MainPointer:Increment()
				continue
			end
			if Character == ";" or Character == "\n" then
				--print("Declaring flag " .. FlagToBeDeclared)
				if FlagToBeDeclared == "AllowNoSemicolons" then
					EWI.Warn(22, SharedContext, ExecutableContext, "The AllowNoSemicolons flag is declared by default starting from Powerlang 0.7. You do not need to declare it anymore.")
				end
				if not table.find(SyntaxBasics.FlagsAvailable, FlagToBeDeclared) then
					EWI.Error(12, SharedContext, ExecutableContext, "Unknown flag " .. FlagToBeDeclared)
				end
				ExecutableContext.Flags:SetFlag(FlagToBeDeclared)
				break
			end
			FlagToBeDeclared = FlagToBeDeclared .. Character
			MainPointer:Increment()
		end
		MainPointer:Increment()
		return {}
	end,
	["--"]=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext)
		while MainPointer.PointingTo < MainPointer.Maximum do
			local Character = MainPointer:GetPointedCharacter(Source)
			if Character == ";" or Character == "\n" then
				break
			end
			MainPointer:Increment()
		end
		MainPointer:Increment()
		return {}
	end,
	FUNCTION=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		local BlocksCreated = {}
		local FunctionName = ""
		local DataBuffer = ""
		local FunctionArgs = {}
		local DoneProcessingFunctionName = false
		local DoneProcessingArgs = false
		while MainPointer.PointingTo < MainPointer.Maximum do
			local Character = MainPointer:GetPointedCharacter(Source)
			if Character == "(" and not DoneProcessingFunctionName then
				if #DataBuffer == 0 then
					EWI.Error(1, SharedContext, ExecutableContext, "( was not expected before function name")
				end
				FunctionName = DataBuffer
				ExecutableContext.DefinedVariables[FunctionName] = 0
				DataBuffer = ""
				DoneProcessingFunctionName = true
				MainPointer:Increment()
				continue
			end
			if Character == ")" and DoneProcessingFunctionName and not DoneProcessingArgs then
				local ArgNames = string.split(DataBuffer, ",") -- BAD IDEA!!!!!!!!!
				for _, ArgName in pairs(ArgNames) do
					local stripped, _ = string.gsub(ArgName, " ", "")
					table.insert(FunctionArgs, VisualLibrary.NewOutput("", stripped))
				end
				DataBuffer = ""
				DoneProcessingArgs = true
				MainPointer:Increment()
				continue
			end
			if Character == "{" and DoneProcessingFunctionName and DoneProcessingArgs then
				-- Call the core to evaluate function
				local CallStack = {ExecutableContext}
				for _, ExtraCalls in pairs(ExecutableContext.InvokedStack) do
					table.insert(CallStack, ExtraCalls)
				end
				local SubExecutableContext = SharedClasses.ExecutableContext(FunctionName, CallStack, true)
				SubExecutableContext.DefinedVariables = ExecutableContext.DefinedVariables
				SubExecutableContext.Flags = ExecutableContext.Flags
				SubExecutableContext.LastLoopData = ExecutableContext.LastLoopData
				SubExecutableContext.LastCreatedBlock = ExecutableContext.LastCreatedBlock
				MainPointer:Increment()
				local FunctionBlocks = Core.powerlang.Parse(Source, SubExecutableContext, MainPointer, "}")

				local FunctionDefinitionBlock = VisualLibrary.NewBlock("DefineFunction", GenerateUniqueName("FunctionDefinition-"), {
					VisualLibrary.NewOutput("Function", FunctionName),
					VisualLibrary.NewTuple("Parameters", FunctionArgs, true)
				})
				if #FunctionBlocks > 0 then
					FunctionDefinitionBlock:ConnectToBlock(FunctionBlocks[1])
				end
				table.insert(BlocksCreated, FunctionDefinitionBlock)
				table.move(FunctionBlocks, 1, #FunctionBlocks, #BlocksCreated + 1, BlocksCreated)
				return BlocksCreated
			end
			if #DataBuffer == 0 and table.find(SyntaxBasics.Indentation, Character) then
				MainPointer:Increment()
				continue
			end
			if not DoneProcessingFunctionName and not string.find(SyntaxBasics.AllowedCharsInVariables, string.upper(Character), nil, true) then
				EWI.Error(1, SharedContext, ExecutableContext, "Unexpected character: " .. Character)
			end
			DataBuffer = DataBuffer .. Character
			if not MainPointer:Increment() then
				EWI.Error(3, SharedContext, ExecutableContext, "Reached end of file while parsing function statement")
			end
		end
		return BlocksCreated
	end,
	EVENT=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		local BlocksCreated = {}
		local FunctionName = ""
		local DataBuffer = ""
		local FunctionArgs = {}
		local DoneProcessingFunctionName = false
		local DoneProcessingArgs = false
		local TokensReturned, BlocksCreated = DECLARE(Source, MainPointer, SharedContext, ExecutableContext, true, true, false, true)
		if #TokensReturned ~= 1 then
			EWI.Error(7, SharedContext, ExecutableContext, "Invalid event statement")
		end
		if not table.find({"Variable"}, TokensReturned[1].Type) then
			EWI.Error(7, SharedContext, ExecutableContext, "Expected variable or object when parsing event condition")
		end
		local EventParentInstance = nil
		local EventName = ""
		local EventToken = TokensReturned[1]
		local IsOutputTuple = false
		local IsServiceEvent = false
		if EventToken.OriginalKey then
			EventName = EventToken.OriginalKey
			EventParentInstance = EventToken.OriginalTableToken.Content
		else
			local PathData = PathTraversal.ParsePathForSet(EventToken.Content) -- {Property=..., Steps={...}}
			EventName = PathData.Property
			EventParentInstance = GetPathToBlocks(table.concat(PathData.Steps, "."), BlocksCreated, false)
		end
		if EventParentInstance == "" or not EventParentInstance then
			IsServiceEvent = true
		end
		--print(`Event '{EventName}' of '{EventParentInstance}' (IsService: {IsServiceEvent})`)
		local EventEntry = Events[EventName]
		if not EventEntry then
			EWI.Error(21, SharedContext,ExecutableContext, `The event '{EventName}' does not exist`)
		end
		if EventEntry.IsService ~= IsServiceEvent then
			EWI.Error(21, SharedContext,ExecutableContext, `The event '{EventName}' expects a different connection context. Did you try connecting to a service event using an instance? Or vice versa?`)
		end
		if EventEntry.Outputs[#EventEntry.Outputs] and EventEntry.Outputs[#EventEntry.Outputs] == "Parameters" then
			IsOutputTuple = true
		end
		MainPointer:Increment(-1)
		while MainPointer.PointingTo < MainPointer.Maximum do
			local Character = MainPointer:GetPointedCharacter(Source)
			if Character == "(" and not DoneProcessingFunctionName then
				DoneProcessingFunctionName = true
				MainPointer:Increment()
				local TokensReturned, BlocksCreatedNew = DECLARE(Source, MainPointer, SharedContext, ExecutableContext, true, true, false, true)
				if #BlocksCreated > 0 and #BlocksCreatedNew > 0 then
					BlocksCreated[#BlocksCreated]:ConnectToBlock(BlocksCreatedNew[1])
				end
				table.move(BlocksCreatedNew, 1, #BlocksCreatedNew, #BlocksCreated + 1, BlocksCreated)
				for _, Token in pairs(TokensReturned) do
					if Token.Type == "Operator" and Token.Content == "," then
						continue
					end
					table.insert(FunctionArgs, Token)
				end
				DoneProcessingArgs = true
				continue
			end
			if Character == "{" and DoneProcessingFunctionName and DoneProcessingArgs then
				-- Call the core to evaluate function
				local CallStack = {ExecutableContext}
				for _, ExtraCalls in pairs(ExecutableContext.InvokedStack) do
					table.insert(CallStack, ExtraCalls)
				end
				local SubExecutableContext = SharedClasses.ExecutableContext(FunctionName, CallStack, true)
				SubExecutableContext.DefinedVariables = ExecutableContext.DefinedVariables
				SubExecutableContext.Flags = ExecutableContext.Flags
				SubExecutableContext.LastLoopData = ExecutableContext.LastLoopData
				SubExecutableContext.LastCreatedBlock = ExecutableContext.LastCreatedBlock
				MainPointer:Increment()
				local FunctionBlocks = Core.powerlang.Parse(Source, SubExecutableContext, MainPointer, "}")
				if EventParentInstance and not IsServiceEvent then 
					table.insert(FunctionArgs, 1, {Content=EventParentInstance, Type="Variable"})
				end
				local InputsOutputs = {}
				for i, arg in pairs(FunctionArgs) do
					local ArgName
					local IsOutput = false
					if i > #EventEntry.Inputs then
						IsOutput = true
						ArgName = EventEntry.Outputs[i - #EventEntry.Inputs]
					else
						ArgName = EventEntry.Inputs[i]
					end
					if i == #EventEntry.Inputs + #EventEntry.Outputs + 1 then
						ArgName = "EventConnection"
						IsOutput = true
					end
					if not ArgName then
						continue
					end
					
					if IsOutput then
						if ArgName == "Parameters" then
							local TupleData = {}
							for index = i, #FunctionArgs do
								local newArg = FunctionArgs[index]
								table.insert(TupleData, VisualLibrary.NewOutput("", newArg.Content))
							end
							table.insert(InputsOutputs, VisualLibrary.NewTuple("Parameters", TupleData, true))
							break
						end
						if typeof(arg.Content) == "table" then
							arg.Content = ""
						end
						
						table.insert(InputsOutputs, VisualLibrary.NewOutput(ArgName, arg.Content))
					else
						if i == 1 and not IsServiceEvent then
							table.insert(InputsOutputs, VisualLibrary.NewInput(ArgName, VisualLibrary.NewIPath(arg.Content)))
						else
							table.insert(InputsOutputs, VisualLibrary.NewInput(ArgName, arg.Content, arg.Type == "Variable"))
						end
					end
				end
				if EventEntry.ForceInputs then
					for fname, fvalue in pairs(EventEntry.ForceInputs) do
						table.insert(InputsOutputs, VisualLibrary.NewInput(fname, fvalue, false))
					end
				end
				local EventBlock = VisualLibrary.NewBlock(EventEntry.TranslatesTo, GenerateUniqueName("Event-"), InputsOutputs)
				if #BlocksCreated > 0 then
					BlocksCreated[#BlocksCreated]:ConnectToBlock(EventBlock)
				end
				if #FunctionBlocks > 0 then
					EventBlock:ConnectToBlock(FunctionBlocks[1])
				end
				table.insert(BlocksCreated, EventBlock)
				table.move(FunctionBlocks, 1, #FunctionBlocks, #BlocksCreated + 1, BlocksCreated)
				return BlocksCreated
			end
			if #DataBuffer == 0 and table.find(SyntaxBasics.Indentation, Character) then
				MainPointer:Increment()
				continue
			end
			if not DoneProcessingFunctionName and not string.find(SyntaxBasics.AllowedCharsInVariables, string.upper(Character), nil, true) then
				EWI.Error(1, SharedContext, ExecutableContext, "Unexpected character: " .. Character)
			end
			DataBuffer = DataBuffer .. Character
			if not MainPointer:Increment() then
				EWI.Error(3, SharedContext, ExecutableContext, "Reached end of file while parsing event statement")
			end
		end
		return BlocksCreated
	end,
	IF=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		local TokensReturned, BlocksCreated = DECLARE(Source, MainPointer, SharedContext, ExecutableContext, true)
		if #TokensReturned ~= 1 then
			EWI.Error(7, SharedContext, ExecutableContext, "Invalid if statement")
		end
		if not table.find({"Variable", "Boolean"}, TokensReturned[1].Type) then
			EWI.Error(7, SharedContext, ExecutableContext, "Expected boolean, variable or equation result when parsing if condition")
		end
		if TokensReturned[1].Type == "Variable" and string.find(TokensReturned[1].Content, ".", nil, true) then
			TokensReturned[1].Content = GetPathToBlocks(TokensReturned[1].Content, BlocksCreated)
		end
		local CallStack = {ExecutableContext}
		for _, ExtraCalls in pairs(ExecutableContext.InvokedStack) do
			table.insert(CallStack, ExtraCalls)
		end
		local SubExecutableContext = SharedClasses.ExecutableContext(ExecutableContext.ScriptName, CallStack, true)
		SubExecutableContext.DefinedVariables = ExecutableContext.DefinedVariables
		SubExecutableContext.Flags = ExecutableContext.Flags
		SubExecutableContext.LastLoopData = ExecutableContext.LastLoopData
		SubExecutableContext.LastCreatedBlock = ExecutableContext.LastCreatedBlock
		MainPointer:Increment()
		local FunctionBlocks = Core.powerlang.Parse(Source, SubExecutableContext, MainPointer, "}")
		local ElseVariable = GenerateUniqueName("ShouldElseRun-")
		local ElseDefinitionTrue = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Else-"), {
			VisualLibrary.NewInput("Value", true),
			VisualLibrary.NewOutput("VariableName", ElseVariable)
		})
		local IfBlock1 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", TokensReturned[1].Content, TokensReturned[1].Type == "Variable"),
			VisualLibrary.NewInput("Value 2", nil, true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.NotEqual)
		})
		local IfBlock2 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", TokensReturned[1].Content, TokensReturned[1].Type == "Variable"),
			VisualLibrary.NewInput("Value 2", false),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.NotEqual)
		})
		IfBlock1:ConnectToBlock(IfBlock2)
		local ElseDefinitionFalse = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Else-"), {
			VisualLibrary.NewInput("Value", false),
			VisualLibrary.NewOutput("VariableName", ElseVariable)
		})
		if #BlocksCreated > 0 then
			BlocksCreated[#BlocksCreated]:ConnectToBlock(ElseDefinitionTrue)
		end
		ElseDefinitionTrue:ConnectToBlock(IfBlock1)
		IfBlock2:ConnectToBlock(ElseDefinitionFalse)
		if #FunctionBlocks > 0 then
			ElseDefinitionFalse:ConnectToBlock(FunctionBlocks[1])
		end
		table.insert(BlocksCreated, ElseDefinitionTrue)
		table.insert(BlocksCreated, IfBlock1)
		table.insert(BlocksCreated, IfBlock2)
		table.insert(BlocksCreated, ElseDefinitionFalse)
		table.move(FunctionBlocks, 1, #FunctionBlocks, #BlocksCreated + 1, BlocksCreated)
		ExecutableContext.LastIfBlock = ElseDefinitionTrue
		return BlocksCreated
	end,
	ELSE=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		local LastIfBlock = ExecutableContext.LastIfBlock
		if not LastIfBlock then
			EWI.Error(18, SharedContext, ExecutableContext, "Cannot use else without if")
			return
		end
		local ElseVariable = LastIfBlock.Outputs[1].OutputVariable
		local BlocksCreated = {}
		local CallStack = {ExecutableContext}
		for _, ExtraCalls in pairs(ExecutableContext.InvokedStack) do
			table.insert(CallStack, ExtraCalls)
		end
		local SubExecutableContext = SharedClasses.ExecutableContext(ExecutableContext.ScriptName, CallStack, true)
		SubExecutableContext.DefinedVariables = ExecutableContext.DefinedVariables
		SubExecutableContext.Flags = ExecutableContext.Flags
		SubExecutableContext.LastLoopData = ExecutableContext.LastLoopData
		SubExecutableContext.LastCreatedBlock = ExecutableContext.LastCreatedBlock
		while true do
			if MainPointer:GetPointedCharacter(Source) == "{" then
				MainPointer:Increment()
				break
			end
			if not MainPointer:Increment() then
				EWI.Error(3, SharedContext, ExecutableContext, "Reached end of file while processing else statement")
			end
		end
		local FunctionBlocks = Core.powerlang.Parse(Source, SubExecutableContext, MainPointer, "}")
		local IfBlock = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", ElseVariable, true),
			VisualLibrary.NewInput("Value 2", true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal)
		})
		local ElseDefinitionFalse = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Else-"), {
			VisualLibrary.NewInput("Value", false),
			VisualLibrary.NewOutput("VariableName", ElseVariable)
		})
		LastIfBlock:ConnectToBlock(IfBlock)
		IfBlock:ConnectToBlock(ElseDefinitionFalse)
		if #FunctionBlocks > 0 then
			ElseDefinitionFalse:ConnectToBlock(FunctionBlocks[1])
		end
		table.insert(BlocksCreated, IfBlock)
		table.insert(BlocksCreated, ElseDefinitionFalse)
		table.move(FunctionBlocks, 1, #FunctionBlocks, #BlocksCreated + 1, BlocksCreated)
		ExecutableContext.LastIfBlock = IfBlock
		return BlocksCreated, true
	end,
	RETURN=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext)
		if #ExecutableContext.InvokedStack == 0 then
			EWI.Error(16, SharedContext, ExecutableContext, "Cannot return in the root function")
		end
		local TokensReturned, BlocksCreated = DECLARE(Source, MainPointer, SharedContext, ExecutableContext, true)
		local TokensReturnedFiltered = {}
		for _, Token in pairs(TokensReturned) do
			-- bad idea cuz user can omit commas
			if Token.Content ~= "," and Token.Type ~= "Operator" then
				local TokenContent = Token.Content
				if Token.Type == "Number" then
					TokenContent = tonumber(Token.Content)
				elseif Token.Type == "Boolean" then
					TokenContent = Token.Content == "true"
				elseif Token.Type == "Variable" and string.find(Token.Content, ".", nil, true) then
					TokenContent = GetPathToBlocks(Token.Content, BlocksCreated)
				end
				table.insert(TokensReturnedFiltered, VisualLibrary.NewInput("", TokenContent, Token.Type == "Variable"))
			end
		end
		ExecutableContext.DefinedVariables[ExecutableContext.ScriptName] = #TokensReturnedFiltered
		
		local ReturnBlock = VisualLibrary.NewBlock("FunctionReturn", GenerateUniqueName("Return-"), {
			VisualLibrary.NewTuple("Returns", TokensReturnedFiltered)
		})
		if #BlocksCreated > 0 then
			BlocksCreated[#BlocksCreated]:ConnectToBlock(ReturnBlock)
		end
		table.insert(BlocksCreated, ReturnBlock)
		return BlocksCreated
	end,
	ADVWHILE=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		--TODO: this is all copied from if
		local TokensReturnedRaw, BlocksCreated = DECLARE(Source, MainPointer, SharedContext, ExecutableContext, true)
		local TokensReturned = {}
		for _, Token in pairs(TokensReturnedRaw) do
			-- bad idea cuz user can omit commas
			if Token.Content ~= "," and Token.Type ~= "Operator" then
				if Token.Type == "Number" then
					Token.Content = tonumber(Token.Content)
				elseif Token.Type == "Boolean" then
					Token.Content = Token.Content == "true"
				elseif Token.Type == "Variable" and string.find(Token.Content, ".", nil, true) then
					Token.Content = GetPathToBlocks(Token.Content, BlocksCreated)
				end
				table.insert(TokensReturned, Token)
			end
		end
		if #TokensReturned ~= 1 then
			EWI.Error(7, SharedContext, ExecutableContext, "Invalid while statement")
		end
		if not table.find({"Variable", "Boolean"}, TokensReturned[1].Type) then
			EWI.Error(7, SharedContext, ExecutableContext, "Expected boolean, variable or equation result when parsing while condition")
		end
		if #BlocksCreated == 0 then
			table.insert(BlocksCreated, VisualLibrary.NewBlock("Comment2", GenerateUniqueName(""), {
				VisualLibrary.NewInput("Comment", ""),
				VisualLibrary.NewInput("Color", BrickColor.new("Institutional white"))
			}))
		end
		local CallStack = {ExecutableContext}
		for _, ExtraCalls in pairs(ExecutableContext.InvokedStack) do
			table.insert(CallStack, ExtraCalls)
		end
		local SubExecutableContext = SharedClasses.ExecutableContext(ExecutableContext.ScriptName, CallStack, true)
		SubExecutableContext.DefinedVariables = ExecutableContext.DefinedVariables
		SubExecutableContext.Flags = ExecutableContext.Flags
		SubExecutableContext.LastLoopData = ExecutableContext.LastLoopData
		SubExecutableContext.LastCreatedBlock = ExecutableContext.LastCreatedBlock
		MainPointer:Increment()
		local FunctionBlocks = Core.powerlang.Parse(Source, SubExecutableContext, MainPointer, "}")
		local WhileBlock = VisualLibrary.NewBlock("If", GenerateUniqueName("Loop-"), {
			VisualLibrary.NewInput("Value 1", TokensReturned[1].Content, TokensReturned[1].Type == "Variable"),
			VisualLibrary.NewInput("Value 2", true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal)
		})
		local StepOut = VisualLibrary.NewBlock("Comment2", GenerateUniqueName(""), {
			VisualLibrary.NewInput("Comment", ""),
			VisualLibrary.NewInput("Color", BrickColor.new("Institutional white"))
		})
		--jump back to re-eval loop
		local ReturnToEvalBlock = VisualLibrary.NewBlock("ExecuteBlock", GenerateUniqueName("Loop-"), {
			VisualLibrary.NewInput("Name", BlocksCreated[1].FriendlyName),
		})
		ExecutableContext.LastLoopData = {ReEvalBlockName=BlocksCreated[1].FriendlyName, StepOutBlockName=StepOut.FriendlyName}
		BlocksCreated[#BlocksCreated]:ConnectToBlock(WhileBlock)
		WhileBlock:ConnectToBlock(FunctionBlocks[1])
		BlocksCreated[#BlocksCreated]:ConnectToBlock(StepOut)
		FunctionBlocks[#FunctionBlocks]:ConnectToBlock(ReturnToEvalBlock)
		table.insert(BlocksCreated, WhileBlock)
		table.insert(BlocksCreated, ReturnToEvalBlock)
		table.move(FunctionBlocks, 1, #FunctionBlocks, #BlocksCreated + 1, BlocksCreated)
		table.insert(BlocksCreated, StepOut)
		return BlocksCreated
	end,
	FOR=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		--this is only for integers/floats, not tables/children
		local TokensReturnedRaw, BlocksCreated = DECLARE(Source, MainPointer, SharedContext, ExecutableContext, true, true)
		local TokensReturned = {}
		for _, Token in pairs(TokensReturnedRaw) do
			-- bad idea cuz user can omit commas
			if not (Token.Content == "," and Token.Type == "Operator") then
				if Token.Type == "Number" then
					Token.Content = tonumber(Token.Content)
				elseif Token.Type == "Boolean" then
					Token.Content = Token.Content == "true"
				elseif Token.Type == "Variable" and string.find(Token.Content, ".", nil, true) then
					Token.Content = GetPathToBlocks(Token.Content, BlocksCreated)
				end
				table.insert(TokensReturned, Token)
			end
		end
		if #TokensReturned < 2 or #TokensReturned > 7 then
			EWI.Error(7, SharedContext, ExecutableContext, "Invalid for loop definition")
		end
		local PlaceVariableName = ""
		local LoopArgs = {}
		local ArgNames = {"Initial", "Maximum", "Increment"}
		local ReachedEquals = false
		for pos, Token in pairs(TokensReturned) do
			if pos == 2 and Token.Content ~= "=" and Token.Type ~= "Operator" then
				EWI.Error(1, SharedContext, ExecutableContext, "Expected = when processing for loop, got " .. Token.Content)
			end
			if not ReachedEquals then
				if Token.Type == "Operator" and Token.Content == "=" then
					if PlaceVariableName == "" then
						EWI.Error(1, SharedContext, ExecutableContext, "= was not expected before variable name")
					end
					ReachedEquals = true
					continue
				end
				if Token.Type ~= "Variable" then
					EWI.Error(7, SharedContext, ExecutableContext, "Only a variable can be assigned as a place variable")
				end
				PlaceVariableName = Token.Content
			else
				if Token.Content == "," and Token.Type == "Separator" then
					continue
				end
				if not table.find({"Number", "Variable"}, Token.Type) then
					EWI.Error(7, SharedContext, ExecutableContext, "Invalid type for loop argument")
				end
				table.insert(LoopArgs, VisualLibrary.NewInput(ArgNames[#LoopArgs + 1], Token.Content, Token.Type == "Variable"))
			end
		end
		if #LoopArgs < 2 then
			EWI.Error(7, SharedContext, ExecutableContext, "Not enough arguments")
		end
		if #LoopArgs == 2 then
			table.insert(LoopArgs, VisualLibrary.NewInput("Increment", 1))
		end
		table.insert(LoopArgs, VisualLibrary.NewOutput("Place", PlaceVariableName))
		local ForLoopBlock = VisualLibrary.NewBlock("ForLoop2", GenerateUniqueName("For-"), LoopArgs)
		local CallStack = {ExecutableContext}
		for _, ExtraCalls in pairs(ExecutableContext.InvokedStack) do
			table.insert(CallStack, ExtraCalls)
		end
		local SubExecutableContext = SharedClasses.ExecutableContext(ExecutableContext.ScriptName, CallStack, true)
		SubExecutableContext.DefinedVariables = ExecutableContext.DefinedVariables
		SubExecutableContext.Flags = ExecutableContext.Flags
		SubExecutableContext.LastLoopData = ExecutableContext.LastLoopData
		SubExecutableContext.LastCreatedBlock = ExecutableContext.LastCreatedBlock
		MainPointer:Increment()
		local FunctionBlocks = Core.powerlang.Parse(Source, SubExecutableContext, MainPointer, "}")
		if #BlocksCreated > 0 then
			BlocksCreated[#BlocksCreated]:ConnectToBlock(ForLoopBlock)
		end
		ForLoopBlock:ConnectToBlock(FunctionBlocks[1])
		table.insert(BlocksCreated, ForLoopBlock)
		table.move(FunctionBlocks, 1, #FunctionBlocks, #BlocksCreated + 1, BlocksCreated)
		return BlocksCreated
	end,
	TABLELOOP=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		--this is only for tables
		local TokensReturnedRaw, BlocksCreated = DECLARE(Source, MainPointer, SharedContext, ExecutableContext, true, true)
		local TokensReturned = {}
		for _, Token in pairs(TokensReturnedRaw) do
			-- bad idea cuz user can omit commas
			if not (Token.Content == "," and Token.Type == "Operator") then
				if Token.Type == "Number" then
					Token.Content = tonumber(Token.Content)
				elseif Token.Type == "Boolean" then
					Token.Content = Token.Content == "true"
				elseif Token.Type == "Variable" and string.find(Token.Content, ".", nil, true) then
					Token.Content = GetPathToBlocks(Token.Content, BlocksCreated)
				end
				table.insert(TokensReturned, Token)
			end
		end
		if #TokensReturned ~= 4 then
			EWI.Error(7, SharedContext, ExecutableContext, "Invalid table loop definition")
		end
		-- TODO
		if TokensReturned[3].Content ~= "in" then
			EWI.Error(7, SharedContext, ExecutableContext, "Invalid table loop definition")
		end
		for _, tkn in pairs(TokensReturned) do
			if tkn.Type ~= "Variable" then
				EWI.Error(7, SharedContext, ExecutableContext, "Invalid table loop definition (malformed loop statement)")
			end
		end
		local LoopArgs = {
			VisualLibrary.NewInput("Table", TokensReturned[4].Content),
			VisualLibrary.NewOutput("Index", TokensReturned[1].Content),
			VisualLibrary.NewOutput("Value", TokensReturned[2].Content),
		}
		local LoopBlock = VisualLibrary.NewBlock("LoopThroughTable", GenerateUniqueName("Loop-"), LoopArgs)
		local CallStack = {ExecutableContext}
		for _, ExtraCalls in pairs(ExecutableContext.InvokedStack) do
			table.insert(CallStack, ExtraCalls)
		end
		local SubExecutableContext = SharedClasses.ExecutableContext(ExecutableContext.ScriptName, CallStack, true)
		SubExecutableContext.DefinedVariables = ExecutableContext.DefinedVariables
		SubExecutableContext.Flags = ExecutableContext.Flags
		SubExecutableContext.LastLoopData = ExecutableContext.LastLoopData
		SubExecutableContext.LastCreatedBlock = ExecutableContext.LastCreatedBlock
		MainPointer:Increment()
		local FunctionBlocks = Core.powerlang.Parse(Source, SubExecutableContext, MainPointer, "}")
		if #BlocksCreated > 0 then
			BlocksCreated[#BlocksCreated]:ConnectToBlock(LoopBlock)
		end
		LoopBlock:ConnectToBlock(FunctionBlocks[1])
		table.insert(BlocksCreated, LoopBlock)
		table.move(FunctionBlocks, 1, #FunctionBlocks, #BlocksCreated + 1, BlocksCreated)
		return BlocksCreated
	end,
	WHILE=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		--TODO: this is all copied from if
		local OldPointingTo = MainPointer.PointingTo
		local TokensReturnedRaw, BlocksCreated = DECLARE(Source, MainPointer, SharedContext, ExecutableContext, true)
		local TokensReturned = {}
		for _, Token in pairs(TokensReturnedRaw) do
			-- bad idea cuz user can omit commas
			if Token.Content ~= "," and Token.Type ~= "Operator" then
				if Token.Type == "Number" then
					Token.Content = tonumber(Token.Content)
				elseif Token.Type == "Boolean" then
					Token.Content = Token.Content == "true"
				elseif Token.Type == "Variable" and string.find(Token.Content, ".", nil, true) then
					Token.Content = GetPathToBlocks(Token.Content, BlocksCreated)
				end
				table.insert(TokensReturned, Token)
			end
		end
		if #TokensReturned ~= 1 then
			EWI.Error(7, SharedContext, ExecutableContext, "Invalid while statement")
		end
		if not table.find({"Variable", "Boolean"}, TokensReturned[1].Type) then
			EWI.Error(7, SharedContext, ExecutableContext, "Expected boolean, variable or equation result when parsing while condition")
		end
		if #BlocksCreated == 0 then
			table.insert(BlocksCreated, VisualLibrary.NewBlock("Comment2", GenerateUniqueName(""), {
				VisualLibrary.NewInput("Comment", ""),
				VisualLibrary.NewInput("Color", BrickColor.new("Really red"))
			}))
		end
		local CallStack = {ExecutableContext}
		for _, ExtraCalls in pairs(ExecutableContext.InvokedStack) do
			table.insert(CallStack, ExtraCalls)
		end
		local SubExecutableContext = SharedClasses.ExecutableContext(ExecutableContext.ScriptName, CallStack, true)
		SubExecutableContext.DefinedVariables = ExecutableContext.DefinedVariables
		SubExecutableContext.Flags = ExecutableContext.Flags
		MainPointer:Increment()
		-- The variable that controls the while loop's condition
		local LoopShouldRunVariable = GenerateUniqueName("LoopShouldRun-")
		-- API for enabling and disabling the loop from a bumped thread
		local DoNotRun1 = VisualLibrary.NewBlock("If", GenerateUniqueName(""), {VisualLibrary.NewInput("Value 1", 0), VisualLibrary.NewInput("Value 2", 1), VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal)})
		local DoNotRun2 = VisualLibrary.NewBlock("If", GenerateUniqueName(""), {VisualLibrary.NewInput("Value 1", 0), VisualLibrary.NewInput("Value 2", 1), VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal)})
		local EnableBlock = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Set-"), {VisualLibrary.NewInput("Value", true), VisualLibrary.NewOutput("VariableName", LoopShouldRunVariable)})
		local DisableBlock = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Set-"), {VisualLibrary.NewInput("Value", false), VisualLibrary.NewOutput("VariableName", LoopShouldRunVariable)})
		DoNotRun1:ConnectToBlock(EnableBlock)
		DoNotRun2:ConnectToBlock(DisableBlock)
		BlocksCreated[#BlocksCreated]:ConnectToBlock(DoNotRun1)
		BlocksCreated[#BlocksCreated]:ConnectToBlock(DoNotRun2)
		
		-- Initial state of the loop
		local InitialStateBlock = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Set-"), {VisualLibrary.NewInput("Value", TokensReturned[1].Content, TokensReturned[1].Type == "Variable"), VisualLibrary.NewOutput("VariableName", LoopShouldRunVariable)})
		BlocksCreated[#BlocksCreated]:ConnectToBlock(InitialStateBlock)
		
		-- The actual loop block
		local WhileBlock = VisualLibrary.NewBlock("WhileLoop3", GenerateUniqueName("Loop-"), {
			VisualLibrary.NewInput("Value 1", LoopShouldRunVariable, true),
			VisualLibrary.NewInput("Value 2", true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal)
		})
		InitialStateBlock:ConnectToBlock(WhileBlock)
		
		-- Contents of the loop
		local ContinueBlockName = GenerateUniqueName("Continue-")
		ExecutableContext.LastLoopData = {ReEvalBlockName="<Real While>", StepOutBlockName="<Real While>", ["ContinueBlockName"] = ContinueBlockName}
		SubExecutableContext.LastLoopData = ExecutableContext.LastLoopData
		SubExecutableContext.LastCreatedBlock = ExecutableContext.LastCreatedBlock
		local FunctionBlocks = Core.powerlang.Parse(Source, SubExecutableContext, MainPointer, "}")
		WhileBlock:ConnectToBlock(FunctionBlocks[1])
		
		-- Re-evaluate the loop variable
		
		--TODO: plz fix this must create a copy of the blocks used to evaluate loop state
		local BlocksCreatedCopy = {}
		local MapTable = {}
		for _, OldBlock in pairs(BlocksCreated) do
			local NewBlock = VisualLibrary.NewBlock(OldBlock.BlockID, GenerateUniqueName(""), {})
			NewBlock.Inputs = OldBlock.Inputs
			NewBlock.Outputs = OldBlock.Outputs
			MapTable[OldBlock.FriendlyName] = NewBlock.FriendlyName
			table.insert(BlocksCreatedCopy, NewBlock)
		end
		for pos, NewBlock in pairs(BlocksCreatedCopy) do
			local OldBlockConnection = BlocksCreated[pos].ConnectedChildren
			for _, child in pairs(OldBlockConnection) do
				if MapTable[child] then
					NewBlock:ConnectToFriendlyName(MapTable[child])
				end
			end
		end
		BlocksCreatedCopy[1].FriendlyName = ContinueBlockName
		FunctionBlocks[1]:ConnectToBlock(BlocksCreatedCopy[1])
		
		-- Choose whether to re-enable it or not
		local If1 = VisualLibrary.NewBlock("If", GenerateUniqueName(""), {
			VisualLibrary.NewInput("Value 1", TokensReturned[1].Content, TokensReturned[1].Type == "Variable"),
			VisualLibrary.NewInput("Value 2", true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal)
		})
		local JmpEnableBlock = VisualLibrary.NewBlock("ExecuteBlock", GenerateUniqueName("Loop-"), {
			VisualLibrary.NewInput("Name", EnableBlock.FriendlyName),
		})
		local If2 = VisualLibrary.NewBlock("If", GenerateUniqueName(""), {
			VisualLibrary.NewInput("Value 1", TokensReturned[1].Content, TokensReturned[1].Type == "Variable"),
			VisualLibrary.NewInput("Value 2", false),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal)
		})
		local JmpDisableBlock = VisualLibrary.NewBlock("ExecuteBlock", GenerateUniqueName("Loop-"), {
			VisualLibrary.NewInput("Name", DisableBlock.FriendlyName),
		})
		If1:ConnectToBlock(JmpEnableBlock)
		If2:ConnectToBlock(JmpDisableBlock)
		BlocksCreatedCopy[#BlocksCreatedCopy]:ConnectToBlock(If1)
		BlocksCreatedCopy[#BlocksCreatedCopy]:ConnectToBlock(If2)
		
		ExecutableContext.LastLoopData = {ReEvalBlockName="<Real While>", StepOutBlockName="<Real While>", ContinueBlockName = BlocksCreatedCopy[1].FriendlyName}
		
		table.insert(BlocksCreated, DoNotRun1)
		table.insert(BlocksCreated, DoNotRun2)
		table.insert(BlocksCreated, EnableBlock)
		table.insert(BlocksCreated, DisableBlock)
		table.insert(BlocksCreated, InitialStateBlock)
		table.insert(BlocksCreated, WhileBlock)
		table.move(FunctionBlocks, 1, #FunctionBlocks, #BlocksCreated + 1, BlocksCreated)
		table.insert(BlocksCreated, If1)
		table.insert(BlocksCreated, JmpEnableBlock)
		table.insert(BlocksCreated, If2)
		table.insert(BlocksCreated, JmpDisableBlock)
		table.move(BlocksCreatedCopy, 1, #BlocksCreatedCopy, #BlocksCreated + 1, BlocksCreated)
		
		return BlocksCreated
	end,
	BREAK=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		if not ExecutableContext.LastCreatedBlock then
			EWI.Error(7, SharedContext, ExecutableContext, "Unable to connect this break")
			return
		end
		local BreakBlock = VisualLibrary.NewBlock("BreakLoop", GenerateUniqueName("Break-"), {})
		ExecutableContext.LastCreatedBlock:ConnectToBlock(BreakBlock)
		return {BreakBlock}, true
	end,
	CONTINUE=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		if not ExecutableContext.LastCreatedBlock then
			EWI.Error(7, SharedContext, ExecutableContext, "Unable to connect this continue")
			return
		end
		--  1am fix
		--if not ExecutableContext.LastLoopData or not ExecutableContext.LastLoopData.ContinueBlockName then
		--	EWI.Error(7, SharedContext, ExecutableContext, "Continue must be placed in a loop")
		--	return
		--end
		if ExecutableContext.LastLoopData and ExecutableContext.LastLoopData.ContinueBlockName then
			local JumpToReeval = VisualLibrary.NewBlock("ExecuteBlock", GenerateUniqueName("Continue-"), {VisualLibrary.NewInput("Name", ExecutableContext.LastLoopData.ContinueBlockName)})
			ExecutableContext.LastCreatedBlock:ConnectToBlock(JumpToReeval)
			local ContinueBlock = VisualLibrary.NewBlock("ContinueLoop", GenerateUniqueName("Continue-"), {})
			JumpToReeval:ConnectToBlock(ContinueBlock)
			return {JumpToReeval, ContinueBlock}, true
		end
		local ContinueBlock = VisualLibrary.NewBlock("ContinueLoop", GenerateUniqueName("Continue-"), {})
		ExecutableContext.LastCreatedBlock:ConnectToBlock(ContinueBlock)
		return {ContinueBlock}, true
	end,
	THREAD=function(Source:string, MainPointer:SharedClasses.Pointer, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext, Core)
		local TokensReturned, BlocksCreated = DECLARE(Source, MainPointer, SharedContext, ExecutableContext, true)
		if #BlocksCreated > 0 then
			EWI.Error(7, SharedContext, ExecutableContext, "Invalid thread statement")
		end
		local CallStack = ExecutableContext.InvokedStack
		if #CallStack > 0 or ExecutableContext.IsSubBlock then
			EWI.Warn(23, SharedContext, ExecutableContext, "The thread directive will always run, regardless of the nesting. If you want to run a separate thread under a condition, use events instead")
		end
		local SubExecutableContext = SharedClasses.ExecutableContext(ExecutableContext.ScriptName, CallStack, true)
		SubExecutableContext.DefinedVariables = ExecutableContext.DefinedVariables
		SubExecutableContext.Flags = ExecutableContext.Flags
		SubExecutableContext.LastLoopData = ExecutableContext.LastLoopData
		SubExecutableContext.LastCreatedBlock = ExecutableContext.LastCreatedBlock
		MainPointer:Increment()
		local FunctionBlocks = Core.powerlang.Parse(Source, SubExecutableContext, MainPointer, "}")
		return FunctionBlocks, true
	end,
	DECLARE=DECLARE
}

return module
