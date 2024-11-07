local module = {}
local plugin
module.__index = module

function module.new(title:string, message:string, buttonTable, defaultButtonAction:string, pluginObj:Plugin)
	plugin = pluginObj
	assert(#buttonTable ~= 0, 'Provide atleast one button')
	
	local self = setmetatable({}, module)

	self.widgetInfo = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float,
		true,
		false,
		449,    -- default x size
		143,    -- default y size
		449,    -- min x size
		143     -- min y size
	)

	self.widget = plugin:CreateDockWidgetPluginGui("TestWidget", self.widgetInfo)
	self.widget.Title = title
	self.theme = settings().Studio.Theme.Name
	
	if self.theme == 'Dark' then
		self.gui = script.DarkMode:Clone()
	else
		self.gui = script.LightMode:Clone()
	end
	
	self.gui.Parent = self.widget

	for _, v in ipairs(buttonTable) do
		local button
		if string.find(v, '_BLUE$') then
			button = self.gui.ButtonHolder.ExampleBlue:Clone()
			button.Text = string.gsub(v, "_BLUE", "")
		else
			button = self.gui.ButtonHolder.ExampleGrey:Clone()
			button.Text = v
		end
		button.Visible = true
		button.Name = v
		button.Parent = self.gui.ButtonHolder
		if defaultButtonAction == 'Close' then
			button.MouseButton1Up:Connect(function()
				self.widget:Destroy()
			end)
		end
	end
	
	self.gui.MainText.Text = message
	
	return self
end

return module