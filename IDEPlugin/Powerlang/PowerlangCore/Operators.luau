local SharedClasses = require(script.Parent.SharedClasses)
local SyntaxBasics = require(script.Parent.SyntaxBasics)
local EWI = require(script.Parent.ErrorsWarnsInfos)
local PathTraversal = require(script.Parent.PathTraversal)
local VisualLibrary = require(script.Parent.VisualLibrary.Version2)
local OperatorTranslatorTable = {
	["+"]="Addition",
	["-"]="Subtraction",
	["*"]="Multiplication",
	["/"]="Division",
	["%"]="Modulus",
	["^"]="Exponentiation",
}

local UniqueIDService = require(script.Parent.UniqueIDService)

function GenerateUniqueName(prefix:string?)
	return UniqueIDService:GenerateUniqueName(prefix)
end

function GetPathToBlocks(StringPath, BlocksCreated)
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
	return LastStep
end

function SetPathToBlocks(StringPath, BlocksCreated)
	local Path = PathTraversal.ParsePathForSet(StringPath)
	local LastStep = Path.Steps[1]
	for i, Step in pairs(Path.Steps) do
		if i == 1 then
			continue
		end
		local OutputVariable = GenerateUniqueName("TraversalOut-")
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
	return LastStep, Path
end

function BasicArithmetic(Tokens:{any}, OwnTokenPosition:number, StoreResultIn:string, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext)
	--TODO: make it create blocks

	local SelfChar = Tokens[OwnTokenPosition].Content
	local PrevToken = Tokens[OwnTokenPosition - 1]
	local NextToken = Tokens[OwnTokenPosition + 1]
	if not PrevToken or not NextToken then
		--print(Tokens)
		EWI.Error(8, SharedContext, ExecutableContext, "A glitch happened while compiling your code. This is not your fault. Please contact the developers.")
	end
	local PrevTokenType = PrevToken.Type
	local NextTokenType = NextToken.Type
	--print(`Operation: {PrevToken.Content} {SelfChar} {NextToken.Content} -> {StoreResultIn}`)
	if not table.find({"Variable", "Number"}, PrevTokenType) or not table.find({"Variable", "Number"}, NextTokenType) then
		EWI.Error(7, SharedContext, ExecutableContext, `Cannot {SelfChar} {PrevTokenType} and {NextTokenType}`)
	end
	local BlocksCreated = {}
	local NextTokenContent = NextToken.Content
	local PrevTokenContent = PrevToken.Content
	if NextToken.Type == "Variable" and string.find(NextTokenContent, ".", nil, true) then
		NextTokenContent = GetPathToBlocks(NextToken.Content, BlocksCreated)
	elseif NextToken.Type == "Number" then
		NextTokenContent = tonumber(NextToken.Content)
	end
	if PrevToken.Type == "Variable" and string.find(PrevTokenContent, ".", nil, true) then
		PrevTokenContent = GetPathToBlocks(PrevToken.Content, BlocksCreated)
	elseif PrevToken.Type == "Number" then
		PrevTokenContent = tonumber(PrevToken.Content)	
	end
	
	table.insert(BlocksCreated, VisualLibrary.NewBlock(
		OperatorTranslatorTable[SelfChar], 
		GenerateUniqueName("Operator-"),
		{
			VisualLibrary.NewInput("Number1", PrevTokenContent, PrevTokenType == "Variable"),
			VisualLibrary.NewInput("Number2", NextTokenContent, NextTokenType == "Variable"),
			VisualLibrary.NewOutput("Result", StoreResultIn)
		}
		)
	)
	
	if #BlocksCreated > 1 then
		BlocksCreated[#BlocksCreated - 1]:ConnectToBlock(BlocksCreated[#BlocksCreated])
	end
	
	for _ = 1,3 do
		table.remove(Tokens, OwnTokenPosition - 1)
	end
	table.insert(Tokens, OwnTokenPosition - 1, {Content=StoreResultIn, Type="Variable"})
	return BlocksCreated
end

function Comparison(Tokens:{any}, OwnTokenPosition:number, StoreResultIn:string, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext)
	local SelfChar = Tokens[OwnTokenPosition].Content
	local PrevToken = Tokens[OwnTokenPosition - 1]
	local NextToken = Tokens[OwnTokenPosition + 1]
	if not PrevToken or not NextToken then
		EWI.Error(8, SharedContext, ExecutableContext, "A glitch happened while compiling your code. This is not your fault. Please contact the developers.")
	end
	local BlocksCreated = {}
	local PrevTokenType = PrevToken.Type
	local NextTokenType = NextToken.Type
	local PrevTokenContent = PrevToken.Content
	local NextTokenContent = NextToken.Content
	if PrevTokenType == "Number" then
		PrevTokenContent = tonumber(PrevToken.Content)
	elseif PrevTokenType == "Boolean" then
		PrevTokenContent = PrevToken.Content == "true"
	elseif PrevTokenType == "Variable" and string.find(PrevToken.Content, ".", nil, true) then
		PrevTokenContent = GetPathToBlocks(PrevToken.Content, BlocksCreated)
	end
	if NextTokenType == "Number" then
		NextTokenContent = tonumber(NextToken.Content)
	elseif NextTokenType == "Boolean" then
		NextTokenContent = NextToken.Content == "true"
	elseif NextTokenType == "Variable" and string.find(NextToken.Content, ".", nil, true) then
		NextTokenContent = GetPathToBlocks(NextToken.Content, BlocksCreated)
	end
	--print(`Operation: {PrevToken.Content} {SelfChar} {NextToken.Content} -> {StoreResultIn}`)
	local SetVariableBlock = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Comparison-"), {
		VisualLibrary.NewInput("Value", false),
		VisualLibrary.NewOutput("VariableName", StoreResultIn)
	})
	local IfBlock = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
		VisualLibrary.NewInput("Value 1", PrevTokenContent, PrevTokenType == "Variable"),
		VisualLibrary.NewInput("Value 2", NextTokenContent, NextTokenType == "Variable"),
		VisualLibrary.NewInput("ComparisonType", VisualLibrary.NewChoice(SelfChar))
	})
	local SetVariableBlock2 = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Comparison-"), {
		VisualLibrary.NewInput("Value", true),
		VisualLibrary.NewOutput("VariableName", StoreResultIn)
	})
	local StepOutBlock = VisualLibrary.NewBlock("Comment2", GenerateUniqueName(""), {
		VisualLibrary.NewInput("Comment", ""),
		VisualLibrary.NewInput("Color", BrickColor.new(1))
	})
	if #BlocksCreated > 0 then
		BlocksCreated[#BlocksCreated]:ConnectToBlock(SetVariableBlock)
	end
	SetVariableBlock:ConnectToBlock(IfBlock)
	IfBlock:ConnectToBlock(SetVariableBlock2)
	SetVariableBlock:ConnectToBlock(StepOutBlock)
	table.insert(BlocksCreated, SetVariableBlock)
	table.insert(BlocksCreated, IfBlock)
	table.insert(BlocksCreated, SetVariableBlock2)
	table.insert(BlocksCreated, StepOutBlock)
	
	
	for _ = 1,3 do
		table.remove(Tokens, OwnTokenPosition - 1)
	end
	table.insert(Tokens, OwnTokenPosition - 1, {Content=StoreResultIn, Type="Variable"})
	return BlocksCreated
end

function LogicGate(Tokens:{any}, OwnTokenPosition:number, StoreResultIn:string, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext)
	--TODO: make it create blocks

	local SelfChar = Tokens[OwnTokenPosition].Content
	local PrevToken = Tokens[OwnTokenPosition - 1]
	local NextToken = Tokens[OwnTokenPosition + 1]
	if not PrevToken or not NextToken then
		EWI.Error(8, SharedContext, ExecutableContext, "A glitch happened while compiling your code. This is not your fault. Please contact the developers.")
	end
	local PrevTokenType = PrevToken.Type
	local NextTokenType = NextToken.Type
	--print(`Operation: {PrevToken.Content} {SelfChar} {NextToken.Content} -> {StoreResultIn}`)
	--if not table.find({"Variable", "Boolean"}, PrevTokenType) or not table.find({"Variable", "Boolean"}, NextTokenType) then
	--	EWI.Error(7, SharedContext, ExecutableContext, `Cannot {SelfChar} {PrevTokenType} and {NextTokenType}`)
	--end
	local PrevTokenContent = PrevToken.Content
	local NextTokenContent = NextToken.Content
	local BlocksCreated = {}
	if PrevTokenType == "Boolean" then
		PrevTokenContent = PrevToken.Content == "true"
	elseif PrevTokenType == "Variable" and string.find(PrevTokenContent, ".", nil, true) then
		PrevTokenContent = GetPathToBlocks(PrevToken.Content, BlocksCreated)
	end
	if NextTokenType == "Boolean" then
		NextTokenContent = NextToken.Content == "true"
	elseif NextTokenType == "Variable" and string.find(NextToken.Content, ".", nil, true) then
		NextTokenContent = GetPathToBlocks(NextToken.Content, BlocksCreated)
	end
	
	local ToBoolFirstVariableName = GenerateUniqueName("Generic-")
	local ToBoolSecondVariableName = GenerateUniqueName("Generic-")
	local FirstConvertedToBooleanBlock = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Gate-"), {
		VisualLibrary.NewInput("Value", false),
		VisualLibrary.NewOutput("VariableName", ToBoolFirstVariableName)
	})
	local SecondConvertedToBooleanBlock = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Gate-"), {
		VisualLibrary.NewInput("Value", false),
		VisualLibrary.NewOutput("VariableName", ToBoolSecondVariableName)
	})
	if #BlocksCreated > 0 then
		BlocksCreated[#BlocksCreated]:ConnectToBlock(FirstConvertedToBooleanBlock)
	end
	FirstConvertedToBooleanBlock:ConnectToBlock(SecondConvertedToBooleanBlock)
	
	local FirstConversionPair1 = VisualLibrary.NewBlock("If", GenerateUniqueName("Gate-"), {
		VisualLibrary.NewInput("Value 1", PrevTokenContent, PrevTokenType == "Variable"),
		VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.NotEqual),
		VisualLibrary.NewInput("Value 2", nil)
	})
	local FirstConversionPair2 = VisualLibrary.NewBlock("If", GenerateUniqueName("Gate-"), {
		VisualLibrary.NewInput("Value 1", PrevTokenContent, PrevTokenType == "Variable"),
		VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.NotEqual),
		VisualLibrary.NewInput("Value 2", false)
	})
	local FirstResult = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Gate-"), {
		VisualLibrary.NewInput("Value", true),
		VisualLibrary.NewOutput("VariableName", ToBoolFirstVariableName)
	})
	SecondConvertedToBooleanBlock:ConnectToBlock(FirstConversionPair1)
	FirstConversionPair1:ConnectToBlock(FirstConversionPair2)
	FirstConversionPair2:ConnectToBlock(FirstResult)
	
	
	local SecondConversionPair1 = VisualLibrary.NewBlock("If", GenerateUniqueName("Gate-"), {
		VisualLibrary.NewInput("Value 1", NextTokenContent, NextTokenType == "Variable"),
		VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.NotEqual),
		VisualLibrary.NewInput("Value 2", nil)
	})
	local SecondConversionPair2 = VisualLibrary.NewBlock("If", GenerateUniqueName("Gate-"), {
		VisualLibrary.NewInput("Value 1", NextTokenContent, NextTokenType == "Variable"),
		VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.NotEqual),
		VisualLibrary.NewInput("Value 2", false)
	})
	local SecondResult = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Gate-"), {
		VisualLibrary.NewInput("Value", true),
		VisualLibrary.NewOutput("VariableName", ToBoolSecondVariableName)
	})
	SecondConvertedToBooleanBlock:ConnectToBlock(SecondConversionPair1)
	SecondConversionPair1:ConnectToBlock(SecondConversionPair2)
	SecondConversionPair2:ConnectToBlock(SecondResult)
	
	local LogicBlock = VisualLibrary.NewBlock(string.upper(SelfChar), GenerateUniqueName("Gate-"), {
		VisualLibrary.NewInput("A", ToBoolFirstVariableName, true),
		VisualLibrary.NewInput("B", ToBoolSecondVariableName, true),
		VisualLibrary.NewOutput("Result", StoreResultIn)
	})
	SecondConvertedToBooleanBlock:ConnectToBlock(LogicBlock)
	
	table.insert(BlocksCreated, FirstConvertedToBooleanBlock)
	table.insert(BlocksCreated, SecondConvertedToBooleanBlock)
	table.insert(BlocksCreated, FirstConversionPair1)
	table.insert(BlocksCreated, FirstConversionPair2)
	table.insert(BlocksCreated, FirstResult)
	table.insert(BlocksCreated, SecondConversionPair1)
	table.insert(BlocksCreated, SecondConversionPair2)
	table.insert(BlocksCreated, SecondResult)
	table.insert(BlocksCreated, LogicBlock)
	for _ = 1,3 do
		table.remove(Tokens, OwnTokenPosition - 1)
	end
	table.insert(Tokens, OwnTokenPosition - 1, {Content=StoreResultIn, Type="Variable"})
	return BlocksCreated
end

local operators = {
	["+"]=BasicArithmetic,
	["-"]=BasicArithmetic,
	["*"]=BasicArithmetic,
	["/"]=BasicArithmetic,
	["^"]=BasicArithmetic,
	["%"]=BasicArithmetic,
	[".."]=function(Tokens:{any}, OwnTokenPosition:number, StoreResultIn:string, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext)
		--TODO: make it create blocks

		local SelfChar = Tokens[OwnTokenPosition].Content
		local PrevToken = Tokens[OwnTokenPosition - 1]
		local NextToken = Tokens[OwnTokenPosition + 1]
		if not PrevToken or not NextToken then
			EWI.Error(8, SharedContext, ExecutableContext, "A glitch happened while compiling your code. This is not your fault. Please contact the developers.")
		end
		local BlocksCreated = {}
		local PrevTokenType = PrevToken.Type
		local NextTokenType = NextToken.Type
		--print(`Operation: {PrevToken.Content} {SelfChar} {NextToken.Content} -> {StoreResultIn}`)
		if not table.find({"Variable", "String", "Number"}, PrevTokenType) or not table.find({"Variable", "String", "Number"}, NextTokenType) then
			EWI.Error(7, SharedContext, ExecutableContext, `Cannot {SelfChar} {PrevTokenType} and {NextTokenType}`)
		end
		if PrevTokenType == "Variable" and string.find(PrevToken.Content, ".", nil, true) then
			PrevToken.Content = GetPathToBlocks(PrevToken.Content, BlocksCreated)
		end
		if NextTokenType == "Variable" and string.find(NextToken.Content, ".", nil, true) then
			NextToken.Content = GetPathToBlocks(NextToken.Content, BlocksCreated)
		end
		
		local TypeOfOutputFirst = GenerateUniqueName("TypeOfOutput-")
		local TypeOfOutputSecond = GenerateUniqueName("TypeOfOutput-")
		local TypeOfBlockFirst = VisualLibrary.NewBlock("TypeOf", GenerateUniqueName("TypeOf-"), {
			VisualLibrary.NewInput("Variable", PrevToken.Content, PrevToken.Type == "Variable"),
			VisualLibrary.NewOutput("Type", TypeOfOutputFirst)
		})
		local TypeOfBlockSecond = VisualLibrary.NewBlock("TypeOf", GenerateUniqueName("TypeOf-"), {
			VisualLibrary.NewInput("Variable", NextToken.Content, NextToken.Type == "Variable"),
			VisualLibrary.NewOutput("Type", TypeOfOutputSecond)
		})
		
		if #BlocksCreated > 1 then
			BlocksCreated[#BlocksCreated]:ConnectToBlock(TypeOfBlockFirst)
		end
		TypeOfBlockFirst:ConnectToBlock(TypeOfBlockSecond)
		
		local IfPairStringString1 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", TypeOfOutputFirst, true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal),
			VisualLibrary.NewInput("Value 2", "string")
		})
		local IfPairStringString2 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", TypeOfOutputSecond, true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal),
			VisualLibrary.NewInput("Value 2", "string")
		})
		TypeOfBlockSecond:ConnectToBlock(IfPairStringString1)
		IfPairStringString1:ConnectToBlock(IfPairStringString2)
		
		local IfPairStringNumber1 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", TypeOfOutputFirst, true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal),
			VisualLibrary.NewInput("Value 2", "string")
		})
		local IfPairStringNumber2 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", TypeOfOutputSecond, true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal),
			VisualLibrary.NewInput("Value 2", "number")
		})
		TypeOfBlockSecond:ConnectToBlock(IfPairStringNumber1)
		IfPairStringNumber1:ConnectToBlock(IfPairStringNumber2)
		
		local IfPairNumberString1 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", TypeOfOutputFirst, true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal),
			VisualLibrary.NewInput("Value 2", "number")
		})
		local IfPairNumberString2 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", TypeOfOutputSecond, true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal),
			VisualLibrary.NewInput("Value 2", "string")
		})
		TypeOfBlockSecond:ConnectToBlock(IfPairNumberString1)
		IfPairNumberString1:ConnectToBlock(IfPairNumberString2)
		
		local ConcatenateStringString = VisualLibrary.NewBlock("Concatenate", GenerateUniqueName("Operator-"),
		{
			VisualLibrary.NewInput("FirstString", PrevToken.Content, PrevTokenType == "Variable"),
			VisualLibrary.NewInput("SecondString", NextToken.Content, NextTokenType == "Variable"),
			VisualLibrary.NewOutput("Result", StoreResultIn)
		})
		IfPairStringString2:ConnectToBlock(ConcatenateStringString)
		
		local ConcatenateStringNumber = VisualLibrary.NewBlock("CombineStringWithNumber", GenerateUniqueName("Operator-"),
			{
				VisualLibrary.NewInput("String", PrevToken.Content, PrevTokenType == "Variable"),
				VisualLibrary.NewInput("Number", NextToken.Content, NextTokenType == "Variable"),
				VisualLibrary.NewOutput("Combined", StoreResultIn)
			})
		IfPairStringNumber2:ConnectToBlock(ConcatenateStringNumber)
		
		local ConcatenateNumberString = VisualLibrary.NewBlock("CombineNumberWithString", GenerateUniqueName("Operator-"),
			{
				VisualLibrary.NewInput("Number", PrevToken.Content, PrevTokenType == "Variable"),
				VisualLibrary.NewInput("String", NextToken.Content, NextTokenType == "Variable"),
				VisualLibrary.NewOutput("Combined", StoreResultIn)
			})
		IfPairNumberString2:ConnectToBlock(ConcatenateNumberString)
		local Nothing = VisualLibrary.NewBlock("Comment2", GenerateUniqueName(""),
			{
				VisualLibrary.NewInput("Comment", ""),
				VisualLibrary.NewInput("Color", BrickColor.new("Institutional white"))
			}
		)
		TypeOfBlockSecond:ConnectToBlock(Nothing)
		
		table.insert(BlocksCreated, TypeOfBlockFirst)
		table.insert(BlocksCreated, TypeOfBlockSecond)
		table.insert(BlocksCreated, IfPairStringString1)
		table.insert(BlocksCreated, IfPairStringString2)
		table.insert(BlocksCreated, IfPairStringNumber1)
		table.insert(BlocksCreated, IfPairStringNumber2)
		table.insert(BlocksCreated, IfPairNumberString1)
		table.insert(BlocksCreated, IfPairNumberString2)
		table.insert(BlocksCreated, ConcatenateStringString)
		table.insert(BlocksCreated, ConcatenateStringNumber)
		table.insert(BlocksCreated, ConcatenateNumberString)
		table.insert(BlocksCreated, Nothing)
		
		for _ = 1,3 do
			table.remove(Tokens, OwnTokenPosition - 1)
		end
		table.insert(Tokens, OwnTokenPosition - 1, {Content=StoreResultIn, Type="Variable"})
		return BlocksCreated
	end,
	["=="]=Comparison,
	["~="]=Comparison,
	[">"]=Comparison,
	["<"]=Comparison,
	[">="]=Comparison,
	["<="]=Comparison,
	
	["and"]=LogicGate,
	["or"]=LogicGate,
	["not"]=function(Tokens:{any}, OwnTokenPosition:number, StoreResultIn:string, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext)

		local SelfChar = Tokens[OwnTokenPosition].Content
		local NextToken = Tokens[OwnTokenPosition + 1]
		if not NextToken then
			EWI.Error(8, SharedContext, ExecutableContext, "A glitch happened while compiling your code. This is not your fault. Please contact the developers.")
		end
		local NextTokenType = NextToken.Type
		--print(`Operation: {SelfChar} {NextToken.Content} -> {StoreResultIn}`)
		--if not table.find({"Variable", "Boolean"}, NextTokenType) then
		--	EWI.Error(7, SharedContext, ExecutableContext, `Cannot {SelfChar} {NextTokenType}`)
		--end
		local BlocksCreated = {}

		local NextTokenContent = NextToken.Content
		if NextTokenType == "Boolean" then
			NextTokenContent = NextToken.Content == "true"
		elseif NextTokenType == "Variable" and string.find(NextToken.Content, ".", nil, true) then
			NextTokenContent = GetPathToBlocks(NextToken.Content, BlocksCreated)
		end
		local ToBoolFirstVariableName = GenerateUniqueName("Generic-")
		local FirstConvertedToBooleanBlock = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Gate-"), {
			VisualLibrary.NewInput("Value", false),
			VisualLibrary.NewOutput("VariableName", ToBoolFirstVariableName)
		})

		if #BlocksCreated > 0 then
			BlocksCreated[#BlocksCreated]:ConnectToBlock(FirstConvertedToBooleanBlock)
		end

		local FirstConversionPair1 = VisualLibrary.NewBlock("If", GenerateUniqueName("Gate-"), {
			VisualLibrary.NewInput("Value 1", NextTokenContent, NextTokenType == "Variable"),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.NotEqual),
			VisualLibrary.NewInput("Value 2", nil)
		})
		local FirstConversionPair2 = VisualLibrary.NewBlock("If", GenerateUniqueName("Gate-"), {
			VisualLibrary.NewInput("Value 1", NextTokenContent, NextTokenType == "Variable"),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.NotEqual),
			VisualLibrary.NewInput("Value 2", false)
		})
		local FirstResult = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("Gate-"), {
			VisualLibrary.NewInput("Value", true),
			VisualLibrary.NewOutput("VariableName", ToBoolFirstVariableName)
		})
		FirstConvertedToBooleanBlock:ConnectToBlock(FirstConversionPair1)
		FirstConversionPair1:ConnectToBlock(FirstConversionPair2)
		FirstConversionPair2:ConnectToBlock(FirstResult)

		
		local LogicBlock = VisualLibrary.NewBlock(string.upper(SelfChar), GenerateUniqueName("Gate-"), {
			VisualLibrary.NewInput("A", ToBoolFirstVariableName, true),
			VisualLibrary.NewOutput("Result", StoreResultIn)
		})
		FirstConvertedToBooleanBlock:ConnectToBlock(LogicBlock)
		table.insert(BlocksCreated, FirstConvertedToBooleanBlock)
		table.insert(BlocksCreated, FirstConversionPair1)
		table.insert(BlocksCreated, FirstConversionPair2)
		table.insert(BlocksCreated, FirstResult)
		table.insert(BlocksCreated, LogicBlock)
		
		for _ = 1,2 do
			table.remove(Tokens, OwnTokenPosition)
		end
		table.insert(Tokens, OwnTokenPosition, {Content=StoreResultIn, Type="Variable"})
		return BlocksCreated
	end,
	["#"]=function(Tokens:{any}, OwnTokenPosition:number, StoreResultIn:string, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext)

		local SelfChar = Tokens[OwnTokenPosition].Content
		local NextToken = Tokens[OwnTokenPosition + 1]
		if not NextToken then
			EWI.Error(8, SharedContext, ExecutableContext, "A glitch happened while compiling your code. This is not your fault. Please contact the developers.")
		end
		local NextTokenType = NextToken.Type
		--print(`Operation: {SelfChar} {NextToken.Content} -> {StoreResultIn}`)
		if not table.find({"Variable", "String"}, NextTokenType) then
			EWI.Error(7, SharedContext, ExecutableContext, `Cannot {SelfChar} {NextTokenType}`)
		end
		local BlocksCreated = {}
		local NextTokenContent = NextToken.Content
		if NextTokenType == "Boolean" then
			NextTokenContent = NextToken.Content == "true"
		elseif NextTokenType == "Variable" and string.find(NextToken.Content, ".", nil, true) then
			NextTokenContent = GetPathToBlocks(NextToken.Content, BlocksCreated)
		end
		
		local TypeOfOutput = GenerateUniqueName("TypeOfOutput-")
		local TypeOfBlock = VisualLibrary.NewBlock("TypeOf", GenerateUniqueName("TypeOf-"), {
			VisualLibrary.NewInput("Variable", NextTokenContent, NextToken.Type == "Variable"),
			VisualLibrary.NewOutput("Type", TypeOfOutput)
		})
		if #BlocksCreated > 0 then
			BlocksCreated[#BlocksCreated]:ConnectToBlock(TypeOfBlock)
		end
		local IfBlock1 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", TypeOfOutput, true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal),
			VisualLibrary.NewInput("Value 2", "table")
		})
		local IfBlock2 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
			VisualLibrary.NewInput("Value 1", TypeOfOutput, true),
			VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal),
			VisualLibrary.NewInput("Value 2", "string")
		})
		TypeOfBlock:ConnectToBlock(IfBlock1)
		TypeOfBlock:ConnectToBlock(IfBlock2)
		local SetBlock = VisualLibrary.NewBlock("GetLength", GenerateUniqueName("Len-"), {
			VisualLibrary.NewInput("String", NextTokenContent, NextToken.Type == "Variable"),
			VisualLibrary.NewOutput("Length", StoreResultIn)
		})
		local SetInstanceBlock = VisualLibrary.NewBlock("GetTableLength", GenerateUniqueName("Len-"), {
			VisualLibrary.NewInput("Table", NextTokenContent),
			VisualLibrary.NewOutput("Length", StoreResultIn)
		})
		local Nothing = VisualLibrary.NewBlock("Comment2", GenerateUniqueName(""),
			{
				VisualLibrary.NewInput("Comment", ""),
				VisualLibrary.NewInput("Color", BrickColor.new("Institutional white"))
			}
		)
		IfBlock1:ConnectToBlock(SetInstanceBlock)
		IfBlock2:ConnectToBlock(SetBlock)
		TypeOfBlock:ConnectToBlock(Nothing)

		table.insert(BlocksCreated, TypeOfBlock)
		table.insert(BlocksCreated, IfBlock1)
		table.insert(BlocksCreated, IfBlock2)
		table.insert(BlocksCreated, SetBlock)
		table.insert(BlocksCreated, SetInstanceBlock)
		table.insert(BlocksCreated, Nothing)
		
		for _ = 1,2 do
			table.remove(Tokens, OwnTokenPosition)
		end
		table.insert(Tokens, OwnTokenPosition, {Content=StoreResultIn, Type="Variable"})
		return BlocksCreated
	end,
	["."]=function(Tokens:{any}, OwnTokenPosition:number, StoreResultIn:string, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext)
		local SelfChar = Tokens[OwnTokenPosition].Content
		local PrevToken = Tokens[OwnTokenPosition - 1]
		local NextToken = Tokens[OwnTokenPosition + 1]
		if not PrevToken or not NextToken then
			--print(Tokens)
			EWI.Error(8, SharedContext, ExecutableContext, "A glitch happened while compiling your code. This is not your fault. Please contact the developers.")
		end
		local PrevTokenType = PrevToken.Type
		local NextTokenType = NextToken.Type
		--print(`Operation: {PrevToken.Content} {SelfChar} {NextToken.Content} -> {StoreResultIn}`)
		if not table.find({"Variable"}, PrevTokenType) or not table.find({"Variable"}, NextTokenType) then
			EWI.Error(7, SharedContext, ExecutableContext, `Cannot {SelfChar} {PrevTokenType} and {NextTokenType}`)
		end
		local BlocksCreated = {}
		local NextTokenContent = NextToken.Content
		local PrevTokenContent = PrevToken.Content
		--if NextToken.Type == "Variable" and string.find(NextTokenContent, ".", nil, true) then
		--	NextTokenContent = GetPathToBlocks(NextToken.Content, BlocksCreated)
		--elseif NextToken.Type == "Number" then
		--	NextTokenContent = tonumber(NextToken.Content)
		--end
		--if PrevToken.Type == "Variable" and string.find(PrevTokenContent, ".", nil, true) then
		--	PrevTokenContent = GetPathToBlocks(PrevToken.Content, BlocksCreated)
		--end

		table.insert(BlocksCreated, VisualLibrary.NewBlock(
			"GetTableValue", 
			GenerateUniqueName("Operator-"),
			{
				VisualLibrary.NewInput("Table", PrevTokenContent, false),
				VisualLibrary.NewInput("Key", NextTokenContent, false),
				VisualLibrary.NewOutput("Value", StoreResultIn)
			}
			)
		)

		if #BlocksCreated > 1 then
			BlocksCreated[#BlocksCreated - 1]:ConnectToBlock(BlocksCreated[#BlocksCreated])
		end

		for _ = 1,3 do
			table.remove(Tokens, OwnTokenPosition - 1)
		end
		table.insert(Tokens, OwnTokenPosition - 1, {Content=StoreResultIn, Type="Variable"})
		return BlocksCreated
	end,
	["="]=function(Tokens:{any}, OwnTokenPosition:number, StoreResultIn:string, SharedContext:SharedClasses.SharedContext, ExecutableContext:SharedClasses.ExecutableContext) 
		local BlocksCreated = {}
		local VariableNames = {}
		local VariableNameOGTokens = {}
		local AssignedValueTokens = {}
		local TokenPointer = 1
		local LastValueWasComma = true
		while TokenPointer < OwnTokenPosition do
			local TokenPointingTo = Tokens[TokenPointer]
			if LastValueWasComma and TokenPointingTo.Content == "," and TokenPointingTo.Type == "Operator" then
				EWI.Error(1, SharedContext, ExecutableContext, "Comma was not expected here")
			end
			if not LastValueWasComma and TokenPointingTo.Content ~= "," and TokenPointingTo.Type ~= "Operator" then
				EWI.Error(1, SharedContext, ExecutableContext, "Comma was expected here")
			end
			if not LastValueWasComma then
				LastValueWasComma = not LastValueWasComma
				TokenPointer += 1
				continue
			end
			LastValueWasComma = not LastValueWasComma
			if TokenPointingTo.Type ~= "Variable" then
				EWI.Error(9, SharedContext, ExecutableContext, "A variable name was expected when assigning a variable")
			end
			table.insert(VariableNames, TokenPointingTo.Content)
			table.insert(VariableNameOGTokens, TokenPointingTo)
			TokenPointer += 1
		end
		if LastValueWasComma then
			EWI.Error(1, SharedContext, ExecutableContext, "An extra comma was put but no variable name was assigned")
		end
		TokenPointer += 1
		LastValueWasComma = true
		while TokenPointer <= #Tokens do
			local TokenPointingTo = Tokens[TokenPointer]
			if LastValueWasComma and TokenPointingTo.Content == "," and TokenPointingTo.Type == "Operator" then
				EWI.Error(1, SharedContext, ExecutableContext, "Comma was not expected here")
			end
			if not LastValueWasComma and TokenPointingTo.Content ~= "," and TokenPointingTo.Type ~= "Operator" then
				EWI.Error(1, SharedContext, ExecutableContext, "Comma was expected here")
			end
			if not LastValueWasComma then
				TokenPointer += 1
				LastValueWasComma = not LastValueWasComma
				continue
			end
			LastValueWasComma = not LastValueWasComma
			table.insert(AssignedValueTokens, TokenPointingTo)
			TokenPointer += 1
		end
		local VariableNamePointer = 1
		local AssignedTokenPointer = 1
		if #VariableNames > 0 and #AssignedValueTokens == 0 then
			EWI.Error(7, SharedContext, ExecutableContext, "Directive unexpectedly ended while parsing values to assign. Cannot assign nothing.")
		end
		while AssignedTokenPointer <= #AssignedValueTokens do
			local AssignedTokenOrTuple = AssignedValueTokens[AssignedTokenPointer]
			local VariableName = VariableNames[VariableNamePointer]
			local AssignedTokensHere = {}
			if table.find({"FunctionTuple", "BracketResultTuple"}, AssignedTokenOrTuple.Type) then
				AssignedTokensHere = AssignedTokenOrTuple.Content
			else
				AssignedTokensHere = {AssignedTokenOrTuple}
			end
			for _, AssignedToken in pairs(AssignedTokensHere) do
				local VariableName = VariableNames[VariableNamePointer]
				if not VariableName then
					EWI.Error(11, SharedContext, ExecutableContext, "More values are given than variable names.")
				end
				--print(`Assignment: {VariableName} = {AssignedToken.Content}`)
				local AssignedTokenContent = AssignedToken.Content
				if AssignedToken.Type == "Number" then
					AssignedTokenContent = tonumber(AssignedToken.Content)
				elseif AssignedToken.Type == "Boolean" then
					AssignedTokenContent = AssignedToken.Content == "true"
				elseif AssignedToken.Type == "Variable" and string.find(AssignedToken.Content, ".", nil, true) then
					AssignedTokenContent = GetPathToBlocks(AssignedToken.Content, BlocksCreated)
				end
				local OGToken = VariableNameOGTokens[VariableNamePointer]
				if string.find(VariableName, ".", nil, true) or OGToken.OriginalKey then
					local LastStep, Path
					local IsKeyVariable = false
					if string.find(VariableName, ".", nil, true) then
						LastStep, Path = SetPathToBlocks(VariableName, BlocksCreated)
					else
						LastStep = GetPathToBlocks(OGToken.OriginalTableToken.Content, BlocksCreated)
						Path = {Property=OGToken.OriginalKey}
						IsKeyVariable = OGToken.IsKeyVariable
					end
					local TypeOfOutput = GenerateUniqueName("TypeOfOutput-")
					local TypeOfBlock = VisualLibrary.NewBlock("TypeOf", GenerateUniqueName("TypeOf-"), {
						VisualLibrary.NewInput("Variable", LastStep, true),
						VisualLibrary.NewOutput("Type", TypeOfOutput)
					})
					local IfBlock1 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
						VisualLibrary.NewInput("Value 1", TypeOfOutput, true),
						VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal),
						VisualLibrary.NewInput("Value 2", "Instance")
					})
					local IfBlock2 = VisualLibrary.NewBlock("If", GenerateUniqueName("If-"), {
						VisualLibrary.NewInput("Value 1", TypeOfOutput, true),
						VisualLibrary.NewInput("ComparisonType", VisualLibrary.Choice.Equal),
						VisualLibrary.NewInput("Value 2", "table")
					})
					TypeOfBlock:ConnectToBlock(IfBlock1)
					TypeOfBlock:ConnectToBlock(IfBlock2)
					local SetBlock = VisualLibrary.NewBlock("SetTableValue", GenerateUniqueName("Set-"), {
						VisualLibrary.NewInput("Table", LastStep),
						VisualLibrary.NewInput("Key", Path.Property, IsKeyVariable),
						VisualLibrary.NewInput("Value", AssignedTokenContent, AssignedToken.Type == "Variable")
					})
					local SetInstanceBlock = VisualLibrary.NewBlock("SetObjectProperty", GenerateUniqueName("SetInst-"), {
						VisualLibrary.NewInput("Object", LastStep, true),
						VisualLibrary.NewInput("Property", Path.Property, IsKeyVariable),
						VisualLibrary.NewInput("Value", AssignedTokenContent, AssignedToken.Type == "Variable")
					})
					IfBlock1:ConnectToBlock(SetInstanceBlock)
					IfBlock2:ConnectToBlock(SetBlock)
					if #BlocksCreated > 0 then
						BlocksCreated[#BlocksCreated]:ConnectToBlock(TypeOfBlock)
					end
					table.insert(BlocksCreated, TypeOfBlock)
					table.insert(BlocksCreated, IfBlock1)
					table.insert(BlocksCreated, IfBlock2)
					table.insert(BlocksCreated, SetBlock)
					table.insert(BlocksCreated, SetInstanceBlock)
				else
					local SetBlock = VisualLibrary.NewBlock("SetVariable1", GenerateUniqueName("SetVariable-"), {
						VisualLibrary.NewInput("Value", AssignedTokenContent, AssignedToken.Type == "Variable"),
						VisualLibrary.NewOutput("VariableName", VariableName)
					})
					if #BlocksCreated > 0 then
						BlocksCreated[#BlocksCreated]:ConnectToBlock(SetBlock)
					end
					table.insert(BlocksCreated, SetBlock)
				end
				VariableNamePointer += 1
			end
			
			AssignedTokenPointer += 1
		end
		for _ = 1, #Tokens do
			table.remove(Tokens, 1)
		end
		table.insert(Tokens, {Content="Success", Type="AssignmentResult"})
		return BlocksCreated
	end
}

return operators
