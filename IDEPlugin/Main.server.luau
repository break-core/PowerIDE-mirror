-- Powerlang IDE plugin by vopwn55
-- 1 Oct 2024

assert(plugin, "This script must be run as a plugin!")

local TextService = game:GetService("TextService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")
local StudioService = game:GetService("StudioService")
local Selection = game:GetService("Selection")
local NativeMsgBox = require(script.Parent.Libraries.NativeMsgBox)
local PowerlangCoreI = script.Parent.Powerlang:FindFirstChild("PowerlangCore")
local PowerlangTokenizerI = script.Parent.Powerlang:FindFirstChild("Tokenizer")
local StudioFS = require(script.Parent.Libraries.StudioFS)
local FileSessionMain = StudioFS.new(plugin)

if not RunService:IsEdit() then
	return
end

local StudioSettings = settings()
local ColorSettings = {
	String = StudioSettings.Studio["String Color"],
	Number = StudioSettings.Studio["Number Color"],
	Keyword = StudioSettings.Studio["Keyword Color"],
	Comment = StudioSettings.Studio["Comment Color"],
	Operator = StudioSettings.Studio["Operator Color"],
	FunctionName = StudioSettings.Studio["Function Name Color"],
	Property = StudioSettings.Studio["Property Color"],
	Boolean = StudioSettings.Studio["Bool Color"],
	Flag = StudioSettings.Studio["Warning Color"]
}

if StudioSettings.Studio.Theme.Name == "Light" then
	for _, GUIItem in pairs(script.Parent:GetDescendants()) do
		if GUIItem:IsA("GuiObject") and GUIItem.BackgroundTransparency < 1 then
			GUIItem.BackgroundColor3 = Color3.new(1 - GUIItem.BackgroundColor3.R, 1 - GUIItem.BackgroundColor3.G, 1 - GUIItem.BackgroundColor3.B)
		end
		if GUIItem:IsA("TextLabel") or GUIItem:IsA("TextButton") or GUIItem:IsA("TextBox") then
			GUIItem.TextColor3 = Color3.new(1 - GUIItem.TextColor3.R, 1 - GUIItem.TextColor3.G, 1 - GUIItem.TextColor3.B)
		end
		if GUIItem:IsA("ImageLabel") or GUIItem:IsA("ImageButton") and GUIItem.ImageColor3 == Color3.new(1,1,1) then
			GUIItem.ImageColor3 = Color3.new(0,0,0)
		end
		if GUIItem:IsA("ScrollingFrame") then
			GUIItem.ScrollBarImageColor3 = Color3.new(1 - GUIItem.ScrollBarImageColor3.R, 1 - GUIItem.ScrollBarImageColor3.G, 1 - GUIItem.ScrollBarImageColor3.B)
		end
	end
end

if not PowerlangCoreI or not PowerlangTokenizerI then
	local popup = NativeMsgBox.new("PowerIDE Error", "No version of Powerlang is present inside the plugin, cannot proceed", {"OK_BLUE"}, "Close", plugin)
	return
end

PowerlangCore = require(PowerlangCoreI.Core)
PowerlangSC = require(PowerlangCoreI.SharedClasses)
PowerlangTokenizer = require(PowerlangTokenizerI)
UndoRedo = require(script.Parent.Libraries.UndoRedo)

local FileOpenedName = "<New file>"

local StudioRibbonToolbar:PluginToolbar = plugin:CreateToolbar("PowerIDE")
local StudioRibbonButton = StudioRibbonToolbar:CreateButton("PowerIDE", "Open PowerIDE", "rbxassetid://139014705632958", "Open PowerIDE")
local MainWindow = plugin:CreateDockWidgetPluginGui("PowerIDEMainWindow1", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, 640, 480, 320, 240))
MainWindow.Title = "PowerIDE - " .. FileOpenedName
MainWindow.Name = MainWindow.Title
MainWindow.Enabled = false
local BuildWindow = plugin:CreateDockWidgetPluginGui("PowerIDEBuildWindow1", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, 300, 175, 300, 175))
BuildWindow.Title = "PowerIDE"
BuildWindow.Name = BuildWindow.Title
BuildWindow.Enabled = false
for _, Member in pairs(script.Parent.MainGUI:GetChildren()) do
	Member:Clone().Parent = MainWindow
end
for _, Member2 in pairs(script.Parent.BuildGUI:GetChildren()) do
	Member2:Clone().Parent = BuildWindow
end
MainWindow:GetPropertyChangedSignal("Enabled"):Connect(function()
	StudioRibbonButton:SetActive(MainWindow.Enabled)
end)
task.delay(1, function()
	MainWindow.Enabled = false
	BuildWindow.Enabled = false
end)
MainWindow.Topbar.ToolSet.PowerlangVersion.Text = "Powerlang Version: " .. PowerlangCoreI.Version.Value
local CodeBox = MainWindow.CodeSpace.CodeContainer.CodeBox
local FakeBox = MainWindow.CodeSpace.CodeContainer.FakeContents

if plugin:GetSetting("-zoom") then
	local zoom = plugin:GetSetting("-zoom")
	CodeBox.TextSize = zoom
	CodeBox.Parent.FakeContents.TextSize = zoom
	CodeBox.Parent.Parent.Lines.TextSize = zoom
end

StudioRibbonButton.Click:Connect(function()
	MainWindow.Enabled = not MainWindow.Enabled
	StudioRibbonButton:SetActive(MainWindow.Enabled)
end)

function Color3ToHex(color:Color3)
	return string.format("#%02X%02X%02X", color.R * 0xFF, color.G * 0xFF, color.B * 0xFF)
end

local doNotRecordFlag = false

-- Render contents
function DisplayRealContent()
	local Content = CodeBox.Text
	if not PowerlangTokenizer then
		return
	end
	local Rightshift = 0
	local Tokens = PowerlangTokenizer.Tokenize(Content)
	for i, Token in pairs(Tokens) do
		local Start, End = Token.TokenBegin, Token.TokenEnd
		if not Start or not End then
			print(Token)
			warn("Lexing error")
			continue
		end
		Start += 1
		if Token.Type == "Variable" and Tokens[i + 1] and Tokens[i + 1].Type == "Bracket" and Tokens[i + 1].Content == "(" then
			Token.Type = "FunctionName"
		end
		if (Token.Type == "Variable" or Token.Type == "Property") and Tokens[i - 1] and Tokens[i - 1].Type == "Operator" and Tokens[i - 1].Content == "." then
			Token.Type = "Property"
		end
		local Color = StudioSettings.Studio["Text Color"]
		if ColorSettings[Token.Type] then
			Color = ColorSettings[Token.Type]
		end
		local Tag1 = string.format("<font color=\"%s\">", Color3ToHex(Color))
		local Tag2 = "</font>"
		--insert tag1 at Start + Rightshift
		Content = string.sub(Content, 1, Start + Rightshift - 1) .. Tag1 .. string.sub(Content, Start + Rightshift, End + Rightshift) .. Tag2 .. string.sub(Content, End + Rightshift + 1)
		Rightshift += #Tag1 + #Tag2
	end
	local OtherRightshift = 0
	for iraw, char in pairs(Content:split("")) do
		local i = iraw + OtherRightshift
		if char == "<" and string.sub(Content, i+1, i+4) ~= "font" and string.sub(Content, i+1, i+4) ~= "/fon" then
			-- replace with "&lt;" to prevent rich text from breaking
			Content = string.sub(Content, 1, i-1) .. "&lt;" .. string.sub(Content, i+1)
			OtherRightshift += 3
		end
	end
	FakeBox.Text = Content
	local TextBounds = FakeBox.TextBounds
	FakeBox.Parent.Parent.CanvasSize = UDim2.new(0, (TextBounds.X + 30) * 1.2, 1, TextBounds.Y)
	CodeBox.Size = UDim2.new(1,0,1,0) --reevaluate
	local LineCount = math.floor(TextBounds.Y / CodeBox.TextSize)
	local LinesText = ""
	for i = 1, LineCount do
		LinesText = LinesText .. i .. "\n"
	end
	FakeBox.Parent.Parent.Lines.Text = LinesText
	if not doNotRecordFlag then
		UndoRedo.RecordString(CodeBox.Text)
	else
		doNotRecordFlag = false
	end
	if UndoRedo.CanUndo() then
		MainWindow.Topbar.ToolSet.Undo.ImageTransparency = 0
	else
		MainWindow.Topbar.ToolSet.Undo.ImageTransparency = 0.5
	end
	
	if UndoRedo.CanRedo() then
		MainWindow.Topbar.ToolSet.Redo.ImageTransparency = 0
	else
		MainWindow.Topbar.ToolSet.Redo.ImageTransparency = 0.5
	end
end

DisplayRealContent()

function FindNumOccurencesInString(str, char)
	local _, result = string.gsub(str, char, "")
	return result
end

EventOverride = false
local OldText = CodeBox.Text
CodeBox:GetPropertyChangedSignal("Text"):Connect(function()
	local CurrentCursorPosition = CodeBox.CursorPosition - 1
	if CurrentCursorPosition < 0 then
		DisplayRealContent()
		OldText = CodeBox.Text
		return
	end
	if #CodeBox.Text < #OldText then
		-- backspace
		OldText = CodeBox.Text
		DisplayRealContent()
		return
	end
	EventOverride = true
	local LastChar = string.sub(CodeBox.Text, CurrentCursorPosition, CurrentCursorPosition)
	if LastChar == "\n" and CurrentCursorPosition > 0 then
		local IndentationLevel = FindNumOccurencesInString(string.sub(CodeBox.Text, 1, CurrentCursorPosition), "{") - FindNumOccurencesInString(string.sub(CodeBox.Text, 1, CurrentCursorPosition), "}")
		local ToInsert = string.rep("	", IndentationLevel)
		--CodeBox.CursorPosition = 1
		local Indentated = string.sub(CodeBox.Text, 1, CurrentCursorPosition) .. ToInsert .. string.sub(CodeBox.Text, CurrentCursorPosition + 1)
		CodeBox.Text = Indentated
		CodeBox.CursorPosition = CurrentCursorPosition + #ToInsert + 1
	end
	DisplayRealContent()
	EventOverride = false
	OldText = CodeBox.Text
end)

CodeBox:GetPropertyChangedSignal("CursorPosition"):Connect(function()
	local NewPosition = CodeBox.CursorPosition
	-- find how far horizontally it is (considering newlines)
	if CodeBox.CursorPosition <= 0 then
		return
	end
	
	-- Thanks NicePotato! \o/
	local cursorPosition = CodeBox.CursorPosition
	if cursorPosition > 0 then
		-- Split the text into lines
		local textBeforeCursor = string.sub(CodeBox.Text, 1, cursorPosition - 1)
		local lines = string.split(textBeforeCursor, "\n")

		local currentLineIndex = #lines
		local currentLineText = lines[currentLineIndex]

		local currentLineSize = TextService:GetTextSize(currentLineText, CodeBox.TextSize, CodeBox.Font, Vector2.new(CodeBox.AbsoluteSize.X, math.huge))

		local caretX = currentLineSize.X

		local lineHeight = CodeBox.TextSize
		local caretY = (currentLineIndex - 1) * lineHeight

		-- Horizontal scroll adjustment (CodeScroller)
		local scrollPositionX = CodeBox.Parent.Parent.CanvasPosition.X
		local viewWidth = CodeBox.Parent.Parent.AbsoluteSize.X

		if caretX < scrollPositionX then
			CodeBox.Parent.Parent.CanvasPosition = Vector2.new(caretX - 70, CodeBox.Parent.Parent.CanvasPosition.Y) -- Scroll left
		elseif caretX > scrollPositionX + viewWidth - 70 then
			CodeBox.Parent.Parent.CanvasPosition = Vector2.new(caretX - viewWidth + 70, CodeBox.Parent.Parent.CanvasPosition.Y) -- Scroll right
		end
	end
end)

-- Handle logs
local LogRedirect = nil
pcall(function()
	LogService.MessageOut:Connect(function(message, _)
		if LogRedirect then
			LogRedirect.Text = LogRedirect.Text .. message .. "\n"
		end
	end)
end)

-- Handle buttons
function HideSaveLoadOptions()
	MainWindow.Topbar.ToolSet.SaveOptions.Visible = false
	MainWindow.Topbar.ToolSet.LoadOptions.Visible = false
end

MainWindow.Topbar.ToolSet.Load.Activated:Connect(function()
	local AlreadyOpen = MainWindow.Topbar.ToolSet.LoadOptions.Visible
	if AlreadyOpen then
		HideSaveLoadOptions()
		return
	end
	HideSaveLoadOptions()
	MainWindow.Topbar.ToolSet.LoadOptions.Visible = true
end)

MainWindow.Topbar.ToolSet.Save.Activated:Connect(function()
	local AlreadyOpen = MainWindow.Topbar.ToolSet.SaveOptions.Visible
	if AlreadyOpen then
		HideSaveLoadOptions()
		return
	end
	HideSaveLoadOptions()
	MainWindow.Topbar.ToolSet.SaveOptions.Visible = true
end)

MainWindow.Topbar.ToolSet.LoadOptions.FromDisk.Activated:Connect(function()
	HideSaveLoadOptions()
	local FileSelected:File = StudioService:PromptImportFile({"lua", "txt"})
	if not FileSelected then
		-- User hasn't chosen anything
		return
	end
	FileOpenedName = FileSelected.Name
	MainWindow.Title = "PowerIDE - " .. FileSelected.Name
	MainWindow.Topbar.ToolSet.CurrentlyEditing.Text = "Editing: " .. FileSelected.Name
	CodeBox.Text = FileSelected:GetBinaryContents()
	DisplayRealContent()
end)

MainWindow.Topbar.ToolSet.SaveOptions.ToDisk.Activated:Connect(function()
	HideSaveLoadOptions()
	local TempScript = Instance.new("Script", workspace)
	TempScript.Name = "This is a temporary script for the IDE to save to disk"
	TempScript.Source = CodeBox.Text
	Selection:Set({TempScript})
	local SuggestedName = FileOpenedName:split(".")[1]
	if FileOpenedName == "<New file>" then
		SuggestedName = "unnamed"
	end
	local SavedOrNot = plugin:PromptSaveSelection(SuggestedName)
	if SavedOrNot then
		print("File saved to disk")
	else
		warn("File not saved to disk")
	end
	TempScript:Destroy()
end)

MainWindow.Topbar.ToolSet.SaveOptions.ToPersistence.Activated:Connect(function()
	HideSaveLoadOptions()
	--NativeMsgBox.new("PowerIDE Error", "Saving to Studio Persistence is not yet implemented. Please save to disk instead.", {"OK_BLUE"}, "Close", plugin)
	FileSessionMain:PromptSaveFile(FileOpenedName, CodeBox.Text)
end)

script.Parent.Libraries.StudioFS.FileSaved.Event:Connect(function(savedFileName)
	if savedFileName then
		FileOpenedName = savedFileName
		MainWindow.Title = "PowerIDE - " .. savedFileName
		MainWindow.Topbar.ToolSet.CurrentlyEditing.Text = "Editing: " .. savedFileName
	end
end)

script.Parent.Libraries.StudioFS.FileLoaded.Event:Connect(function(fileName, fileContents)
	if fileName then
		FileOpenedName = fileName
		MainWindow.Title = "PowerIDE - " .. fileName
		MainWindow.Topbar.ToolSet.CurrentlyEditing.Text = "Editing: " .. fileName
	end
	if fileContents then
		CodeBox.Text = fileContents
		DisplayRealContent()
	end
end)

MainWindow.Topbar.ToolSet.LoadOptions.FromPersistence.Activated:Connect(function()
	HideSaveLoadOptions()
	--NativeMsgBox.new("PowerIDE Error", "Loading from Studio Persistence is not yet implemented. Please load from disk instead.", {"OK_BLUE"}, "Close", plugin)
	FileSessionMain:PromptLoadFile(FileOpenedName)
end)

MainWindow.Topbar.ToolSet.Compile.Activated:Connect(function()
	--if BuildWindow.Enabled then
	--	NativeMsgBox.new("PowerIDE", "Previous compilation must finish before starting a new one", {"OK_BLUE"}, "Close", plugin)
	--	return
	--end
	if not PowerlangCoreI then
		-- ideally this should never happen unless the user tinkers with the plugin
		NativeMsgBox.new("PowerIDE", "Powerlang is required to compile Powerlang code... duh...", {"OK_BLUE"}, "Close", plugin)
		return
	end
	BuildWindow.BGFrame.StageBuilding.Visible = true
	BuildWindow.BGFrame.StageFailure.Visible = false
	BuildWindow.BGFrame.StageSuccess.Visible = false
	BuildWindow.BGFrame.StageBuilding.Log.Text = ""
	BuildWindow.BGFrame.StageFailure.Log.Text = ""
	BuildWindow.BGFrame.StageSuccess.CodeResult.Text = ""
	BuildWindow.Enabled = true
	local BuildContent = CodeBox.Text .. "\n"
	LogRedirect = BuildWindow.BGFrame.StageBuilding.Log
	local ExecutableContext = PowerlangSC.ExecutableContext(FileOpenedName)
	local success, ResultRaw = pcall(function()
		return {PowerlangCore.Parse(BuildContent, ExecutableContext)}
	end)
	local CodeOrError
	local Warns
	if success then
		CodeOrError = ResultRaw[1]
		Warns = ResultRaw[2]
		
		if Warns == 0 then
			BuildWindow.BGFrame.StageSuccess.TextLabel.Text = "Code has been compiled. Please copy and paste result below into the RetroStudio importer."
		else
			BuildWindow.BGFrame.StageSuccess.TextLabel.Text = "Code has been compiled <b><font color=\"#ff8000\">with " .. Warns .. " warning(s).</font></b> You may see the warnings in the Studio Output."
		end
		
		BuildWindow.BGFrame.StageSuccess.CodeResult.Text = CodeOrError
		BuildWindow.BGFrame.StageSuccess.CodeResult:CaptureFocus()
		BuildWindow.BGFrame.StageSuccess.CodeResult.SelectionStart = 1
		BuildWindow.BGFrame.StageSuccess.CodeResult.CursorPosition = #CodeOrError
		
		BuildWindow.BGFrame.StageSuccess.Visible = true
		BuildWindow.BGFrame.StageBuilding.Visible = false
	else
		CodeOrError = ResultRaw
		local occ = string.find(CodeOrError, "ErrorsWarnsInfos:57:")
		if occ then
			CodeOrError = string.sub(CodeOrError, occ + #"ErrorsWarnsInfos:57:  ")
		end
		warn(CodeOrError)
		BuildWindow.BGFrame.StageFailure.Log.Text = BuildWindow.BGFrame.StageBuilding.Log.Text .. CodeOrError
		BuildWindow.BGFrame.StageFailure.Log.TextColor3 = StudioSettings.Studio["Error Color"]
		BuildWindow.BGFrame.StageFailure.Visible = true
		BuildWindow.BGFrame.StageBuilding.Visible = false
	end
	LogRedirect = nil
end)

function Undo()
	if not MainWindow.Enabled then
		return
	end
	if UndoRedo.CanUndo() then
		doNotRecordFlag = true
		CodeBox.Text = UndoRedo.Undo()
	else
		warn("There is nothing to undo")
	end
end

function Redo()
	if not MainWindow.Enabled then
		return
	end
	if UndoRedo.CanRedo() then
		doNotRecordFlag = true
		CodeBox.Text = UndoRedo.Redo()
	else
		warn("There is nothing to redo")
	end
end

function ZoomIn()
	if not MainWindow.Enabled then
		return
	end
	CodeBox.TextSize += 2
	CodeBox.Parent.FakeContents.TextSize += 2
	CodeBox.Parent.Parent.Lines.TextSize += 2
	plugin:SetSetting("-zoom", CodeBox.TextSize)
	DisplayRealContent()
end

function ZoomOut()
	if not MainWindow.Enabled then
		return
	end
	if CodeBox.TextSize < 10 then
		return
	end
	CodeBox.TextSize -= 2
	CodeBox.Parent.FakeContents.TextSize -= 2
	CodeBox.Parent.Parent.Lines.TextSize -= 2
	plugin:SetSetting("-zoom", CodeBox.TextSize)
	DisplayRealContent()
end

MainWindow.Topbar.ToolSet.Undo.Activated:Connect(Undo)
MainWindow.Topbar.ToolSet.Redo.Activated:Connect(Redo)
MainWindow.Topbar.ToolSet.ZoomOut.Activated:Connect(ZoomOut)
MainWindow.Topbar.ToolSet.ZoomIn.Activated:Connect(ZoomIn)
--ContextActionService:BindAction("UndoCode", Undo, false, Enum.KeyCode.LeftShift, Enum.KeyCode.LeftControl, Enum.KeyCode.Z)
--ContextActionService:BindAction("RedoCode", Redo, false, Enum.KeyCode.LeftShift, Enum.KeyCode.LeftControl, Enum.KeyCode.Y)
--ContextActionService:BindAction("ZoomOut", ZoomOut, false, Enum.KeyCode.LeftShift, Enum.KeyCode.LeftControl, Enum.KeyCode.Minus)
--ContextActionService:BindAction("ZoomIn", ZoomIn, false, Enum.KeyCode.LeftShift, Enum.KeyCode.LeftControl, Enum.KeyCode.Plus)