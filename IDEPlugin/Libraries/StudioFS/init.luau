-- for the people too afraid of saving to disk

local NativeMsgBox = require(script.Parent.NativeMsgBox)
local FileTableCache = nil

type FileSession = {
	Plugin:Plugin,
	PickerUI:DockWidgetPluginGui,
	PickerUIState: "Saving" | "Loading" | "Undefined",
	PickerButtonEvents: {RBXScriptSignal},
	PickerFileActionMenu: PluginMenu,
	SaveRaw:(self:FileSession, path:string, data:string) -> boolean?,
	LoadRaw:(self:FileSession, path:string) -> any,
	ObtainFileAllocationTable:(self:FileSession) -> {"string"},
	UpdateFilePickerInternal:(self:FileSession) -> nil,
	PromptSaveFile:(self:FileSession, suggestedName:string, data:string) -> nil,
	PromptLoadFile:(self:FileSession, suggestedName:string) -> nil,
	AddFileToAllocationTable: (self:FileSession, newFileName:string) -> nil,
	RemoveFileFromAllocationTable: (self:FileSession, fileName:string) -> nil,
}

local FileSession = {}
FileSession.new = function(Plugin:Plugin)
	local Window = Plugin:CreateDockWidgetPluginGui("StudioFSFilePicker", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, true, 500, 400, 500, 400))
	Window.Enabled = false
	Window.Name = "StudioFSSaveFile"
	Window.Title = "File Operation"
	for _, child in pairs(script.FilePickerUI:GetChildren()) do
		child:Clone().Parent = Window
	end
	Window.BottomBar.CancelButton.Activated:Connect(function()
		Window.Enabled = false
	end)
	FileTableCache = Plugin:GetSetting("-FAT") or {}
	
	-- Does it get simpler than this?
	local FileActionMenu = Plugin:CreatePluginMenu("FileAction", "File Actions", "rbxassetid://4998267428")
	FileActionMenu:AddNewAction("FileDelete", "Delete", "rbxassetid://2290983952")
	
	local NewFileSession:FileSession = {
		Plugin = Plugin,
		PickerUI = Window,
		PickerUIState = "Undefined",
		PickerFileActionMenu = FileActionMenu,
		PickerButtonEvents = {},
		SaveRaw = function(self, path:string, data:string)
			local PathTraced = path:split("/")
			assert(#PathTraced >= 1, "Path cannot be empty")
			assert(#PathTraced == 1, "Cannot save to folders currently")
			assert(not string.find(PathTraced[1], "/", nil, true), "File name cannot include forward slash")
			assert(not string.find(PathTraced[1], "-", nil, true), "File name cannot include minus")

			local FinalFileName = PathTraced[#PathTraced]
			self.Plugin:SetSetting(FinalFileName, data)
			return true
		end,
		LoadRaw = function(self, path:string)
			local PathTraced = path:split("/")
			assert(#PathTraced >= 1, "Path cannot be empty")
			assert(#PathTraced == 1, "Cannot save to folders currently")
			assert(not string.find(PathTraced[1], "/", nil, true), "File name cannot include forward slash")
			assert(not string.find(PathTraced[1], "-", nil, true), "File name cannot include minus")
			
			local FinalFileName = PathTraced[#PathTraced]
			local data = self.Plugin:GetSetting(FinalFileName)
			return data
		end,
		ObtainFileAllocationTable = function(self)
			--return FileTableCache
			return self.Plugin:GetSetting("-FAT") or {}
		end,
		AddFileToAllocationTable = function(self, newFileName:string)
			local FileTable = self:ObtainFileAllocationTable()
			if not table.find(FileTable, newFileName) then
				table.insert(FileTable, newFileName)
				self.Plugin:SetSetting("-FAT", FileTable)
				FileTableCache = FileTable
			end
		end,
		RemoveFileFromAllocationTable = function(self, fileName:string)
			local FileTable = self:ObtainFileAllocationTable()
			local index = table.find(FileTable, fileName)
			if index then
				table.remove(FileTable, index)
				self.Plugin:SetSetting("-FAT", FileTable)
				FileTableCache = FileTable
			end
		end,
		UpdateFilePickerInternal = function(self)
			local FileTable = self:ObtainFileAllocationTable()
			local FilePicker = self.PickerUI.Files
			for _, leftover in pairs(FilePicker.FileList:GetChildren()) do
				if leftover:IsA("TextButton") and leftover.Visible and leftover.Name ~= "FileTemplate" then
					leftover:Destroy()
				end
			end
			if #FileTable == 0 then
				FilePicker.NoFilesAvailable.Visible = true
				return {}
			end
			FilePicker.NoFilesAvailable.Visible = false
			local ButtonsCreated = {}
			for _, file in pairs(FileTable) do
				if typeof(file) ~= "string" then
					continue
				end
				local NewButton = FilePicker.FileList.FileTemplate:Clone()
				NewButton.Name = "FilePick"
				NewButton.FileName.Text = file
				local event = NewButton.MouseButton2Click:Connect(function()
					local Chosen = self.PickerFileActionMenu:ShowAsync()
					if Chosen and Chosen.Text == "Delete" then
						local confirmbox = NativeMsgBox.new("Confirmation", "Deleting file " .. file .. " cannot be undone. Proceed anyway?", {"Yes_BLUE", "No"}, "", self.Plugin)
						confirmbox.gui.ButtonHolder:WaitForChild("Yes_BLUE").Activated:Once(function()
							confirmbox.widget:Destroy()
							self:RemoveFileFromAllocationTable(file)
							self:SaveRaw(file, nil)
							NewButton:Destroy()
						end)
						confirmbox.gui.ButtonHolder:WaitForChild("No").Activated:Once(function()
							confirmbox.widget:Destroy()
						end)
					end
				end)
				table.insert(self.PickerButtonEvents, event)
				NewButton.Parent = FilePicker.FileList
				NewButton.Visible = true
				ButtonsCreated[file] = NewButton
			end
			return ButtonsCreated
		end,
		PromptSaveFile = function(self, suggestedName:string, data:string)
			assert(not self.PickerUI.Enabled, "Please finish the current file operation before initiating a new one")
			for _, event in pairs(self.PickerButtonEvents) do
				event:Disconnect()
			end
			self.PickerUIState = "Saving"
			self.PickerUI.Title = "Save File"
			self.PickerUI.Enabled = true
			self.PickerUI.BottomBar.FileName:CaptureFocus()
			self.PickerUI.BottomBar.FileName.Text = suggestedName
			self.PickerUI.BottomBar.TextLabel.Text = "Save to:"
			self.PickerUI.BottomBar.PrimaryActionButton.Text = "Save"
			local ButtonsCreated = self:UpdateFilePickerInternal()
			for path, btn in pairs(ButtonsCreated) do
				btn.MouseButton1Click:Connect(function()
					local confirmbox = NativeMsgBox.new("Confirmation", "File " .. path .. " already exists. Overwrite it?", {"Yes_BLUE", "No"}, "", self.Plugin)
					confirmbox.gui.ButtonHolder:WaitForChild("Yes_BLUE").Activated:Once(function()
						confirmbox.widget:Destroy()
						self:SaveRaw(path, data)
						self:AddFileToAllocationTable(path)
						self.PickerUI.Enabled = false
						script.FileSaved:Fire(path)
					end)
					confirmbox.gui.ButtonHolder:WaitForChild("No").Activated:Once(function()
						confirmbox.widget:Destroy()
					end)
				end)
			end
			local event = self.PickerUI.BottomBar.PrimaryActionButton.Activated:Connect(function()
				local pathTarget = self.PickerUI.BottomBar.FileName.Text
				if pathTarget == "" then
					pathTarget = "unnamed"
				end
				if not pathTarget:match("^[%w%s]+$") then
					NativeMsgBox.new("Error", "Invalid file name", {"OK"}, "Close", self.Plugin)
					return
				end
				if self.Plugin:GetSetting(pathTarget) then
					local confirmbox = NativeMsgBox.new("Confirmation", "File " .. pathTarget .. " already exists. Overwrite it?", {"Yes_BLUE", "No"}, "", self.Plugin)
					confirmbox.gui.ButtonHolder:WaitForChild("Yes_BLUE").Activated:Once(function()
						confirmbox.widget:Destroy()
						self:SaveRaw(pathTarget, data)
						script.FileSaved:Fire(pathTarget)
						self.PickerUI.Enabled = false
					end)
					confirmbox.gui.ButtonHolder:WaitForChild("No").Activated:Once(function()
						confirmbox.widget:Destroy()
					end)
					return
				end
				self:SaveRaw(pathTarget, data)
				self:AddFileToAllocationTable(pathTarget)
				script.FileSaved:Fire(pathTarget)
				self.PickerUI.Enabled = false
			end)
			table.insert(self.PickerButtonEvents, event)
		end,
		PromptLoadFile=function(self, suggestedName:string)
			assert(not self.PickerUI.Enabled, "Please finish the current file operation before initiating a new one")
			for _, event in pairs(self.PickerButtonEvents) do
				event:Disconnect()
			end
			self.PickerUIState = "Loading"
			self.PickerUI.Title = "Load File"
			self.PickerUI.Enabled = true
			self.PickerUI.BottomBar.FileName:CaptureFocus()
			self.PickerUI.BottomBar.FileName.Text = suggestedName
			self.PickerUI.BottomBar.TextLabel.Text = "Load from:"
			self.PickerUI.BottomBar.PrimaryActionButton.Text = "Load"
			local ButtonsCreated = self:UpdateFilePickerInternal()
			for path, btn in pairs(ButtonsCreated) do
				btn.MouseButton1Click:Connect(function()
					local fileData = self:LoadRaw(path)
					self.PickerUI.Enabled = false
					script.FileLoaded:Fire(path, fileData)
				end)
			end
			local event = self.PickerUI.BottomBar.PrimaryActionButton.Activated:Connect(function()
				local pathTarget = self.PickerUI.BottomBar.FileName.Text
				local fileData = self:LoadRaw(pathTarget)
				if not fileData then
					NativeMsgBox.new("Error", "File " .. pathTarget .. " does not exist", {"OK"}, "Close", self.Plugin)
					return
				end
				self.PickerUI.Enabled = false
				script.FileLoaded:Fire(pathTarget, fileData)
			end)
			table.insert(self.PickerButtonEvents, event)
		end,
	}
	return NewFileSession
	
end

return FileSession