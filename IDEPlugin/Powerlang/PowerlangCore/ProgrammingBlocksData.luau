--!strict
local module = {}

local CategoryList = {
	-- Deprecated blocks are no longer creatable normally
	["Deprecated"] = {
		["DisplayColor"] = Color3.fromRGB(255, 92, 38),
		["TabIcon"] = "",
		["ListOrder"] = 0,
	},

	["Actions"] = {
		["DisplayColor"] = Color3.fromRGB(213, 0, 255),
		["TabIcon"] = "rbxassetid://8554060111",
		["ListOrder"] = 1,
	},
	["Input"] = {
		["DisplayColor"] = Color3.fromRGB(0, 153, 255),
		["TabIcon"] = "rbxassetid://8554059836",
		["ListOrder"] = 2,
	},
	["Events"] = {
		["DisplayColor"] = Color3.fromRGB(255, 0, 136),
		["TabIcon"] = "rbxassetid://8554153312",
		["ListOrder"] = 3,
	},
	["Math"] = {
		["DisplayColor"] = Color3.fromRGB(255, 217, 0),
		["TabIcon"] = "rbxassetid://8553874107",
		["ListOrder"] = 4,
	},
	["Misc"] = {
		["DisplayColor"] = Color3.fromRGB(0, 255, 115),
		["TabIcon"] = "rbxassetid://8554059464",
		["ListOrder"] = 5,
	},
}

--[[Format:
	["Category"] = {
		{
		"SubcategoryName",
			
			"Item",
			"Item"
		},
	}
]]

local BlockCategories: {[string]: {{string}}} = {
	["Actions"] = {
		{
			"General",

			"SetObjectProperty",
			"GetObjectProperty",
			"TweenObjectProperty",
			"CreateObject",
			"DestroyObject",
			"CloneObject",
			"IsA",
		},
		{
			"Hierarchy",

			"FindFirstChild",
			"FindFirstChildWhichIsA",
			"FindFirstChildOfClass",
			"WaitForChild",
			"GetRandomChild",
			"GetChildren",
			"GetDescendants",
			"IsDescendantOf",
			"IsAncestorOf",
			"GetFullName"
		},
		{
			"Physics",

			"MakeJoints",
			"BreakJoints",
			"SetNetworkOwner", -- SERVER
			"FindPartOnRay",

			"IsTouching",
			"GetTouchingParts",
			"GetConnectedParts",

			"SetPartPhysicalProperties",
			"GetPartPhysicalProperties",
			"FireRocketPropulsion",
			"AbortRocketPropulsion",
			"RegisterCollisionGroup",
			"CollisionGroupSetCollidable",
			"AssignCollisionGroup"
		},
		{
			"Models",

			"MoveModelTo",
			--"SetModelPrimaryPartCFrame",
			"SetModelPrimaryPartCFrameNew",
			"GetModelBoundingBox",
		},
		{
			"Sounds",

			"PlaySound",
			"StopSound",
			"PauseSound",
			"ResumeSound",
		},
		{
			"Leaderstats",

			"CreateLeaderstat", -- SERVER
			"GetLeaderstat",
			"SetLeaderstat", -- SERVER
			"AddToLeaderstat", -- SERVER
			"LeaderstatChanged",
		}, 
		{
			"GUI",

			"TweenGuiSize",
			"TweenGuiPosition",
			"TextBoxCaptureFocus", -- LOCAL
			"TextBoxReleaseFocus", -- LOCAL
			"SetCoreGuiEnabled", -- LOCAL
		},
		{
			"Players",

			"GetPlayersOnTeam", 
			"TeleportToPlace", -- SERVER
			"KickPlayer", -- SERVER
			"GetPlayerFromCharacter",
			"HasBadge", -- SERVER
			"GiveBadge", -- SERVER
			"HasGamepass", -- SERVER 
			"SetCameraPositionLocal", -- LOCAL
			"GetCameraPositionLocal", -- LOCAL
			"SetMouseIconLocal", -- LOCAL
			"GetNameFromUserIdAsync",
			"GetUserIdFromNameAsync",
			"MutePlayer", -- SERVER
			"BanPlayer", -- SERVER
			"UnbanPlayerUID", -- SERVER
			"CheckIfPlayerIsBanned" -- SERVER
		},
		{
			"Characters",

			"LoadCharacter", -- SERVER
			"CheckToolEquipped",
			"TakeDamage",
			"HumanoidMoveTo",
			"ChangeHumanoidState",
			"GetHumanoidState",
			"TeleportPlayerToPosition", -- SERVER
			"ComputePath",
			"DialogChat",
		}
	},

	["Input"] = {
		{
			"Mouse",

			"ClickDetectorInteraction",

			"GetMouseTargetPart", -- SERVER
			"GetMouseTargetSurface", -- SERVER
			"GetMousePosition2D", -- SERVER
			"GetMousePosition3D", -- SERVER
			"LeftMouseDown", -- SERVER
			"LeftMouseUp", -- SERVER
			"RightMouseDown", -- SERVER
			"RightMouseUp", -- SERVER

			"GetMouseTargetPartLocal", -- LOCAL
			"GetMouseTargetSurfaceLocal", -- LOCAL
			"GetMousePosition2DLocal", -- LOCAL
			"GetMousePosition3DLocal", -- LOCAL
			"SetMouseTargetFilterLocal", -- LOCAL
			"LeftMouseDownLocal", -- LOCAL
			"LeftMouseUpLocal", -- LOCAL
			"RightMouseDownLocal", -- LOCAL
			"RightMouseUpLocal", -- LOCAL
			"JumpRequest" -- LOCAL
		},
		{
			"Keyboard",

			"KeyDown", -- SERVER
			"KeyUp", -- SERVER

			"KeyDownLocal", -- LOCAL
			"KeyUpLocal", -- LOCAL
		},
		{
			"GUI",
			"GUIMouseEnter",
			"GUIMouseLeave",
			"GUIMouseMoved",
			"GUIMouseWheelForward",
			"GUIMouseWheelBackward",
		},
		{
			"GUI Buttons",

			"GUILeftMouseButtonClick",
			"GUILeftMouseButtonDown",
			"GUILeftMouseButtonUp",
			"GUIRightMouseButtonClick",
			"GUIRightMouseButtonDown",
			"GUIRightMouseButtonUp",
		},
		{
			"Text Box",

			"TextBoxFocused",
			"TextBoxFocusLost",
		}
	},
	["Events"] = {
		{
			"Events",

			"DisconnectEvent",
			"IsConnected"
		},
		{
			"Objects",

			"ChildAdded",
			"ChildRemoved",
			"DescendantAdded",
			"DescendantRemoved",
			"PropertyChanged",
			"AnyPropertyChanged",
		},
		{
			"Remote Events",

			"RemoteFireServer2", -- CLIENT
			"RemoteFireClient2", -- SERVER
			"RemoteFireAllClients2", -- SERVER
			"RemoteRecieveClient2", -- CLIENT
			"RemoteRecieveServer2" -- SERVER
		},
		{
			"Remote Functions",

			"RemoteFunctionInvokeServer", -- CLIENT
			"RemoteFunctionInvokeClient", -- SERVER
			"RemoteFunctionOnInvokeClient", -- CLIENT
			"RemoteFunctionOnInvokeServer", -- SERVER
		},
		{
			"Bindable Events",

			"BindableFire2",
			"BindableRecieve2",
		},
		{
			"Bindable Functions",

			"BindableFunctionInvoke",
			"BindableFunctionOnInvoke"
		},
		{
			"Physics",

			"PartTouched",
			"PartTouchEnded",
			"ExplosionHit",
			"BodyPositionReachedTarget",
		},
		{
			"Tools",

			"ToolEquipped",
			"ToolUnequipped",
			"ToolActivated",
			"ToolDeactivated",
			"ActivateTool"
		},
		{
			"Players",

			"PlayerAdded",
			"PlayerRemoving",
			"Chatted", -- SERVER
			"ChattedSpecificMessage", -- SERVER
		},
		{
			"Characters",

			"CharacterAdded",
			"DialogChoiceSelected", -- CLIENT
			"HumanoidDied",
			"HumanoidFreeFalling",
			"HumanoidJumping",
			"HumanoidRunning",
			"HumanoidSeated",
			"HumanoidMoveToFinished",
			"HumanoidStateChanged",
		},
		{
			"Misc",

			"RenderStepped", -- CLIENT
			"Heartbeat",
			"BindToClose"
		}
	},
	["Math"] = {
		{
			"Basic",

			"Addition",
			"Subtraction",
			"Multiplication",
			"Division",
			"Modulus",
			"Exponentiation",
			"SolveEquation",
		},
		{
			"Functions",

			"RandomNumber",
			"Round",
			"PerlinNoise",
			"MathLibrarySingleInput",
			"MathLibraryDoubleInput",
			"MathLibraryTripleInput",
		},
		{
			"Vector3",

			"SplitVector3",
			"ConstructVector3",
			"DistanceBetweenPoints",
			"RotationBetweenPoints",
			"GetPartDirection",
			"NormalizeVector3",
			"Vector3Dot",
			"Vector3Cross"
		},
		{
			"Vector2",

			"SplitVector2",
			"ConstructVector2",
		},
		{
			"NumberRange",

			"SplitNumberRange",
			"ConstructNumberRange",
		},
		{
			"UDim2",

			"SplitUDim2",
			"ConstructUDim2",
		},
		{
			"Color",

			"SplitColor3",
			"ConstructColor3",
			"BrickColorToColor3",
			"Color3ToBrickColor",
			"RandomBrickColor",
			"Color3ToHSV",
			"HSVToColor3"
		},
		{
			"CFrame (Advanced)",

			"SplitCFrame",
			"ConstructCFrame",
			"Lerp1",
			"InverseCFrame1",
			"ToObjectSpace1",
			"ToWorldSpace1",
			"GetCFrameDirection",
			"Angles",
			"ToEulerAnglesXYZ",
			"FromMatrix",
			"FromAxisAngle"
		},
	},
	["Misc"] = {
		{
			"Variables",

			"SetVariable1",
			"Print",
			"Warn",
			"If",
			"TypeOf",
		},
		{
			"Loops",

			"ForLoop2",
			"WhileLoop3",
			"LoopThroughTable",
			"LoopThroughChildren",
			"LoopThroughDescendants",
			"BreakLoop",
			"ContinueLoop",
		},
		{
			"Functions",

			"DefineFunction",
			"FunctionReturn",
			"ExecuteFunction",
			"Spawn",
		},
		{
			"Tables",

			"CreateTable",
			"GetTableValue",
			"SetTableValue",
			"TableAppend",
			"TableInsert",
			"TableRemove",
			"GetTableLength",
			"TableFind",
			"SortTable"
		},
		{
			"Run",

			"Wait",
			"DoNotRun",
			"ExecuteBlock",
		},
		{
			"Text",

			"Concatenate",
			"SplitString",
			"FindString",
			"Substring",
			"GSubString",
			"CombineStringWithNumber",
			"CombineNumberWithString",
			"GetLength",
			"ToNumber",
			--"ToString",
			"ToStringAny",
			"Upper",
			"Lower",
			"FilterString"
		},
		{
			"Saving",

			"SaveVariable", -- SERVER
			"LoadVariable", -- SERVER
			"SaveInstance", -- SERVER	
			"LoadInstance", -- SERVER
			"JsonEncode",
			"JsonDecode"
		},
		{
			"Logic Gates",

			"OR",
			"AND",
			"NOT"
		},
		{
			"Misc",

			"Comment2",
			"InsertModel", -- SERVER
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
			"IsFriendsWith", -- SERVER
			"IsInGroup",
			"GetRankInGroup",
			"GetStudioSelection", -- CLIENT
			"ReloadPlace",
			"InsertRetrostudioAvatar",
			"GetServerTimeNow",
			"DumpMemory",
		},
	},
}

local BlocksList = {
	-- Events
	["PlayerAdded"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Player Added",
		["Description"] = [[
			Runs connected blocks when a player joins the game.
		]],

		["PreviewDisplay"] = {
			"Outputs to ",
			"!Player",
		},

		["Inputs"] = {
			-- Inputs
		},
		["Outputs"] = {
			-- Outputs
			"Player",
		},
	},
	["PlayerRemoving"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Player Removing",
		["Description"] = [[
			Runs connected blocks when a player leaves the game.
		]],

		["PreviewDisplay"] = {
			"Outputs to ",
			"!Player",
		},

		["Inputs"] = {
			-- Inputs
		},
		["Outputs"] = {
			-- Outputs
			"Player",
		},
	},
	["CharacterAdded"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Character Added",
		["Description"] = [[
			Runs connected blocks when the character of a specified player is spawned.
		]],

		["PreviewDisplay"] = {
			"Character of ",
			"!Player",
			", outputs to ",
			"!Character",
		},

		["Inputs"] = {
			-- Inputs
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"Character",
		},
	},
	["DialogChoiceSelected"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Dialog Choice Selected",
		["Description"] = [[
			Runs connected blocks when a dialogchoice of a dialog is selected.
		]],

		["PreviewDisplay"] = {
			"Choice selected from ",
			"!Dialog",
		},

		["Inputs"] = {
			-- Inputs
			["Dialog"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Dialog"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"Player",
			"Choice"
		},
	},
	["Chatted"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Chatted",
		["Description"] = [[
			Runs connected blocks when a player chats.
			
			Be warned, the filtered result may be different than what appears in chat.
		]],

		["PreviewDisplay"] = {
			"!Player",
			" chatted",
		},

		["Inputs"] = {
			-- Inputs
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"Message",
		},
	},
	["ChattedSpecificMessage"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Chatted Specific Message",
		["Description"] = [[
			Runs connected blocks when a player says a specific thing.
		]],

		["PreviewDisplay"] = {
			"When ",
			"!Player",
			" says ",
			"!Message"
		},

		["Inputs"] = {
			-- Inputs
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
			["Message"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["HumanoidDied"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Humanoid Died",
		["Description"] = [[
			Runs connected blocks when a humanoid dies.
		]],

		["PreviewDisplay"] = {
			"!Humanoid"
		},

		["Inputs"] = {
			-- Inputs
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"},
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["HumanoidFreeFalling"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Humanoid Free Falling",
		["Description"] = [[
			Runs connected blocks when a humanoid starts or stops free falling. 
			The active output tells whether it's starting or stopping.
		]],

		["PreviewDisplay"] = {
			"!Humanoid"
		},

		["Inputs"] = {
			-- Inputs
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"Active"
		},
	},
	["HumanoidJumping"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Humanoid Jumping",
		["Description"] = [[
			Runs connected blocks when a humanoid starts or stops jumping. 
			The active output tells whether it's starting or stopping.
		]],

		["PreviewDisplay"] = {
			"!Humanoid"
		},

		["Inputs"] = {
			-- Inputs
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"Active"
		},
	},
	["HumanoidRunning"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Humanoid Running",
		["Description"] = [[
			Runs connected blocks when the speed at which a humanoid is running changes.
		]],

		["PreviewDisplay"] = {
			"!Humanoid"
		},

		["Inputs"] = {
			-- Inputs
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"Speed"
		},
	},
	["HumanoidSeated"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Humanoid Seated",
		["Description"] = [[
			Runs connected blocks when a humanoid either sits in a seat or gets up.
			The active output tells whether they are sitting down or getting up.
		]],

		["PreviewDisplay"] = {
			"!Humanoid"
		},

		["Inputs"] = {
			-- Inputs
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"Active",
			"Seat"
		},
	},
	["HumanoidStateChanged"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Humanoid State Changed",
		["Description"] = [[
			Runs connected blocks when a humanoid changes state.
		]],

		["PreviewDisplay"] = {
			"!Humanoid"
		},

		["Inputs"] = {
			-- Inputs
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"PreviousState",
			"NewState"
		},
	},
	["TeleportPlayerToPosition"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Teleport Player To Position",
		["Description"] = [[
			Moves a player to a point.
		]],

		["PreviewDisplay"] = {
			"Teleports ",
			"!Player",
			" to ",
			"!Position",
			" with rotation of ",
			"!Rotation",
		},

		["Inputs"] = {
			-- Inputs
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Model", "Player"},
			},
			["Position"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
			["Rotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 3,
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["SetCameraPositionLocal"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Set Camera Position",
		["Description"] = [[
			Sets the position of the camera.
			
			For this to work, you must also set the CameraType property of the camera to scriptable!
		]],

		["PreviewDisplay"] = {
			"Sets camera position to ",
			"!Position",
			" with rotation of ",
			"!Rotation",
		},

		["Inputs"] = {
			-- Inputs
			["Position"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["Rotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GetCameraPositionLocal"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Get Camera Position",
		["Description"] = [[
			Gets the position of the camera.
		]],

		["PreviewDisplay"] = {
			"Output position to ",
			"!Position",
			", rotation to ",
			"!Rotation",
		},

		["Inputs"] = {
			-- Inputs
		},
		["Outputs"] = {
			-- Outputs
			"Position",
			"Rotation"
		},
	},
	["SetMouseIconLocal"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Set Mouse Icon",
		["Description"] = [[
			Sets the image for the mouse cursor.
		]],

		["PreviewDisplay"] = {
			"Sets mouse icon to ",
			"!Icon",
		},

		["Inputs"] = {
			-- Inputs
			["Icon"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GetPlayerFromCharacter"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Player From Character",
		["Description"] = [[
			Takes a character from workspace and returns the player object inside of the players service.
		]],

		["PreviewDisplay"] = {
			"Outputs ",
			"!Player",
			" From ",
			"!Character"
		},

		["Inputs"] = {
			-- Inputs
			["Character"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Model"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"Player",
		},
	},
	["GetNameFromUserIdAsync"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Name from User Id",
		["Description"] = [[
			Takes a User Id and returns a UserName
		]],

		["PreviewDisplay"] = {
			"Outputs ",
			"!Username",
			" From ",
			"!UserId"
		},

		["Inputs"] = {
			-- Inputs
			["UserId"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Username",
		},
	},
	["GetUserIdFromNameAsync"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get User Id from Name",
		["Description"] = [[
			Takes a Username and returns a User Id
		]],

		["PreviewDisplay"] = {
			"Outputs ",
			"!UserId",
			" From ",
			"!Username"
		},

		["Inputs"] = {
			-- Inputs
			["Username"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			}
		},
		["Outputs"] = {
			-- Outputs
			"UserId",
		},
	},
	["MutePlayer"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Mute Player",
		["Description"] = [[
			Mutes a player
		]],

		["PreviewDisplay"] = {
			"Mutes ",
			"!Player"
		},

		["Inputs"] = {
			-- Inputs
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
			["Mute"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 2,
				["DefaultValue"] = true
			}
		},
		["Outputs"] = {
			--Outputs
		}
	},
	["BodyPositionReachedTarget"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Body Position Reached Target",
		["Description"] = [[
			Runs connected blocks when a specific body position reaches the desired position within .1 studs. Once fired this event will not fire again until Position is updated.
		]],

		["PreviewDisplay"] = {
			"Execute when ",
			"!BodyPosition",
			" reaches target position",
		},

		["Inputs"] = {
			-- Inputs
			["BodyPosition"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BodyPosition"},
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["PartTouched"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Part Touched",
		["Description"] = [[
			Runs connected blocks when a specified part is touched by another part.
		]],

		["PreviewDisplay"] = {
			"Execute when ",
			"!Part",
			" is touched, output hit to ",
			"!otherPart",
		},

		["Inputs"] = {
			-- Inputs
			["Part"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"otherPart",
		},
	},
	["PartTouchEnded"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Part Touch Ended",
		["Description"] = [[
			Runs connected blocks when a specified part stops touching another part.
		]],

		["PreviewDisplay"] = {
			"Execute when ",
			"!Part",
			" touch ended, output hit to ",
			"!otherPart",
		},

		["Inputs"] = {
			-- Inputs
			["Part"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"otherPart",
		},
	},
	["ExplosionHit"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Explosion Hit",
		["Description"] = [[
			Runs connected blocks when an explosion hits a part.
		]],

		["PreviewDisplay"] = {
			"Execute when ",
			"!Explosion",
			" hits a part",
		},

		["Inputs"] = {
			-- Inputs
			["Explosion"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Explosion"},
			}
		},
		["Outputs"] = {
			-- Outputs
			"Part",
			"Distance"
		},
	},
	["ChildAdded"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Child Added",
		["Description"] = [[
			Runs connected blocks when a child is added to an object.
		]],

		["PreviewDisplay"] = {
			"Execute when child is added to ",
			"!Object",
			", output child to ",
			"!Child",
		},

		["Inputs"] = {
			-- Inputs
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Child",
		},
	},
	["ChildRemoved"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Child Removed",
		["Description"] = [[
			Runs connected blocks when a child is removed from an object.
		]],

		["PreviewDisplay"] = {
			"Execute when child is removed from ",
			"!Object",
			", output child to ",
			"!Child",
		},

		["Inputs"] = {
			-- Inputs
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Child",
		},
	},
	["DescendantAdded"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Descendant Added",
		["Description"] = [[
			Runs connected blocks when a descendant is added to an object.
		]],

		["PreviewDisplay"] = {
			"Execute when descendant is added to ",
			"!Object",
			", output descendant to ",
			"!Descendant",
		},

		["Inputs"] = {
			-- Inputs
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Descendant",
		},
	},
	["DescendantRemoving"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Descendant Removing",
		["Description"] = [[
			Runs connected blocks when a descendant is removed from an object.
		]],

		["PreviewDisplay"] = {
			"Execute when descendant is removed from ",
			"!Object",
			", output descendant to ",
			"!Descendant",
		},

		["Inputs"] = {
			-- Inputs
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Descendant",
		},
	},
	["PropertyChanged"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Property Changed",
		["Description"] = [[
			Runs connected blocks when a specific property of an object is changed.
		]],

		["PreviewDisplay"] = {
			"Execute when ",
			"!Property",
			" of ",
			"!Object",
			" is changed"
		},

		["Inputs"] = {
			-- Inputs
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["Property"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			}
		},
		["Outputs"] = {
			-- Outputs
			"NewValue",
		},
	},
	["AnyPropertyChanged"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Any Property Changed",
		["Description"] = [[
			Runs connected blocks when any property of an object is changed.
		]],

		["PreviewDisplay"] = {
			"Execute when ",
			"!Object",
			" is changed",
		},

		["Inputs"] = {
			-- Inputs
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Property",
			"NewValue",
		},
	},
	["ToolEquipped"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Tool Equipped",
		["Description"] = [[
			Runs connected blocks when the specified tool is equipped.
		]],

		["PreviewDisplay"] = {
			"!Tool"
		},

		["Inputs"] = {
			-- Inputs
			["Tool"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Tool"},
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["ToolUnequipped"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Tool Unequipped",
		["Description"] = [[
			Runs connected blocks when the specified tool is unequipped.
		]],

		["PreviewDisplay"] = {
			"!Tool"
		},

		["Inputs"] = {
			-- Inputs
			["Tool"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Tool"},
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["ToolActivated"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Tool Activated",
		["Description"] = [[
			Runs connected blocks when the player clicks while holding the specified tool if the enabled property of the tool is true.
		]],

		["PreviewDisplay"] = {
			"!Tool"
		},

		["Inputs"] = {
			-- Inputs
			["Tool"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Tool"},
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["ToolDeactivated"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Tool Deactivated",
		["Description"] = [[
			Runs connected blocks when the player stops clicking while holding the specified tool if the enabled property of the tool is true.
		]],

		["PreviewDisplay"] = {
			"!Tool"
		},

		["Inputs"] = {
			-- Inputs
			["Tool"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Tool"},
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["ActivateTool"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Activate Tool",
		["Description"] = [[
			Activates a tool
		]],

		["PreviewDisplay"] = {
			"Activate ",
			"!Tool"
		},

		["Inputs"] = {
			-- Inputs
			["Tool"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Tool"},
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},

	-- Misc
	["AND"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "AND Gate",
		["Description"] = [[
			AND Gate.
			]],

		["PreviewDisplay"] = {
			"Returns true if both ",
			"!A",
			" and ",
			"!B",
			" are true."
		},

		["Inputs"] = {
			-- Inputs
			["A"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 1,
			},
			["B"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["OR"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "OR Gate",
		["Description"] = [[
			OR Gate.
			]],

		["PreviewDisplay"] = {
			"Returns true if either ",
			"!A",
			" or ",
			"!B",
			" are true."
		},

		["Inputs"] = {
			-- Inputs
			["A"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 1,
			},
			["B"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["NOT"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "NOT Gate",
		["Description"] = [[
			Inverter Gate.
			]],

		["PreviewDisplay"] = {
			"Inverts ",
			"!A",
		},

		["Inputs"] = {
			-- Inputs
			["A"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Print"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Print",
		["Description"] = [[
			Prints text to the output window.
		]],

		["PreviewDisplay"] = {
			"!Text",
		},

		["Inputs"] = {
			-- Inputs
			["Text"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Any"},
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["DumpMemory"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Dump Memory",
		["Description"] = [[
			Prints the scripts entire memory table. Useful for advanced debugging.
		]],

		["PreviewDisplay"] = {

		},

		["Inputs"] = {
			-- Inputs
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["Warn"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Warn",
		["Description"] = [[
			Prints text to the output window but now it's orange.
		]],

		["PreviewDisplay"] = {
			"!Text",
		},

		["Inputs"] = {
			-- Inputs
			["Text"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Any"},
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["TypeOf"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Type Of",
		["Description"] = [[
			Returns the type of a variable.
		]],

		["PreviewDisplay"] = {
			"!Variable",
		},

		["Inputs"] = {
			-- Inputs
			["Variable"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 1,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Type"
		},
	},
	["SetVariable1"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Set Variable",
		["Description"] = [[
			Sets a variable.
		]],

		["PreviewDisplay"] = {
			"!VariableName",
			" to ",
			"!Value",
		},

		["Inputs"] = {
			["Value"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"VariableName"
		},
	},
	["If"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "If",
		["Description"] = [[
			Runs connected blocks if the condition given is true.
		]],

		["PreviewDisplay"] = {
			"!Value 1",
			" ",
			"!ComparisonType",
			" ",
			"!Value 2"
		},

		["Inputs"] = {
			["Value 1"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 1,
			},
			["ComparisonType"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"==", "~=", ">", "<", "<=", ">="},
				["ListOrder"] = 2,
			},
			["Value 2"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["SaveVariable"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Save Variable",
		["Description"] = [[
			Saves a variable to a key. This variable can be accessed across servers with the Load Variable block if the same key is given.
			The success output returns true or false based on whether or not it successfully saves.

			This block may only be used 5 + (5 * number of players) times per minute.
		]],

		["PreviewDisplay"] = {
			"Save ",
			"!Value",
			" to ",
			"!Key"
		},

		["Inputs"] = {
			["Value"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 1,
			},
			["Key"] = {
				["VariableType"] = "String",
				["AllowedTypes"] = {"Any"},
				["ListOrder"] = 2,
			},
			["Shared"] = {
				["VariableType"] = "Bool",
				["DefaultValue"] = false,
				["ListOrder"] = 3
			},
		},
		["Outputs"] = {
			-- Outputs
			"Success"
		},
	},
	["LoadVariable"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Load Variable",
		["Description"] = [[
			Loads the variable stored to a key.
			
			The success output returns true or false based on whether or not it successfully loads.

			Loading blocks may only be used 5 + (5 * number of players) times per minute.
		]],

		["PreviewDisplay"] = {
			"Load ",
			"!Key"
		},

		["Inputs"] = {
			["Key"] = {
				["VariableType"] = "String",
				["AllowedTypes"] = {"Any"},
				["ListOrder"] = 1,
			},
			["Shared"] = {
				["VariableType"] = "Bool",
				["DefaultValue"] = false,
				["ListOrder"] = 2
			},
		},
		["Outputs"] = {
			-- Outputs
			"Success",
			"LoadedData",
		},
	},
	["SaveInstance"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Save Instance",
		["Description"] = [[
			Saves a model to a key. This model can be accessed across servers with the Load Instance block if the same key is given.
			The success output returns true or false based on whether or not it successfully saves.

			This block may only be used 5 + (5 * number of players) times per minute.
		]],

		["PreviewDisplay"] = {
			"Save ",
			"!Model",
			" to ",
			"!Key"
		},

		["Inputs"] = {
			["Model"] = {
				["VariableType"] = "Object",
				["AllowedTypes"] = {"Object", "nil"},
				["ListOrder"] = 1,
			},
			["Key"] = {
				["VariableType"] = "String",
				["AllowedTypes"] = {"Any"},
				["ListOrder"] = 2,
			},
			["Shared"] = {
				["VariableType"] = "Bool",
				["DefaultValue"] = false,
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Success"
		},
	},
	["LoadInstance"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Load Instance",
		["Description"] = [[
			Loads the model stored to a key.
			
			The success output returns true or false based on whether or not it successfully loads.

			Loading blocks may only be used 5 + (5 * number of players) times per minute.
		]],

		["PreviewDisplay"] = {
			"Load ",
			"!Key"
		},

		["Inputs"] = {
			["Key"] = {
				["VariableType"] = "String",
				["AllowedTypes"] = {"Any"},
				["ListOrder"] = 1,
			},
			["Parent"] = {
				["VariableType"] = "Object",
				["AllowedTypes"] = {"Object", "nil"},
				["ListOrder"] = 2,
			},
			["Shared"] = {
				["VariableType"] = "Bool",
				["DefaultValue"] = false,
				["ListOrder"] = 3,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Success",
			"LoadedModel",
		},
	},
	["InsertModel"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Insert Model",
		["Description"] = [[
			Loads the model from its retrostudio id
			
			The success output returns true or false based on whether or not it successfully loads.
			If success is true and LoadedModel is nil then there was no model at that id.

			Loading blocks may only be used 5 + (5 * number of players) times per minute.
		]],

		["PreviewDisplay"] = {
			"Load ",
			"!ID",
			", parent to ",
			"!Parent"
		},

		["Inputs"] = {
			["ID"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["Parent"] = {
				["VariableType"] = "Object",
				["AllowedTypes"] = {"Object", "nil"},
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Success",
			"LoadedModel",
		},
	},
	["ReloadPlace"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Reload Place",
		["Description"] = [[
			Reloads the place (Does not work in Studio), same function as the '!reloadplace' command.
		]],

		["PreviewDisplay"] = {
			"Reload place"
		},

		["Inputs"] = {

		},
		["Outputs"] = {

		}
	},
	["InsertRetrostudioAvatar"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Insert RetroStudio Avatar",
		["Description"] = [[
			Inserts a player's RetroStudio Avatar.
		]],

		["PreviewDisplay"] = {
			"Insert avatar of ",
			"!ID",
		},

		["Inputs"] = {
			["ID"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["CFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			"Model"
		}
	},
	["CombineStringWithNumber"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Combine String With Number",
		["Description"] = [[
			Gives a string that is the inputted string followed by the inputted number.
		]],

		["PreviewDisplay"] = {
			"!String",
			" + ",
			"!Number",
		},

		["Inputs"] = {
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["Number"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Combined",
		},
	},
	["JsonEncode"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Json Encode",
		["Description"] = [[
			Encodes a table to JSON
		]],

		["PreviewDisplay"] = {
			"Encodes ",
			"!Table",
			" to JSON",
		},

		["Inputs"] = {
			["Table"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Any"}
			},
		},
		["Outputs"] = {
			-- Outputs
			"JSON",
		},
	},
	["JsonDecode"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Json Decode",
		["Description"] = [[
			Decodes JSON to a lua table
		]],

		["PreviewDisplay"] = {
			"Decodes ",
			"!JSON",
			" to a lua table",
		},

		["Inputs"] = {
			["JSON"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1
			},
		},
		["Outputs"] = {
			-- Outputs
			"Table",
		},
	},
	["CombineNumberWithString"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Combine Number With String",
		["Description"] = [[
			Gives a string that is the inputted number followed by the inputted string.
		]],

		["PreviewDisplay"] = {
			"!Number",
			" + ",
			"!String",
		},

		["Inputs"] = {
			["Number"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Combined",
		},
	},
	["GetLength"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Length Of A String",
		["Description"] = [[
Returns the number of characters in an inputted string.
		]],

		["PreviewDisplay"] = {
			"Length of ",
			"!String"
		},

		["Inputs"] = {
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1
			}
		},
		["Outputs"] = {
			"Length"
		}
	},
	["ToNumber"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "To Number",
		["Description"] = [[
			Converts a string to a number.
		]],

		["PreviewDisplay"] = {
			"!String",
		},

		["Inputs"] = {
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Number",
		},
	},
	["ToString"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "To String",
		["Description"] = [[
			Converts a number to string.
		]],

		["PreviewDisplay"] = {
			"!Number",
		},

		["Inputs"] = {
			["Number"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"String",
		},
	},
	["ToStringAny"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "To String",
		["Description"] = [[
			Converts any datatype to a string.
		]],

		["PreviewDisplay"] = {
			"!Input",
		},

		["Inputs"] = {
			["Input"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"String",
		},
	},
	["CreateTable"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Create Table",
		["Description"] = [[
			Creates an empty table and stores it to the variable given.
		]],

		["PreviewDisplay"] = {
			"!TableVariable"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"TableVariable"
		},
	},
	["GetTableValue"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Table Value",
		["Description"] = [[
			Gets the value of a table at a specific key.
		]],

		["PreviewDisplay"] = {
			"!Key",
			" of ",
			"!Table",
		},

		["Inputs"] = {
			["Table"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Any"}
			},
			["Key"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Value",
		},
	},
	["SetTableValue"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Set Table Value",
		["Description"] = [[
			Sets the value of a table at a specific key.
		]],

		["PreviewDisplay"] = {
			"!Key",
			" of ",
			"!Table",
			" to ",
			"!Value"
		},

		["Inputs"] = {
			["Table"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 1,
			},
			["Key"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 2,
			},
			["Value"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["TableAppend"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Table Append",
		["Description"] = [[
			Places a value at the end of a table.
			
			This will only work if all of the tables keys are integers.
		]],

		["PreviewDisplay"] = {
			"!Value",
			" in ",
			"!Table"
		},

		["Inputs"] = {
			["Table"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 1,
			},
			["Value"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["TableInsert"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Table Insert",
		["Description"] = [[
			Places a value into a table at the specified position.
			
			This will only work if all of the tables keys are integers.
		]],

		["PreviewDisplay"] = {
			"!Value",
			" at ",
			"!Position",
			" in ",
			"!Table"
		},

		["Inputs"] = {
			["Table"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 1,
			},
			["Position"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
			["Value"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["TableFind"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Find in Table",
		["Description"] = [[
			Finds the first occurance of a value in a table and outputs the key.
			
			If the value is not found within the table, nil is outputted.
			
			An optional init value can be supplied, which will cause the search to start at that key.
		]],

		["PreviewDisplay"] = {
			"!Value",
			" in ",
			"!Table"
		},

		["Inputs"] = {
			["Table"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 1,
			},
			["Value"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 2,
			},
			["Init"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
				["DefaultValue"] = 1,
			},
		},
		["Outputs"] = {
			"Key"
		},
	},
	["TableRemove"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Table Remove",
		["Description"] = [[
			Removes a value from a table at the specified position.
			
			This will only work if all of the tables keys are integers.
		]],

		["PreviewDisplay"] = {
			"!Position",
			" in ",
			"!Table"
		},

		["Inputs"] = {
			["Table"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 1,
			},
			["Position"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["GetTableLength"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Table Length",
		["Description"] = [[
			Gives the length of a table.
			
			This will only work if all of the tables keys are integers.
		]],

		["PreviewDisplay"] = {
			"!Table"
		},

		["Inputs"] = {
			["Table"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Length",
		},
	},
	["SortTable"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Sort Table",
		["Description"] = [[
			Sorts a table based on each value. The table should be formatted like an array.
		]],

		["PreviewDisplay"] = {
			"!Table",
			" from ",
			"!Order"
		},

		["Inputs"] = {
			["Table"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 1,
			},
			["Order"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"Low to High", "High to Low"},
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["WhileLoop3"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "While Loop",
		["Description"] = [[
			Repeatedly runs the connected blocks until the given condition is false.
		]],

		["PreviewDisplay"] = {
			"Loop while ",
			"!Value 1",
			" ",
			"!ComparisonType",
			" ",
			"!Value 2",
		},

		["Inputs"] = {
			["Value 1"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 1,
			},
			["ComparisonType"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"==", "~=", ">", "<", "<=", ">="},
				["ListOrder"] = 2,
			},
			["Value 2"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["WhileLoop2"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "While Loop",
		["Description"] = [[
			Repeatedly runs the connected blocks until the given condition is false.
		]],

		["PreviewDisplay"] = {
			"Loop while ",
			"!Value 1",
			" ",
			"!ComparisonType",
			" ",
			"!Value 2",
		},

		["Inputs"] = {
			["Value 1"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 1,
			},
			["ComparisonType"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"==", "~=", ">", "<", "<=", ">="},
				["ListOrder"] = 2,
			},
			["Value 2"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["Heartbeat"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Heartbeat",
		["Description"] = [[
			Runs the connected blocks every frame after the physics simulation
		]],

		["PreviewDisplay"] = {
			"Heartbeat"
		},

		["Inputs"] = {
		},
		["Outputs"] = {
			"DeltaTime"
			-- Outputs
		},
	},
	["ForLoop2"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "For Loop",
		["Description"] = [[
			Runs the connected blocks until Initial is equal to Maximum, while increasing Initial by Increment each time.
		]],

		["PreviewDisplay"] = {
			"Start at ",
			"!Initial",
			" and increment by ",
			"!Increment",
			" until it equals ",
			"!Maximum",
		},

		["Inputs"] = {
			["Initial"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
				["DefaultValue"] = 1,
			},
			["Increment"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["DefaultValue"] = 1,
			},
			["Maximum"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
				["DefaultValue"] = 10,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Place",
		},
	},
	["BreakLoop"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Break Loop",
		["Description"] = [[
			Cancels the loop that this block is inside of.
		]],

		["PreviewDisplay"] = {
			""
		},

		["Inputs"] = {

		},
		["Outputs"] = {

		},
	},
	["ContinueLoop"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Continue Loop",
		["Description"] = [[
			Skips ahead to the next iteration of the loop that this block is apart of.
		]],

		["PreviewDisplay"] = {
			""
		},

		["Inputs"] = {

		},
		["Outputs"] = {

		},
	},
	["ForLoop"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "For Loop",
		["Description"] = [[
			Runs the connected blocks until Initial is equal to Maximum, while increasing Initial by Increment each time.
		]],

		["PreviewDisplay"] = {
			"Start at ",
			"!Initial",
			" and increment by ",
			"!Increment",
			" until it equals ",
			"!Maximum",
		},

		["Inputs"] = {
			["Initial"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
				["DefaultValue"] = 1,
			},
			["Increment"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["DefaultValue"] = 1,
			},
			["Maximum"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
				["DefaultValue"] = 10,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Place",
		},
	},
	["LoopThroughTable"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Loop Through Table",
		["Description"] = [[
			Runs the connected blocks once for each value in a table.
		]],

		["PreviewDisplay"] = {
			"!Table"
		},

		["Inputs"] = {
			["Table"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Index",
			"Value",
		},
	},
	["LoopThroughChildren"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Loop Through Children",
		["Description"] = [[
			Runs the connected blocks once for each child of an object.
		]],

		["PreviewDisplay"] = {
			"For each child of ",
			"!Object"
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Child",
		},
	},
	["LoopThroughDescendants"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Loop Through Descendants",
		["Description"] = [[
			Runs the connected blocks once for each descendant of an object.
		]],

		["PreviewDisplay"] = {
			"For each descendant of ",
			"!Object"
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Descendant",
		},
	},
	["Comment"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Comment",
		["Description"] = [[
			Does nothing.
		]],

		["PreviewDisplay"] = {
			"!Comment"
		},

		["Inputs"] = {
			["Comment"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["DoNotRun"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Do Not Run",
		["Description"] = [[
			Does nothing and does not run its children blocks.
			Useful for temporarily disabling code, or to be used with ExecuteBlock.
		]],

		["PreviewDisplay"] = {

		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["ExecuteBlock"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = true, -- Lazy hack to get around issue with it clearing memory of environments before it should because it doesn't
		-- Check if children of the block executed are events

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Execute Block",
		["Description"] = [[
			Runs the block with the given name.
		]],

		["PreviewDisplay"] = {
			"!Name",
		},

		["Inputs"] = {
			["Name"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["RenderStepped"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Render Stepped",
		["Description"] = [[
			Runs code every frame.
			
			DeltaTime is the time in seconds since the last frame.
		]],

		["PreviewDisplay"] = {

		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"deltaTime"
		},
	},
	["DefineFunction"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Define Function",
		["Description"] = [[
			Defines a function that can be called with the Execute Function block.
		]],

		["PreviewDisplay"] = {
			"!Function"
		},

		["Inputs"] = {
		},
		["Outputs"] = {
			"Function",
			"TUPLE_Parameters"
		},
	},

	["FunctionReturn"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Function Return",
		["Description"] = [[
			Ends execution of a function, and returns data to the execute function block.
		]],

		["PreviewDisplay"] = {
			"",
		},

		["Inputs"] = {
			["Returns"] = {
				["VariableType"] = "Tuple",
				["ListOrder"] = 1,
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},

	["ExecuteFunction"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Execute Function",
		["Description"] = [[
			Executes a function. Connected blocks are ran after the function completes execution.
		]],

		["PreviewDisplay"] = {
			"!Function"
		},

		["Inputs"] = {
			["Function"] = {
				["VariableType"] = "Function",
				["ListOrder"] = 1,
				["DefaultValue"] = "",
			},
			["Parameters"] = {
				["VariableType"] = "Tuple",
				["ListOrder"] = 2,
			}
		},
		["Outputs"] = {
			-- Outputs
			"TUPLE_ReturnedValues"
		},
	},
	["Spawn"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Spawn",
		["Description"] = [[
			Executes a function. Connected and adjacent blocks are ran immediately, rather than waiting for the function to finish.
		]],

		["PreviewDisplay"] = {
			"!Function"
		},

		["Inputs"] = {
			["Function"] = {
				["VariableType"] = "Function",
				["ListOrder"] = 1,
				["DefaultValue"] = "",
			},
			["Parameters"] = {
				["VariableType"] = "Tuple",
				["ListOrder"] = 2,
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},




	["BindToClose"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Bind To Close",
		["Description"] = [[
			Runs code prior to the server shutting down.
		]],

		["PreviewDisplay"] = {

		},

		["Inputs"] = {

		},
		["Outputs"] = {

		},
	},
	["GetRobloxVersion"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Roblox Version",
		["Description"] = [[
			Returns the time era of this place.
		]],

		["PreviewDisplay"] = {
			"Set to ",
			"!Answer"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"Answer",
		},
	},
	["IsStudio"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Is Studio",
		["Description"] = [[
			Returns a bool based on whether or not this script is running in studio.
		]],

		["PreviewDisplay"] = {
			"Set to ",
			"!Answer"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"Answer",
		},
	},
	["IsGameLoaded"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Is Game Loaded",
		["Description"] = [[
			Returns a bool based on whether or not the game has loaded.
		]],

		["PreviewDisplay"] = {
			"Set to ",
			"!Answer"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"Answer",
		},
	},
	["OsTime"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Os Time",
		["Description"] = [[
			Returns the real world time in seconds.
		]],

		["PreviewDisplay"] = {
			"Returns ",
			"!Answer"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"Answer",
		},
	},
	["GetServerTimeNow"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Server Time Now",
		["Description"] = [[
			Returns the server epoch time in seconds.
		]],

		["PreviewDisplay"] = {
			"Returns ",
			"!Answer"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"Answer",
		},
	},
	["OsClock"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Os Clock",
		["Description"] = [[
			Returns the amount of CPU time used in seconds. This is high precision and can be used for benchmarking.
		]],

		["PreviewDisplay"] = {
			"Set to ",
			"!Answer"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"Answer",
		},
	},
	["OsDate"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Os Date",
		["Description"] = [[
			Returns date/time information based on the given time, Timezone must either be '*t' (local time) or '!*t' (UTC time | Default)
		]],

		["PreviewDisplay"] = {
			"Returns ",
			"!DateTable",
			" using time from ",
			"!Time",
		},

		["Inputs"] = {
			["Time"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1
			},
			["Timezone"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2
			}
		},
		["Outputs"] = {
			-- Outputs
			"DateTable",
		},
	},
	["AddDebrisItem"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Add Item To Debris",
		["Description"] = [[
			Adds an item to debris removing it after the inputted time
		]],

		["PreviewDisplay"] = {
			"Remove ",
			"!Object",
			" after ",
			"!Time",
			" seconds"
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Instance"},
			},
			["Time"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["DefaultValue"] = 0,
				["AllowedTypes"] = {"Any"}, --Checked manually so we can make it wait 0.03 if not a number (prevents crash with while true do)
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["Wait"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Wait",
		["Description"] = [[
			Waits a certain amount of time and then runs the connected blocks.
		]],

		["PreviewDisplay"] = {
			"!Time",
			" seconds"
		},

		["Inputs"] = {
			["Time"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
				["DefaultValue"] = 1,
				["AllowedTypes"] = {"Any"}, --Checked manually so we can make it wait 0.03 if not a number (prevents crash with while true do)
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["ConstructVector3"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Construct Vector3",
		["Description"] = [[
			Creates a Vector3 variable from the 3 given numbers.
		]],

		["PreviewDisplay"] = {
			"!X",
			", ",
			"!Y",
			", ",
			"!Z",
		},

		["Inputs"] = {
			["X"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["Y"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
			["Z"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Vector3"
		},
	},
	["SplitVector3"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Split Vector3",
		["Description"] = [[
			Splits a Vector3 value into its components.
		]],

		["PreviewDisplay"] = {
			"!Vector3",
		},

		["Inputs"] = {
			["Vector3"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"X",
			"Y",
			"Z",
		},
	},
	["ConstructVector2"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Construct Vector2",
		["Description"] = [[
			Creates a Vector2 variable from the 2 given numbers.
		]],

		["PreviewDisplay"] = {
			"!X",
			", ",
			"!Y",
		},

		["Inputs"] = {
			["X"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["Y"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Vector2"
		},
	},
	["ConstructNumberRange"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Construct NumberRange",
		["Description"] = [[
			Creates a NumberRange variable from the 2 given numbers.
		]],

		["PreviewDisplay"] = {
			"!Min",
			", ",
			"!Max",
		},

		["Inputs"] = {
			["Min"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["Max"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"NumberRange"
		},
	},
	["SplitVector2"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Split Vector2",
		["Description"] = [[
			Splits a Vector2 value into its components.
		]],

		["PreviewDisplay"] = {
			"!Vector2",
		},

		["Inputs"] = {
			["Vector2"] = {
				["VariableType"] = "Vector2",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"X",
			"Y",
		},
	},
	["SplitNumberRange"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Split NumberRange",
		["Description"] = [[
			Splits a NumberRange value into its components.
		]],

		["PreviewDisplay"] = {
			"!NumberRange",
		},

		["Inputs"] = {
			["NumberRange"] = {
				["VariableType"] = "NumberRange",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Min",
			"Max",
		},
	},
	["NormalizeVector3"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Normalize Vector3",
		["Description"] = [[
			Takes a Vector3 value and gives a modified version of it that has the same direction but a total distance of 1.
		]],

		["PreviewDisplay"] = {
			"!Vector3",
		},

		["Inputs"] = {
			["Vector3"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["SplitCFrame"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Split CFrame",
		["Description"] = [[
			Splits a CFrame value into its position and rotation.
		]],

		["PreviewDisplay"] = {
			"!CFrame",
		},

		["Inputs"] = {
			["CFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Position",
			"Rotation",
		},
	},
	["ConstructCFrame"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Construct CFrame",
		["Description"] = [[
			Constructs a CFrame value from a position and rotation.
		]],

		["PreviewDisplay"] = {
			"!Position",
			" and ",
			"!Rotation"
		},

		["Inputs"] = {
			["Position"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["Rotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"CFrame",
		},
	},
	["DistanceBetweenPoints"] = {
		["Aliases"] = {"Magnitude"},
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Distance Between Points",
		["Description"] = [[
			Gives the distance between 2 Vector3 values.
		]],

		["PreviewDisplay"] = {
			"!Point 1",
			" and ",
			"!Point 2",
		},

		["Inputs"] = {
			["Point 1"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["Point 2"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Distance",
		},
	},
	["RotationBetweenPoints"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Rotation Between Points",
		["Description"] = [[
			Gives the orientation needed to make a part at Point 1 face towards Point 2
		]],

		["PreviewDisplay"] = {
			"!Point 1",
			" and ",
			"!Point 2",
		},

		["Inputs"] = {
			["Point 1"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["Point 2"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"RotationVector3",
		},
	},
	["Lerp1"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Lerp",
		["Description"] = [[
			Returns a cframe interpolated between itself and a goal by the given alpha.
		]],

		["PreviewDisplay"] = {
			"!StartCFrame",
			" to ",
			"!GoalCFrame",
			" with alpha ",
			"!Alpha",
		},

		["Inputs"] = {
			["StartCFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 1,
			},
			["GoalCFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 2,
			},
			["Alpha"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["InverseCFrame1"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Inverse CFrame",
		["Description"] = [[
			Returns the inverse of a cframe.
		]],

		["PreviewDisplay"] = {
			"!CFrame"
		},

		["Inputs"] = {
			["CFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["ToObjectSpace1"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "To Object Space",
		["Description"] = [[
			Transforms a cframe to object space.
		]],

		["PreviewDisplay"] = {
			"!CFrame",
			" to object ",
			"!ObjectCFrame",
		},

		["Inputs"] = {
			["CFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 1,
			},
			["ObjectCFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["ToWorldSpace1"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "To World Space",
		["Description"] = [[
			Transforms a cframe to world space.
		]],

		["PreviewDisplay"] = {
			"!CFrame",
			" to world, from object ",
			"!ObjectCFrame",
		},

		["Inputs"] = {
			["CFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 1,
			},
			["ObjectCFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["GetCFrameDirection"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get CFrame Direction",
		["Description"] = [[
			Gives the direction a cframe is facing
		]],

		["PreviewDisplay"] = {
			"!Direction",
			" from ",
			"!CFrame"
		},

		["Inputs"] = {
			["CFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 1,
			},
			["Direction"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"Forward", "Backward", "Left", "Right", "Up", "Down"},
				["ListOrder"] = 2,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Direction",
		},
	},
	["Angles"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "CFrame Angles",
		["Description"] = [[
			Returns a rotated CFrame using angles x, y, & z.
		]],

		["PreviewDisplay"] = {
			"Rotates CFrame",
			" from ",
			"!rx",
			" ",
			"!ry",
			" ",
			"!rz"
		},

		["Inputs"] = {
			["rx"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["ry"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
			["rz"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	--"ToEulerAnglesXYZ",
	--"FromMatrix",
	--"FromAxisAngle"
	["ToEulerAnglesXYZ"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "To Euler Angles XYZ",
		["Description"] = [[
			Returns approximate angles that could be used to generate the CFrame.
		]],

		["PreviewDisplay"] = {
			"Get Euler Angles from ",
			"!CFrame",
		},

		["Inputs"] = {
			["CFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"rx",
			"ry",
			"rz"
		},
	},
	["FromAxisAngle"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "From Axis Angle",
		["Description"] = [[
			Returns a rotated CFrame from a unit Vector3 and a rotation in radians.
		]],

		["PreviewDisplay"] = {
			"Return CFrame from ",
			"!v",
			" and ",
			"!r"
		},

		["Inputs"] = {
			["v"] = {
				["VariableType"] = "number",
				["ListOrder"] = 1,
			},
			["r"] = {
				["VariableType"] = "number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"CFrame"
		},
	},
	["FromMatrix"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "From Matrix",
		["Description"] = [[
			Returns a CFrame from a translation and the columns of a rotation matrix. If vZ is excluded, the third column is calculated as vX:Cross(vY).Unit
		]],

		["PreviewDisplay"] = {
			"Return a CFrame from ",
			"!pos",
			" ",
			"!vX",
			" ",
			"!vY",
			" ",
			"!vZ"
		},

		["Inputs"] = {
			["pos"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["vX"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
			["vY"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 3,
			},
			["vZ"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 4,
			},
		},
		["Outputs"] = {
			-- Outputs
			"CFrame"
		},
	},
	["Vector3Dot"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Vector3 Dot",
		["Description"] = [[
			Gives the dot product of two vectors
		]],

		["PreviewDisplay"] = {
			"!VectorA",
			" and ",
			"!VectorB",
		},

		["Inputs"] = {
			["VectorA"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["VectorB"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Vector3Cross"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Vector3 Cross",
		["Description"] = [[
			Gives the cross product of two vectors
		]],

		["PreviewDisplay"] = {
			"!VectorA",
			" and ",
			"!VectorB",
		},

		["Inputs"] = {
			["VectorA"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["VectorB"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["GetPartDirection"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Part Direction",
		["Description"] = [[
			Gives the direction a part is facing
		]],

		["PreviewDisplay"] = {
			"!Direction",
			" from ",
			"!Part"
		},

		["Inputs"] = {
			["Part"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart"},
			},
			["Direction"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"Forward", "Backward", "Left", "Right", "Up", "Down"},
				["ListOrder"] = 2,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Direction",
		},
	},
	["SplitUDim2"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Split UDim2",
		["Description"] = [[
			Splits a UDim2 value into its components.
		]],

		["PreviewDisplay"] = {
			"!UDim2",
		},

		["Inputs"] = {
			["UDim2"] = {
				["VariableType"] = "UDim2",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"XScale",
			"XOffset",
			"YScale",
			"YOffset",
		},
	},
	["ConstructUDim2"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Construct UDim2",
		["Description"] = [[
			Creates a UDim2 value from the given numbers.
		]],

		["PreviewDisplay"] = {
			"!XScale",
			", ",
			"!XOffset",
			", ",
			"!YScale",
			", ",
			"!YOffset"
		},

		["Inputs"] = {
			["XScale"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["XOffset"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
			["YScale"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
			["YOffset"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 4,
			},
		},
		["Outputs"] = {
			-- Outputs
			"UDim2",
		},
	},
	["SplitColor3"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Split Color3",
		["Description"] = [[
			Splits a Color3 value into its components.
		]],

		["PreviewDisplay"] = {
			"!Color3",
		},

		["Inputs"] = {
			["Color3"] = {
				["VariableType"] = "Color3",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"R",
			"G",
			"B",
		},
	},
	["ConstructColor3"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Construct Color3",
		["Description"] = [[
			Creates a Color3 value from the given numbers.
			Inputted numbers must range between 0 and 255.
		]],

		["PreviewDisplay"] = {
			"!R",
			", ",
			"!G",
			", ",
			"!B",
		},

		["Inputs"] = {
			["R"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["G"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
			["B"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Color3",
		},
	},
	["BrickColorToColor3"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "BrickColor To Color3",
		["Description"] = [[
			Converts a BrickColor to a Color3
		]],

		["PreviewDisplay"] = {
			"!BrickColor",
		},

		["Inputs"] = {
			["BrickColor"] = {
				["VariableType"] = "BrickColor",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Color3",
		},
	},
	["Color3ToBrickColor"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Color3 to BrickColor",
		["Description"] = [[
			Converts a Color3 to the closest existing BrickColor
		]],

		["PreviewDisplay"] = {
			"!Color3",
		},

		["Inputs"] = {
			["Color3"] = {
				["VariableType"] = "Color3",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"BrickColor",
		},
	},
	["Color3ToHSV"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Color3 to HSV",
		["Description"] = [[
			Converts a Color3 to HSV values
		]],

		["PreviewDisplay"] = {
			"!Color3",
		},

		["Inputs"] = {
			["Color3"] = {
				["VariableType"] = "Color3",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Hue",
			"Saturation",
			"Value"
		},
	},
	["HSVToColor3"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "HSV To Color3",
		["Description"] = [[
			Converts HSV values to Color3
		]],

		["PreviewDisplay"] = {
			"!Hue",
			", ",
			"!Saturation",
			", ",
			"!Value",
		},

		["Inputs"] = {
			["Hue"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["Saturation"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
			["Value"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Color3"
		},
	},
	["RandomBrickColor"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Random BrickColor",
		["Description"] = [[
			Outputs a random BrickColor.
		]],

		["PreviewDisplay"] = {
			"!BrickColor",
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"BrickColor",
		},
	},

	-- Actions
	["CreateObject"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Create Object",
		["Description"] = [[
			Creates an object.
		]],

		["PreviewDisplay"] = {
			"!ClassName",
		},

		["Inputs"] = {
			["ClassName"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["Parent"] = {
				["AllowedTypes"] = {"Object", "nil"},
				["VariableType"] = "Object",
				["ListOrder"] = 2,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Object",
		},
	},
	["DestroyObject"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Destroy Object",
		["Description"] = [[
			Destroys an object.
		]],

		["PreviewDisplay"] = {
			"!Object",
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["CloneObject"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Clone Object",
		["Description"] = [[
			Clones an object.
		]],

		["PreviewDisplay"] = {
			"!Object",
			", parent to ",
			"!Parent"
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["Parent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 2,
				["AllowedTypes"] = {"Instance", "nil"}
			}
		},
		["Outputs"] = {
			-- Outputs
			"NewObject",
		},
	},
	["IsA"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Is A",
		["Description"] = [[
			Returns true or false based on whether or not an object is of the given class, or a class inherited from it.
		]],

		["PreviewDisplay"] = {
			"!Object",
			" is a ",
			"!Class"
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["Class"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		}
	},
	["TweenObjectProperty"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Tween Object Property",
		["Description"] = [[
			Smoothly transitions a property to another value over a set time.
			
			Connected blocks are ran after the tween is completed.
		]],

		["PreviewDisplay"] = {
			"Tween ",
			"!Property",
			" of ",
			"!Object",
			" to ",
			"!Value",
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Instance"},
			},
			["Property"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
			["Value"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
			["Time"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
			["EasingStyle"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"},
				["ListOrder"] = 4,
			},
			["EasingDirection"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"In", "Out", "InOut"},
				["ListOrder"] = 5,
			},
			["RepeatCount"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 6
			},
			["Reverses"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 7
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["SetObjectProperty"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Set Object Property",
		["Description"] = [[
			Sets a property of an object.
		]],

		["PreviewDisplay"] = {
			"Set ",
			"!Property",
			" of ",
			"!Object",
			" to ",
			"!Value",
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Instance"},
			},
			["Property"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
			["Value"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GetObjectProperty"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Object Property",
		["Description"] = [[
			Returns the property of an object.
		]],

		["PreviewDisplay"] = {
			"Get ",
			"!Property",
			" of ",
			"!Object",
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Object"}
			},
			["Property"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Value",
		},
	},
	["FindFirstChild"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Find First Child",
		["Description"] = [[
			Run the connected blocks only if the given object has a child with the given name.
		]],

		["PreviewDisplay"] = {
			"!ChildName",
			" in ",
			"!Parent",
		},

		["Inputs"] = {
			["Parent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["ChildName"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
			["Recursive"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 3,
			},
			--[[["CanReturnNil"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 4,
			},]]
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["FindFirstChildWhichIsA"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Find First Child Which Is A",
		["Description"] = [[
			Run the connected blocks only if the given object has a child with the given super class.
		]],

		["PreviewDisplay"] = {
			"!ChildClass",
			" in ",
			"!Parent",
		},

		["Inputs"] = {
			["Parent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["ChildClass"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["FindFirstChildOfClass"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Find First Child Of Class",
		["Description"] = [[
			Run the connected blocks only if the given object has a child with the given class, does not support super classes.
		]],

		["PreviewDisplay"] = {
			"!ChildClass",
			" in ",
			"!Parent",
		},

		["Inputs"] = {
			["Parent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["ChildClass"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["GetRandomChild"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Random Child",
		["Description"] = [[
			Returns a random child of an object.
		]],

		["PreviewDisplay"] = {
			"Picks a child of ",
			"!Parent",
			" at random"
		},

		["Inputs"] = {
			["Parent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["GetChildren"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Children",
		["Description"] = [[
			Returns a table of all of an objects children.
		]],

		["PreviewDisplay"] = {
			"List children of ",
			"!Parent"
		},

		["Inputs"] = {
			["Parent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"ChildrenTable",
		},
	},
	["GetDescendants"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Descendants",
		["Description"] = [[
			Returns a table of all of an objects descendants.
		]],

		["PreviewDisplay"] = {
			"List descendants of ",
			"!Parent"
		},

		["Inputs"] = {
			["Parent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"DescendantTable",
		},
	},
	["IsDescendantOf"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Is Descendant Of",
		["Description"] = [[
			Returns a boolean on whether or not the given object is a descendant of another object.
		]],

		["PreviewDisplay"] = {
			"Is ",
			"!Descendant",
			" a descendant of ",
			"!Ancestor"
		},

		["Inputs"] = {
			["Ancestor"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["Descendant"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 2
			}
		},
		["Outputs"] = {
			-- Outputs
			"OutputValue",
		},
	},
	["IsAncestorOf"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Is Ancestor Of",
		["Description"] = [[
			Returns a boolean on whether or not the given object is an ancestor of another object.
		]],

		["PreviewDisplay"] = {
			"Is ",
			"!Ancestor",
			" an ancestor of ",
			"!Descendant"
		},

		["Inputs"] = {
			["Descendant"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["Ancestor"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 2
			}
		},
		["Outputs"] = {
			-- Outputs
			"OutputValue",
		},
	},
	["GetFullName"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Full Name",
		["Description"] = [[
			Returns a string describing the objects's ancestry.
		]],

		["PreviewDisplay"] = {
			"!Object",
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"FullName",
		},
	},
	["IsTouching"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Is Touching",
		["Description"] = [[
			Returns a boolean on whether or not two provided objects are touching
		]],

		["PreviewDisplay"] = {
			"Is ",
			"!Part1",
			" touching ",
			"!Part2"
		},

		["Inputs"] = {
			["Part1"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["Part2"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 2
			}
		},
		["Outputs"] = {
			-- Outputs
			"IsTouching",
		},
	},
	["GetTouchingParts"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Touching Parts",
		["Description"] = [[
			Returns a table of all parts touching an object.
		]],

		["PreviewDisplay"] = {
			"List touching parts of ",
			"!Part"
		},

		["Inputs"] = {
			["Part"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"PartsTable",
		},
	},
	["DisconnectEvent"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Disconnect Event",
		["Description"] = [[
			Disconnects an event. Use the "EventConnection" output of any event block with this.
		]],

		["PreviewDisplay"] = {
			"Disconnect ",
			"!EventConnection"
		},

		["Inputs"] = {
			["EventConnection"] = {
				["VariableType"] = "EventConnection",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["IsConnected"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Is Connected",
		["Description"] = [[
			Check if an event is connected. Use the "EventConnection" output of any event block with this.
		]],

		["PreviewDisplay"] = {
			"Is ",
			"!EventConnection",
			" connected?"
		},

		["Inputs"] = {
			["EventConnection"] = {
				["VariableType"] = "EventConnection",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["GetConnectedParts"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Connected Parts",
		["Description"] = [[
			Returns a table of all parts connected to an object.
		]],

		["PreviewDisplay"] = {
			"List connected parts of ",
			"!Part"
		},

		["Inputs"] = {
			["Part"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"PartsTable",
		},
	},
	["RemoteFireServer"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Fire Remote Event Server",
		["Description"] = [[
			Fires a remote event to the server.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Fire ",
			"!RemoteEvent"
		},

		["Inputs"] = {
			["RemoteEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteEvent"}
			},
			["Parameter1"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 2,
			},
			["Parameter2"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
			["Parameter3"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 4,
			},
			["Parameter4"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 5,
			},
			["Parameter5"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 6,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["RemoteFireClient"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Fire Remote Event Client",
		["Description"] = [[
			Fires a remote event to a client.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Fire ",
			"!RemoteEvent",
			" for ",
			"!Player",
		},

		["Inputs"] = {
			["RemoteEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteEvent"}
			},
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 2,
				["AllowedTypes"] = {"Player"}
			},
			["Parameter1"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
			["Parameter2"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 4,
			},
			["Parameter3"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 5,
			},
			["Parameter4"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 6,
			},
			["Parameter5"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 7,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["RemoteFireAllClients"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Fire Remote Event All Clients",
		["Description"] = [[
			Fires a remote event to all clients.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Fire ",
			"!RemoteEvent"
		},

		["Inputs"] = {
			["RemoteEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteEvent"}
			},
			["Parameter1"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 2,
			},
			["Parameter2"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
			["Parameter3"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 4,
			},
			["Parameter4"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 5,
			},
			["Parameter5"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 6,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["RemoteRecieveServer"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Receive Remote Event",
		["Description"] = [[
			Executes children when a remote event is fired.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Receive ",
			"!RemoteEvent"
		},

		["Inputs"] = {
			["RemoteEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteEvent"}
			},
		},
		["Outputs"] = {
			-- Outputs
			"Player",
			"Parameter1",
			"Parameter2",
			"Parameter3",
			"Parameter4",
			"Parameter5",
		},
	},
	["RemoteRecieveClient"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Receive Remote Event",
		["Description"] = [[
			Executes children when a remote event is fired.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Receive ",
			"!RemoteEvent"
		},

		["Inputs"] = {
			["RemoteEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteEvent"}
			},
		},
		["Outputs"] = {
			-- Outputs
			"Parameter1",
			"Parameter2",
			"Parameter3",
			"Parameter4",
			"Parameter5",
		},
	},
	["BindableFire2"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Fire Bindable Event",
		["Description"] = [[
			Sends a message to another script.
			
			Parameters are optional and can be used to send extra data with the event.
		]],

		["PreviewDisplay"] = {
			"Fire ",
			"!BindableEvent"
		},

		["Inputs"] = {
			["BindableEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BindableEvent"}
			},
			["Parameters"] = {
				["VariableType"] = "Tuple",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["BindableRecieve2"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Receive Bindable Event",
		["Description"] = [[
			Receive a message from another script.
			
			Parameters are optional and can be used to send extra data with the event.
		]],

		["PreviewDisplay"] = {
			"Receive ",
			"!BindableEvent"
		},

		["Inputs"] = {
			["BindableEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BindableEvent"}
			},
		},
		["Outputs"] = {
			-- Outputs
			"TUPLE_Parameters",
		},
	},
	["BindableFunctionInvoke"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Invoke Bindable Function",
		["Description"] = [[
			Sends a message to another script.
			
			Parameters are optional and can be used to send extra data with the event.
		]],

		["PreviewDisplay"] = {
			"Fire ",
			"!BindableFunction"
		},

		["Inputs"] = {
			["BindableFunction"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BindableFunction"}
			},
			["Parameters"] = {
				["VariableType"] = "Tuple",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"TUPLE_Output"
		},
	},
	["BindableFunctionOnInvoke"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Receive Bindable Function",
		["Description"] = [[
			Receive a message from another script.
			
			Parameters are optional and can be used to send extra data to the function.
			
			Requires a return block to function.
		]],

		["PreviewDisplay"] = {
			"Receive ",
			"!BindableFunction"
		},

		["Inputs"] = {
			["BindableFunction"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BindableFunction"}
			},
		},
		["Outputs"] = {
			-- Outputs
			"TUPLE_Parameters",
		},
	},
	["BindableFire"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Fire Bindable Event",
		["Description"] = [[
			Fires a bindable event.
			
			Parameters are optional and can be used to send extra data with the event.
		]],

		["PreviewDisplay"] = {
			"Fire ",
			"!BindableEvent"
		},

		["Inputs"] = {
			["BindableEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BindableEvent"}
			},
			["Parameter1"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 2,
			},
			["Parameter2"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 3,
			},
			["Parameter3"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 4,
			},
			["Parameter4"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 5,
			},
			["Parameter5"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 6,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["BindableRecieve"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Receive Bindable Event",
		["Description"] = [[
			Executes children when a bindable event is fired.
			
			Parameters are optional and can be used to send extra data with the event.
		]],

		["PreviewDisplay"] = {
			"Receive ",
			"!BindableEvent"
		},

		["Inputs"] = {
			["BindableEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BindableEvent"}
			},
		},
		["Outputs"] = {
			-- Outputs
			"Parameter1",
			"Parameter2",
			"Parameter3",
			"Parameter4",
			"Parameter5",
		},
	},
	["WaitForChild"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Wait For Child",
		["Description"] = [[
			Wait until the given object has a child with the given name, and then run the connected blocks.
		]],

		["PreviewDisplay"] = {
			"!ChildName",
			" in ",
			"!Parent",
		},

		["Inputs"] = {
			["Parent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["ChildName"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
			["TimeOut"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
				["DefaultValue"] = 5,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["MakeJoints"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Make Joints",
		["Description"] = [[
			Connects a part, or all the parts in a model, to any parts they are touching that have compatible surfaces.
		]],

		["PreviewDisplay"] = {
			"Make joints for ",
			"!Part",
		},

		["Inputs"] = {
			["Part"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart", "Model"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["BreakJoints"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Break Joints",
		["Description"] = [[
			Removes all of a parts welds.
		]],

		["PreviewDisplay"] = {
			"Break joints for ",
			"!Part",
		},

		["Inputs"] = {
			["Part"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart", "Model"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["MoveModelTo"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Move Model To",
		["Description"] = [[
			Moves a model to the given position.
			
			If the model ends up inside of something, it will teleport ontop of it.
		]],

		["PreviewDisplay"] = {
			"Move ",
			"!Model",
			" to ",
			"!Position"
		},

		["Inputs"] = {
			["Model"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart", "Model"},
			},
			["Position"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["SetModelPrimaryPartCFrame"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Set Model Primary Part CFrame",
		["Description"] = [[
			Moves a model to the given position.
		]],

		["PreviewDisplay"] = {
			"Move ",
			"!Model",
			" to ",
			"!Position",
			" with rotation ",
			"!Rotation",
		},

		["Inputs"] = {
			["Model"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart", "Model"},
			},
			["Position"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
			["Rotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["SetModelPrimaryPartCFrameNew"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Set Model Primary Part CFrame",
		["Description"] = [[
			Moves a model to the given position.
		]],

		["PreviewDisplay"] = {
			"Move ",
			"!Model",
			" to ",
			"!CFrame",
		},

		["Inputs"] = {
			["Model"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart", "Model"},
			},
			["CFrame"] = {
				["VariableType"] = "CFrame",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GetModelBoundingBox"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Model Bounding Box",
		["Description"] = [[
			Gives the size, rotation, and position of a box containing all the parts in a model.
		]],

		["PreviewDisplay"] = {
			"!Model"
		},

		["Inputs"] = {
			["Model"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Model"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"Position",
			"Rotation",
			"Size",
		},
	},
	["SetNetworkOwner"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Set Part Network Owner",
		["Description"] = [[
			Sets the network owner of a part.
			
			If the owner is set to nil instead of a player, it will transfer ownership to the server.
			
			See https://developer.roblox.com/en-us/articles/Network-Ownership
		]],

		["PreviewDisplay"] = {
			"Set owner of ",
			"!Part",
			" to ",
			"!Player"
		},

		["Inputs"] = {
			["Part"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart"},
			},
			["Player"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 2,
				["AllowedTypes"] = {"Player", "nil"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["FindPartOnRay"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Find Part On Ray",
		["Description"] = [[
			Sends out an invisible ray from a point in space with a specific direction and length, and then detects if it hits a part.
			
			If nothing is hit, the outputs will all be nil.
		]],

		["PreviewDisplay"] = {
			"From ",
			"!Origin",
			" with direction ",
			"!Direction"
		},

		["Inputs"] = {
			["Origin"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["Direction"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
			["FilterType"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"Blacklist", "Whitelist"},
				["ListOrder"] = 3,
			},
			["FilterDescendantsTable"] = {
				["VariableType"] = "Table",
				["ListOrder"] = 4,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Instance",
			"Position",
			"Normal"
		},
	},
	["SetPartPhysicalProperties"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Set Part Physical Properties",
		["Description"] = [[
			Sets the elasticity and friction of a part.
		]],

		["PreviewDisplay"] = {
			"Set properties of ",
			"!Part",
		},

		["Inputs"] = {
			["Part"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart"},
			},
			["Elasticity"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["DefaultValue"] = 0.5,
			},
			["Friction"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
				["DefaultValue"] = 0.3,
			},
			["Density"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 4,
				["DefaultValue"] = 0.7,
			},
			["ElasticityWeight"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 5,
				["DefaultValue"] = 1,
			},
			["FrictionWeight"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 6,
				["DefaultValue"] = 1,
			}

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GetPartPhysicalProperties"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Part Physical Properties",
		["Description"] = [[
			Gets the physical properties of a part.
		]],

		["PreviewDisplay"] = {
			"Get properties of ",
			"!Part",
		},

		["Inputs"] = {
			["Part"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart"},
			}

		},
		["Outputs"] = {
			-- Outputs
			"Result"
		},
	},
	["FireRocketPropulsion"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Fire Rocket Propulsion",
		["Description"] = [[
			Makes a rocket propulsion object fly towards its target.
		]],

		["PreviewDisplay"] = {
			"Fire ",
			"!RocketPropulsion",
		},

		["Inputs"] = {
			["RocketPropulsion"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RocketPropulsion"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["AbortRocketPropulsion"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Abort Rocket Propulsion",
		["Description"] = [[
			Makes a rocket propulsion object stop following its target.
		]],

		["PreviewDisplay"] = {
			"Abort ",
			"!RocketPropulsion",
		},

		["Inputs"] = {
			["RocketPropulsion"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RocketPropulsion"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["RegisterCollisionGroup"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Register Collision Group",
		["Description"] = [[
			Registers a collision group
		]],

		["PreviewDisplay"] = {
			"Register ",
			"!GroupName",
		},

		["Inputs"] = {
			["GroupName"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["Unregister"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 2,
				["DefaultValue"] = false,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["CollisionGroupSetCollidable"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Collision Group Set Collidable",
		["Description"] = [[
			Changes collision status between two groups.
		]],

		["PreviewDisplay"] = {
			"Changes collision between ",
			"!GroupName1",
			" and ",
			"!GroupName2",
			" to ",
			"!Collidable"
		},

		["Inputs"] = {
			["GroupName1"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["GroupName2"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
			["Collidable"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["AssignCollisionGroup"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Assign Collision Group",
		["Description"] = [[
			Assigns a BasePart to a specific collision group.
		]],

		["PreviewDisplay"] = {
			"Assigns BasePart ",
			"!BasePart",
			" to collision group ",
			"!GroupName",
		},

		["Inputs"] = {
			["BasePart"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BasePart"},
			},
			["GroupName"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["PlaySound"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Play Sound",
		["Description"] = [[
			Plays a sound.
		]],

		["PreviewDisplay"] = {
			"Play ",
			"!Sound",
		},

		["Inputs"] = {
			["Sound"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Sound"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["StopSound"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Stop Sound",
		["Description"] = [[
			Stops a sound.
		]],

		["PreviewDisplay"] = {
			"Stop ",
			"!Sound",
		},

		["Inputs"] = {
			["Sound"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Sound"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["PauseSound"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Pause Sound",
		["Description"] = [[
			Pauses a sound.
		]],

		["PreviewDisplay"] = {
			"Pause ",
			"!Sound",
		},

		["Inputs"] = {
			["Sound"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Sound"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["ResumeSound"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Resume Sound",
		["Description"] = [[
			Resumes a paused sound.
		]],

		["PreviewDisplay"] = {
			"Resume ",
			"!Sound",
		},

		["Inputs"] = {
			["Sound"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Sound"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["TweenGuiPosition"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Tween GUI Position",
		["Description"] = [[
			Smoothly moves a GUI object to another position.
			
			Connected blocks are ran after the tween is completed.
		]],

		["PreviewDisplay"] = {
			"!Object",
			" to ",
			"!Position",
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiObject"},
			},
			["Position"] = {
				["VariableType"] = "UDim2",
				["ListOrder"] = 2,
			},
			["Time"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
			["EasingStyle"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"},
				["ListOrder"] = 4,
			},
			["EasingDirection"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"In", "Out", "InOut"},
				["ListOrder"] = 5,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["TweenGuiSize"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Tween GUI Size",
		["Description"] = [[
			Smoothly resizes a GUI object.
			
			Connected blocks are ran after the tween is completed.
		]],

		["PreviewDisplay"] = {
			"!Object",
			" to ",
			"!Size",
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiObject"},
			},
			["Size"] = {
				["VariableType"] = "UDim2",
				["ListOrder"] = 2,
			},
			["Time"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
			["EasingStyle"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"},
				["ListOrder"] = 4,
			},
			["EasingDirection"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"In", "Out", "InOut"},
				["ListOrder"] = 5,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["CreateLeaderstat"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Create Leaderstat",
		["Description"] = [[
			Creates a leaderstat.
		]],

		["PreviewDisplay"] = {
			"Create leaderstat ",
			"!StatName",
		},

		["Inputs"] = {
			["StatName"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["InitialValue"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GetLeaderstat"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Leaderstat",
		["Description"] = [[
			Gets the value of a leaderstat.
		]],

		["PreviewDisplay"] = {
			"Get leaderstat ",
			"!StatName",
			" of ",
			"!Player"
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player", "Model"},
			},
			["StatName"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Value",
		},
	},
	["SetLeaderstat"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Set Leaderstat",
		["Description"] = [[
			Sets the value of a leaderstat.
		]],

		["PreviewDisplay"] = {
			"Set leaderstat ",
			"!StatName",
			" of ",
			"!Player",
			" to ",
			"!Value",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player", "Model"},
			},
			["StatName"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
			["Value"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["AddToLeaderstat"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Add to Leaderstat",
		["Description"] = [[
			Adds to the value of a leaderstat.
		]],

		["PreviewDisplay"] = {
			"Add ",
			"!Amount",
			" to ",
			"!StatName",
			" of ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player", "Model"},
			},
			["StatName"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
			["Amount"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["LeaderstatChanged"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Leaderstat Changed",
		["Description"] = [[
			Fires every time a leaderstat changes.
		]],

		["PreviewDisplay"] = {
			"!StatName",
			" of ",
			"!Player"
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player", "Model"},
			},
			["StatName"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},

		},
		["Outputs"] = {
			-- Outputs
			"Value"
		},
	},
	["CheckToolEquipped"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Check Tool Equipped",
		["Description"] = [[
			Returns a bool based on whether or not a tool is equipped.
		]],

		["PreviewDisplay"] = {
			"Check if ",
			"!Tool",
			" is equipped, output to ",
			"!Result",
		},

		["Inputs"] = {
			["Tool"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Tool"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["TakeDamage"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "TakeDamage",
		["Description"] = [[
			Deals the given amount of damage to the player if they are not protected by a forcefield.
			
			For the player you can input the player object, the character model, a part of the character, or the characters humanoid.
		]],

		["PreviewDisplay"] = {
			"Deal ",
			"!Damage",
			" to ",
			"!Player"
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
			["Damage"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["DialogChat"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Dialog Chat",
		["Description"] = [[
			Make a part say something.
		]],

		["PreviewDisplay"] = {
			"Make ",
			"!Part",
			" say ",
			"!Message"
		},

		["Inputs"] = {
			["Part"] = {
				["VariableType"] = "Object",
				["AllowedTypes"] = {"BasePart", "Model"},
				["ListOrder"] = 1,
			},
			["Message"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
			["Color"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"Blue", "Green", "Red"},
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["HasGamepass"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Has Gamepass",
		["Description"] = [[
			Returns a bool based on whether or not a player owns a gamepass
		]],

		["PreviewDisplay"] = {
			"Check if ",
			"!Player",
			" has the gamepass with id ",
			"!GamepassId",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player", "Model"},
			},
			["GamepassId"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},

		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["HasBadge"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Has Badge",
		["Description"] = [[
			Returns a bool based on whether or not a player has a badge.
			If there is an error checking this, it will always return false.
		]],

		["PreviewDisplay"] = {
			"Check if ",
			"!Player",
			" has the badge with id ",
			"!BadgeId",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player", "Model"},
			},
			["BadgeId"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},

		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},

	["GiveBadge"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Give Badge",
		["Description"] = [[
			Gives a badge to a player.
			The result output will return false if the player already owns this badge or if there is an error giving it to them.
		]],

		["PreviewDisplay"] = {
			"!Player",
			" will be given badge with id ",
			"!BadgeId",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player", "Model"},
			},
			["BadgeId"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},

		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["ChangeHumanoidState"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Change Humanoid State",
		["Description"] = [[
			Changes a humanoids state.
		]],

		["PreviewDisplay"] = {
			"Set state of ",
			"!Humanoid",
			" to ",
			"!State"
		},

		["Inputs"] = {
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"},
			},
			["State"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GetHumanoidState"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Humanoid State",
		["Description"] = [[
			Gets a humanoids state.
		]],

		["PreviewDisplay"] = {
			"Get state of ",
			"!Humanoid",
		},

		["Inputs"] = {
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"},
			},

		},
		["Outputs"] = {
			-- Outputs
			"State",
		},
	},
	["LoadCharacter"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Load Character",
		["Description"] = [[
			Respawns a players character.
		]],

		["PreviewDisplay"] = {
			"Load character of ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GetPlayersOnTeam"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Players On Team",
		["Description"] = [[
			Returns a table of all players on a team.
		]],

		["PreviewDisplay"] = {
			"List players of ",
			"!Team"
		},

		["Inputs"] = {
			["Team"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Team"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"PlayerTable",
		},
	},
	["TeleportToPlace"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Teleport To Place",
		["Description"] = [[
			Teleports a player to another Retrostudio place.
		]],

		["PreviewDisplay"] = {
			"Teleport ",
			"!Player",
			" to ",
			"!PlaceId"
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
			["PlaceId"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["KickPlayer"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Kick Player",
		["Description"] = [[
			Kicks a player.
			
			Does not run on Retrostudio admins.
		]],

		["PreviewDisplay"] = {
			"Kick ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
			["Reason"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},

	-- Input
	["ClickDetectorInteraction"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Click Detector Interaction",
		["Description"] = [[
			Runs connected blocks when a clickdetector is interacted with in a specific way.
		]],

		["PreviewDisplay"] = {
			"Execute when ",
			"!ClickDetector",
			" is ",
			"!InteractionType"
		},

		["Inputs"] = {
			-- Inputs
			["ClickDetector"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"ClickDetector"},
			},
			["InteractionType"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"Clicked", "Right Clicked", "Hover Enter", "Hover Leave"},
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Player",
		},
	},
	["GUIMouseEnter"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Mouse Enter",
		["Description"] = [[
			Runs connected blocks when the mouse goes over a GUI.
		]],

		["PreviewDisplay"] = {
			"Execute when mouse enters ",
			"!GUI",
		},

		["Inputs"] = {
			-- Inputs
			["GUI"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiObject"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GUIMouseLeave"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Mouse Leave",
		["Description"] = [[
			Runs connected blocks when the mouse leaves a GUI.
		]],

		["PreviewDisplay"] = {
			"Execute when mouse leaves ",
			"!GUI",
		},

		["Inputs"] = {
			-- Inputs
			["GUI"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiObject"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GUIMouseMoved"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Mouse Moved",
		["Description"] = [[
			Runs connected blocks when the mouse moves while inside a GUI.
		]],

		["PreviewDisplay"] = {
			"Execute when mouse moves on ",
			"!GUI",
		},

		["Inputs"] = {
			-- Inputs
			["GUI"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiObject"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GUIMouseWheelForward"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Mouse Wheel Up",
		["Description"] = [[
			Runs connected blocks when the mouse wheel is moved upward while over a GUI.
		]],

		["PreviewDisplay"] = {
			"Execute when mouse wheel moves up on ",
			"!GUI",
		},

		["Inputs"] = {
			-- Inputs
			["GUI"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiObject"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GUIMouseWheelBackward"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Mouse Wheel Down",
		["Description"] = [[
			Runs connected blocks when the mouse wheel is moved backward while over a GUI.
		]],

		["PreviewDisplay"] = {
			"Execute when mouse wheel moves down on ",
			"!GUI",
		},

		["Inputs"] = {
			-- Inputs
			["GUI"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiObject"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GUILeftMouseButtonClick"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Left Click",
		["Description"] = [[
			Runs connected blocks when a button is left clicked.
		]],

		["PreviewDisplay"] = {
			"Execute when mouse left clicks on ",
			"!GUIButton",
		},

		["Inputs"] = {
			-- Inputs
			["GUIButton"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiButton"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GUILeftMouseButtonDown"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Left Mouse Down",
		["Description"] = [[
			Runs connected blocks when the left mouse is pressed down over a button.
		]],

		["PreviewDisplay"] = {
			"Execute when left mouse button goes down on ",
			"!GUIButton",
		},

		["Inputs"] = {
			-- Inputs
			["GUIButton"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiButton"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GUILeftMouseButtonUp"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Left Mouse Up",
		["Description"] = [[
			Runs connected blocks when the left mouse stops pressing a button.
		]],

		["PreviewDisplay"] = {
			"Execute when left mouse button goes up on ",
			"!GUIButton",
		},

		["Inputs"] = {
			-- Inputs
			["GUIButton"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiButton"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GUIRightMouseButtonClick"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Right Click",
		["Description"] = [[
			Runs connected blocks when a button is right clicked.
		]],

		["PreviewDisplay"] = {
			"Execute when mouse right clicks on ",
			"!GUIButton",
		},

		["Inputs"] = {
			-- Inputs
			["GUIButton"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiButton"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GUIRightMouseButtonDown"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Right Mouse Down",
		["Description"] = [[
			Runs connected blocks when the right mouse is pressed down over a button.
		]],

		["PreviewDisplay"] = {
			"Execute when right mouse button goes down on ",
			"!GUIButton",
		},

		["Inputs"] = {
			-- Inputs
			["GUIButton"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiButton"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GUIRightMouseButtonUp"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "GUI Right Mouse Up",
		["Description"] = [[
			Runs connected blocks when the right mouse stops pressing a button.
		]],

		["PreviewDisplay"] = {
			"Execute when right mouse button goes up on ",
			"!GUIButton",
		},

		["Inputs"] = {
			-- Inputs
			["GUIButton"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"GuiButton"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},

	["TextBoxFocused"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Text Box Focused",
		["Description"] = [[
			Runs connected blocks when a text box is focused on.
		]],

		["PreviewDisplay"] = {
			"Execute when focused on ",
			"!TextBox",
		},

		["Inputs"] = {
			-- Inputs
			["TextBox"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"TextBox"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["TextBoxFocusLost"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Text Box Focus Lost",
		["Description"] = [[
			Runs connected blocks when a text box is no longer focused on.
		]],

		["PreviewDisplay"] = {
			"Execute when focus lost on ",
			"!TextBox",
		},

		["Inputs"] = {
			-- Inputs
			["TextBox"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"TextBox"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"EnterPressed"
		},
	},


	["GetMousePosition3D"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Get Mouse Position 3D",
		["Description"] = [[
			Returns the position in the world that a players mouse is pointing to.
		]],

		["PreviewDisplay"] = {
			"Mouse of ",
			"!Player",
			", outputs to ",
			"!Position",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"Position",
		},
	},
	["GetMousePosition2D"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Get Mouse Position 2D",
		["Description"] = [[
			Returns the position of a players mouse on their screen.
		]],

		["PreviewDisplay"] = {
			"Mouse of ",
			"!Player",
			", outputs to ",
			"!X",
			" and ",
			"!Y"
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"X",
			"Y",
		},
	},
	["GetMouseTargetPart"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Get Mouse Target Part",
		["Description"] = [[
			Returns the part that a players mouse is pointing at.
		]],

		["PreviewDisplay"] = {
			"Mouse of ",
			"!Player",
			", outputs to ",
			"!TargetPart",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"TargetPart",
		},
	},
	["GetMouseTargetSurface"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Get Mouse Target Surface",
		["Description"] = [[
			Returns the surface the mouse is pointing at.
			
			This can either be Front, Back, Left, Right, Top, or Bottom
		]],

		["PreviewDisplay"] = {
			"Outputs to ",
			"!Surface",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"Surface",
		},
	},
	["LeftMouseDown"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Left Mouse Down",
		["Description"] = [[
			Runs connected blocks when the left mouse button starts being pressed.
		]],

		["PreviewDisplay"] = {
			"From ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["LeftMouseUp"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Left Mouse Up",
		["Description"] = [[
			Runs connected blocks when the left mouse button stops being pressed.
		]],

		["PreviewDisplay"] = {
			"From ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["RightMouseDown"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Right Mouse Down",
		["Description"] = [[
			Runs connected blocks when the right mouse button starts being pressed.
		]],

		["PreviewDisplay"] = {
			"From ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["RightMouseUp"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Right Mouse Up",
		["Description"] = [[
			Runs connected blocks when the right mouse button stops being pressed.
		]],

		["PreviewDisplay"] = {
			"From ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["KeyDown"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Key Down",
		["Description"] = [[
			Fires when the specified player starts pressing a key.
			
			For key names, see https://developer.roblox.com/en-us/api-reference/enum/KeyCode
		]],


		["PreviewDisplay"] = {
			"!Key",
			" from ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
			["Key"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["KeyUp"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Key Up",
		["Description"] = [[
			Fires when the specified player stops pressing a key.
			
			For key names, see https://developer.roblox.com/en-us/api-reference/enum/KeyCode
		]],

		["PreviewDisplay"] = {
			"!Key",
			" from ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
			["Key"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},

	["GetMousePosition3DLocal"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Get Mouse Position 3D",
		["Description"] = [[
			Returns the position in the world that a players mouse is pointing to.
		]],

		["PreviewDisplay"] = {
			"Outputs to ",
			"!Position",
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"Position",
		},
	},
	["GetMousePosition2DLocal"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Get Mouse Position 2D",
		["Description"] = [[
			Returns the position of a players mouse on their screen.
		]],

		["PreviewDisplay"] = {
			"Outputs to ",
			"!X",
			" and ",
			"!Y"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"X",
			"Y",
		},
	},
	["SetMouseTargetFilterLocal"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = false,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Set Mouse Target Filter",
		["Description"] = [[
			Sets an object to be ignored when calculating the 3D mouse position and mouse target.
		]],

		["PreviewDisplay"] = {
			"Set to ",
			"!Object",
		},

		["Inputs"] = {
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["GetMouseTargetPartLocal"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Get Mouse Target Part",
		["Description"] = [[
			Returns the part that a players mouse is pointing at.
		]],

		["PreviewDisplay"] = {
			"Outputs to ",
			"!TargetPart",
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"TargetPart",
		},
	},
	["GetMouseTargetSurfaceLocal"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Get Mouse Target Surface",
		["Description"] = [[
			Returns the surface the mouse is pointing at.
			
			This can either be Front, Back, Left, Right, Top, or Bottom
		]],

		["PreviewDisplay"] = {
			"Outputs to ",
			"!Surface",
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"Surface",
		},
	},
	["LeftMouseDownLocal"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Left Mouse Down",
		["Description"] = "",

		["PreviewDisplay"] = {

		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["LeftMouseUpLocal"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Left Mouse Up",
		["Description"] = "",

		["PreviewDisplay"] = {

		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["RightMouseDownLocal"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Right Mouse Down",
		["Description"] = "",

		["PreviewDisplay"] = {

		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["RightMouseUpLocal"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Right Mouse Up",
		["Description"] = "",

		["PreviewDisplay"] = {

		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["JumpRequest"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "User Jump Request",
		["Description"] = "",

		["PreviewDisplay"] = {
			"On Jump Request"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["KeyDownLocal"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Key Down",
		["Description"] = [[
			Fires when the specified player starts pressing a key.
			
			For key names, see https://developer.roblox.com/en-us/api-reference/enum/KeyCode
		]],


		["PreviewDisplay"] = {
			"!Key",
		},

		["Inputs"] = {
			["Key"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["KeyUpLocal"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Key Up",
		["Description"] = [[
			Fires when the specified player stops pressing a key.
			
			For key names, see https://developer.roblox.com/en-us/api-reference/enum/KeyCode
		]],

		["PreviewDisplay"] = {
			"!Key",
		},

		["Inputs"] = {
			["Key"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},

	-- Math
	["Addition"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Addition",
		["Description"] = [[
			Perform addition on two numbers, Vector3s or CFrames.
		]],

		["PreviewDisplay"] = {
			"!Number1",
			" + ",
			"!Number2",
		},

		["Inputs"] = {
			["Number1"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"number", "Vector2", "Vector3", "CFrame"},
			},
			["Number2"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["AllowedTypes"] = {"number", "Vector2", "Vector3", "CFrame"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Subtraction"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Subtraction",
		["Description"] = [[
			Perform subtraction on two numbers, Vector3s or CFrames.
		]],

		["PreviewDisplay"] = {
			"!Number1",
			" - ",
			"!Number2",
		},

		["Inputs"] = {
			["Number1"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"number", "Vector2", "Vector3", "CFrame"},
			},
			["Number2"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["AllowedTypes"] = {"number", "Vector2", "Vector3", "CFrame"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Multiplication"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Multiplication",
		["Description"] = [[
			Perform multiplication on two numbers, Vector3s or CFrames.
		]],

		["PreviewDisplay"] = {
			"!Number1",
			" * ",
			"!Number2",
		},

		["Inputs"] = {
			["Number1"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"number", "Vector2", "Vector3", "CFrame"},
			},
			["Number2"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["AllowedTypes"] = {"number", "Vector2", "Vector3", "CFrame"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Division"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Division",
		["Description"] = [[
			Perform division on two numbers or vector3s.
		]],

		["PreviewDisplay"] = {
			"!Number1",
			" / ",
			"!Number2",
		},

		["Inputs"] = {
			["Number1"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"number", "Vector2", "Vector3"},
			},
			["Number2"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["AllowedTypes"] = {"number", "Vector2", "Vector3"},
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Modulus"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Modulus",
		["Description"] = [[
			Perform modulus on two numbers.
		]],

		["PreviewDisplay"] = {
			"!Number1",
			" % ",
			"!Number2",
		},

		["Inputs"] = {
			["Number1"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["Number2"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Exponentiation"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Exponentiation",
		["Description"] = [[
			Perform exponentiation on two numbers.
			
			For lua users, this is the same as the ^ operator
		]],

		["PreviewDisplay"] = {
			"!Number1",
			" ^ ",
			"!Number2",
		},

		["Inputs"] = {
			["Number1"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["Number2"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["DefaultValue"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["SolveEquation"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Solve Equation",
		["Description"] = [[
			Solves a math equation. For example, the equation "2 + 2" would output 4
			
			Uses the same syntax as lua
			
			This supports variables (Must not start with a number or include special characters in the name!)

			This supports user made functions

			This supports the lua math library, Vector3.new() and Vector2.new()
		]],

		["PreviewDisplay"] = {
			"!Result",
			" = ",
			"!Equation"
		},

		["Inputs"] = {
			["Equation"] = {
				["VariableType"] = "Equation",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["RandomNumber"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Random Number",
		["Description"] = [[
			Returns a random number between two given numbers.
		]],

		["PreviewDisplay"] = {
			"Between ",
			"!Minimum",
			" and ",
			"!Maximum",
			", outputs to ",
			"!Result",
		},

		["Inputs"] = {
			["Minimum"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
				["DefaultValue"] = 0,
			},
			["Maximum"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["DefaultValue"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Round"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Round",
		["Description"] = [[
			Rounds a number.
		]],

		["PreviewDisplay"] = {
			"!Type",
			" ",
			"!Number"
		},

		["Inputs"] = {
			["Number"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["Type"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"Round", "Floor", "Ceil"},
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["PerlinNoise"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Perlin Noise",
		["Description"] = [[
			Runs math.noise
		]],

		["PreviewDisplay"] = {
			"!X",
			", ",
			"!Y",
			", ",
			"!Z",
		},

		["Inputs"] = {
			["X"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
			["Y"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
			["Z"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["MathPi"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Pi",
		["Description"] = [[
			Returns pi.
		]],

		["PreviewDisplay"] = {
			"Sets ",
			"!Pi",
			" to Pi",
		},

		["Inputs"] = {
		},
		["Outputs"] = {
			-- Outputs
			"Pi",
		},
	},
	["MathLibrarySingleInput"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Math Library Single Input",
		["Description"] = [[
			Functions in the lua math library with only one input.
		]],

		["PreviewDisplay"] = {
			"math.",
			"!Function",
			"(",
			"!Number",
			")",
		},

		["Inputs"] = {
			["Function"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"abs", "acos", "asin", "atan", "ceil", "cos", "cosh", "deg", "exp", "floor", "frexp", "log10", "modf", "rad", "randomseed", "round", "sign", "sin", "sinh", "sqrt", "tan", "tanh"},
				["ListOrder"] = 1,
			},
			["Number"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["MathLibraryDoubleInput"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Math Library Double Input",
		["Description"] = [[
			Functions in the lua math library with two inputs.
		]],

		["PreviewDisplay"] = {
			"math.",
			"!Function",
			"(",
			"!Number1",
			", ",
			"!Number2",
			")",
		},

		["Inputs"] = {
			["Function"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"atan2", "fmod", "idexp", "log", "max", "min", "pow", "random"},
				["ListOrder"] = 1,
			},
			["Number1"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
			["Number2"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["MathLibraryTripleInput"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Math Library Triple Input",
		["Description"] = [[
			Functions in the lua math library with three inputs.
		]],

		["PreviewDisplay"] = {
			"math.",
			"!Function",
			"(",
			"!Number1",
			", ",
			"!Number2",
			", ",
			"!Number3",
			")",
		},

		["Inputs"] = {
			["Function"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"clamp", "noise"},
				["ListOrder"] = 1,
			},
			["Number1"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
			["Number2"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3,
			},
			["Number3"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 4,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["SetCoreGuiEnabled"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Set Core Gui Enabled (Late 2013+)",
		["Description"] = [[
			Hide or show a core gui.
		]],

		["PreviewDisplay"] = {
			"Set Core Gui ",
			"!CoreGui",
			" to ",
			"!Enabled"
		},

		["Inputs"] = {
			["CoreGui"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"All", "Backpack", "Chat", "Health", "PlayerList"},
				["ListOrder"] = 1,
			},
			["Enabled"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 2,
				["DefaultValue"] = false,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["TextBoxCaptureFocus"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Focus on TextBox",
		["Description"] = [[
			Make the user begin typing in a TextBox.
		]],

		["PreviewDisplay"] = {
			"!TextBox"
		},

		["Inputs"] = {
			["TextBox"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"TextBox"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["TextBoxReleaseFocus"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Unfocus on TextBox",
		["Description"] = [[
			Make the user stop typing in a TextBox.
		]],

		["PreviewDisplay"] = {
			"!TextBox"
		},

		["Inputs"] = {
			["TextBox"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"TextBox"},
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},









	--Deprecated blocks
	["MegaBlock"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "MEGA Block",
		["Description"] = [[
			WARNING: Only use for EXTREME block coding!
		]],

		["PreviewDisplay"] = {
			"MEGA Block"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["DescendantRemoved"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = true,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Descendant Removed",
		["Description"] = [[
			Runs connected blocks when a descendant is removed from an object.
		]],

		["PreviewDisplay"] = {
			"Execute when descendant is removed from ",
			"!Object",
			", output descendant to ",
			"!Descendant",
		},

		["Inputs"] = {
			-- Inputs
			["Object"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
			}
		},
		["Outputs"] = {
			-- Outputs
			"Descendant",
		},
	},
	["WhileLoop"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "While Loop",
		["Description"] = [[
			
		]],

		["PreviewDisplay"] = {
			"!VariableName1",
			" ",
			"!ComparisonType",
			" ",
			"!VariableName2",
		},

		["Inputs"] = {
			["VariableName1"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["ComparisonType"] = {
				["VariableType"] = "Choice",
				["Choices"] = {"==", "~=", ">", "<", "<=", ">="},
				["ListOrder"] = 2,
			},
			["VariableName2"] = {
				["VariableType"] = "String",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["SetVariable"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Set Variable",
		["Description"] = [[
			Sets a variable.
		]],

		["PreviewDisplay"] = {
			"!VariableName",
			" to ",
			"!Value",
		},

		["Inputs"] = {
			["VariableName"] = { --This needs to not be an output so that people can use a variable as the variablename
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["Value"] = {
				["VariableType"] = "Any",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["Concatenate"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Combine Strings",
		["Description"] = [[
			Combines 2 strings. The result will be filtered.
		]],

		["PreviewDisplay"] = {
			"Combine '",
			"!FirstString",
			"' with '",
			"!SecondString",
			"'",
		},

		["Inputs"] = {
			["FirstString"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["SecondString"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["SplitString"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Split String",
		["Description"] = [[
			Splits a string into parts based on the defined seperator character(s), returning a table of ordered results.
		]],

		["PreviewDisplay"] = {
			"Split '",
			"!String",
			"' with seperator '",
			"!Seperator",
			"'",
		},

		["Inputs"] = {
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["Seperator"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["FindString"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Find String",
		["Description"] = [[
			Looks for the first match of the given pattern.
		]],

		["PreviewDisplay"] = {
			"Find ",
			"!Pattern",
			" in ",
			"!String",
		},

		["Inputs"] = {
			["Pattern"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["FilterString"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Filter String",
		["Description"] = [[
			Filters a given string
		]],

		["PreviewDisplay"] = {
			"Filter ",
			"!String",
		},

		["Inputs"] = {
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["GSubString"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Global Sub String",
		["Description"] = [[
			Returns a copy of the provided string in which all occurences of the pattern are replaced with the given replacement.
		]],

		["PreviewDisplay"] = {
			"Replace ",
			"!Pattern",
			" in string ",
			"!String",
			" with replacement ",
			"!Replacement"
		},

		["Inputs"] = {
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["Pattern"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},
			["Replacement"] = {
				["VariableType"] = "String",
				["ListOrder"] = 3
			}
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Substring"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Substring",
		["Description"] = [[
			Returns the substring of an inputted string that starts at the first number to the last number.
		]],

		["PreviewDisplay"] = {
			"Get Substring from '",
			"!String",
			"' starting at '",
			"!StartPoint",
			"' ending at '",
			"!EndPoint",
			"'"
		},

		["Inputs"] = {
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["StartPoint"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
			["EndPoint"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 3
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Upper"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Upper",
		["Description"] = [[
			Turns all characters in the string to capitals
		]],

		["PreviewDisplay"] = {
			"Makes all characters in '",
			"!String",
			"' capitalized",
		},

		["Inputs"] = {
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["Lower"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Lower",
		["Description"] = [[
			Turns all characters in the string to lower-case
		]],

		["PreviewDisplay"] = {
			"Makes all characters in '",
			"!String",
			"' lower-cased",
		},

		["Inputs"] = {
			["String"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["ReverseMortalityEngine"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Reverse Mortality Engine",
		["Description"] = [[
			You can feel a small heart embedded within this block beating when you get near it.
		]],

		["PreviewDisplay"] = {
			[[###!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!#
			###!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!#
			###!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!#
			###!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!#
			###!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!####!!..!#
			]]
		},

		["Inputs"] = {

		},
		["Outputs"] = {

		},
	},
	["BlockThatMakesYourCharacterSentient"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Block That Makes Your Character Sentient",
		["Description"] = [[
			You can feel a small telephone embedded within this block ringing when you get near it.
		]],

		["PreviewDisplay"] = {
			[[Your character will experience all human emotions, including MANIA, SADNESS, FEAR, and PAIN.
			Your character may not appear alive as they will not be able to move or speak on their own, but rest assured that they are.
			]]
		},

		["Inputs"] = {
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"},
			}
		},
		["Outputs"] = {
			"MOOD",
		},
	},
	["GiveRetrobux"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Give Retrobux",
		["Description"] = [[
			
		]],

		["PreviewDisplay"] = {
			"Give ",
			"!Amount",
			" to ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Any", "nil", "Object"},
			},
			["Amount"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
				["DefaultValue"] = 1000,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["Comment2"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Comment",
		["Description"] = [[
			Does nothing. Useful for organizing your code.
		]],

		["PreviewDisplay"] = {
			"!Comment"
		},

		["Inputs"] = {
			["Comment"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["Color"] = {
				["VariableType"] = "BrickColor",
				["ListOrder"] = 2,
				["DefaultValue"] = BrickColor.new("Institutional white"),
			}
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["Lerp"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Lerp",
		["Description"] = [[
			Returns a position and rotation interpolated between itself and a goal by the given alpha.
		]],

		["PreviewDisplay"] = {
			"!StartPosition",
			" to ",
			"!GoalPosition",
			" with alpha ",
			"!Alpha",
		},

		["Inputs"] = {
			["StartPosition"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["StartRotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
			["GoalPosition"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 3,
			},
			["GoalRotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 4,
			},
			["Alpha"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 5,
			},
		},
		["Outputs"] = {
			-- Outputs
			"ResultPosition",
			"ResultRotation",
		},
	},
	["InversePositionAndRotation"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Inverse Position And Rotation",
		["Description"] = [[
			Returns the inverse of a position and rotation.
		]],

		["PreviewDisplay"] = {
			"Position ",
			"!Position",
			", rotation ",
			"!Rotation",
		},

		["Inputs"] = {
			["Position"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["Rotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"ResultPosition",
			"ResultRotation",
		},
	},
	["ToObjectSpace"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "To Object Space",
		["Description"] = [[
			Transforms a position and orientation to object space.
		]],

		["PreviewDisplay"] = {
			"!Position",
			" to object ",
			"!ObjectPosition",
		},

		["Inputs"] = {
			["Position"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["Rotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
			["ObjectPosition"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 3,
			},
			["ObjectRotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 4,
			},
		},
		["Outputs"] = {
			-- Outputs
			"ResultPosition",
			"ResultRotation",
		},
	},
	["ToWorldSpace"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "To World Space",
		["Description"] = [[
			Transforms a position and orientation to world space.
		]],

		["PreviewDisplay"] = {
			"!Position",
			" to world, from object ",
			"!ObjectPosition",
		},

		["Inputs"] = {
			["Position"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["Rotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
			["ObjectPosition"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 3,
			},
			["ObjectRotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 4,
			},
		},
		["Outputs"] = {
			-- Outputs
			"ResultPosition",
			"ResultRotation",
		},
	},
	["SetBodyGyroDirection"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Set Body Gyro Direction",
		["Description"] = [[
			Sets the direction of a body gyro.
		]],

		["PreviewDisplay"] = {
			"Set direction of ",
			"!BodyGyro",
			" to ",
			"!Rotation"
		},

		["Inputs"] = {
			["BodyGyro"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"BodyGyro"},
			},
			["Rotation"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
		},
	},
	["ChangeHumanoidStateLocal"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Change Humanoid State",
		["Description"] = [[
			Changes a humanoids state.
		]],

		["PreviewDisplay"] = {
			"Set state of ",
			"!Humanoid",
			" to ",
			"!State"
		},

		["Inputs"] = {
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"},
			},
			["State"] = {
				["VariableType"] = "String",
				["ListOrder"] = 2,
			},

		},
		["Outputs"] = {
			-- Outputs
		},
	},

	["IsPlayingSolo"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Is Solo",
		["Description"] = [[
			Returns a bool based on whether or not this script is running in a solo game server.
		]],

		["PreviewDisplay"] = {
			"Set to ",
			"!Answer"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"Answer",
		},
	},
	["IsGuest"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Is Guest",
		["Description"] = [[
			Returns a bool based on if a player is a guest or not.
		]],

		["PreviewDisplay"] = {
			"Check if ",
			"!Player",
			" is a guest"
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},-- Inputs
		},
		["Outputs"] = {
			-- Outputs
			"Answer",
		},
	},

	["IsTouchscreen"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Is Touchscreen",
		["Description"] = [[
			Detects if the game is running on a touchscreen device.
		]],

		["PreviewDisplay"] = {
			"Output to ",
			"!Answer"
		},

		["Inputs"] = {
			-- Inputs
		},
		["Outputs"] = {
			-- Outputs
			"Answer",
		},
	},
	["IsFriendsWith"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Is Friends With",
		["Description"] = [[
			Returns a bool based on if a player is friends with another player.
		]],

		["PreviewDisplay"] = {
			"Check if ",
			"!Player",
			" is friends with ",
			"!UserId"
		},

		["Inputs"] = {
			-- Inputs
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
			["UserId"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["IsInGroup"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Is In Group",
		["Description"] = [[
			Returns a bool based on if a player is in a certain group or not.
		]],

		["PreviewDisplay"] = {
			"Check if ",
			"!Player",
			" is in the group ",
			"!GroupId"
		},

		["Inputs"] = {
			-- Inputs
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
			["GroupId"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["GetRankInGroup"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Get Rank In Group",
		["Description"] = [[
			Returns the rank the user holds in a group.
		]],

		["PreviewDisplay"] = {
			"Get the rank of ",
			"!Player",
			" in the group ",
			"!GroupId"
		},

		["Inputs"] = {
			-- Inputs
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"},
			},
			["GroupId"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["GetStudioSelection"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Get Studio Selection",
		["Description"] = [[
			Returns a table of everything selected in studio.
			This is for plugins and should not be used in game.
		]],

		["PreviewDisplay"] = {
			"!Selection"
		},

		["Inputs"] = {

		},
		["Outputs"] = {
			-- Outputs
			"Selection",
		},
	},
	["HideLeaderboard"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Hide leaderboard",
		["Description"] = [[
			Hides or shows the leaderboard
			]],

		["PreviewDisplay"] = {
			"Hide leaderboard ",
			"!Hide",
		},

		["Inputs"] = {
			-- Inputs
			["Hide"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 1,
				["DefaultType"] = true
			}
		},
		["Outputs"] = {
			-- Outputs
			"Result",
		},
	},
	["RemoteFireAllClients2"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Fire Remote to All Clients",
		["Description"] = [[
			Sends a message to all clients.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Fire ",
			"!RemoteEvent"
		},

		["Inputs"] = {
			["RemoteEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteEvent"}
			},
			["Parameters"] = {
				["VariableType"] = "Tuple",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},

	["RemoteFireClient2"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Fire Remote Event",
		["Description"] = [[
			Sends a message to a client.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Fire ",
			"!RemoteEvent"
		},

		["Inputs"] = {
			["RemoteEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteEvent"}
			},
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 2,
				["AllowedTypes"] = {"Player"}
			},
			["Parameters"] = {
				["VariableType"] = "Tuple",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["RemoteRecieveClient2"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Receive Remote Event",
		["Description"] = [[
			Receives a message from the server.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Receive ",
			"!RemoteEvent"
		},

		["Inputs"] = {
			["RemoteEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteEvent"}
			},
		},
		["Outputs"] = {
			-- Outputs
			"TUPLE_Parameters",
		},
	},
	["RemoteFireServer2"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Fire Remote Event",
		["Description"] = [[
			Sends a message to the server.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Fire ",
			"!RemoteEvent"
		},

		["Inputs"] = {
			["RemoteEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteEvent"}
			},
			["Parameters"] = {
				["VariableType"] = "Tuple",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs

		},
	},
	["RemoteRecieveServer2"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Receive Remote Event",
		["Description"] = [[
			Receives a message from a client.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Receive ",
			"!RemoteEvent"
		},

		["Inputs"] = {
			["RemoteEvent"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteEvent"}
			},
		},
		["Outputs"] = {
			"Player",
			"TUPLE_Parameters",
		},
	},

	["HumanoidMoveTo"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Humanoid Move To",
		["Description"] = [[
			Sets the humanoid target to the specificed location.
			
			The humanoid will attempt to walk to the location.
			
			If the humanoid cannot reach it's target in 8 seconds, the MoveTo is canceled.
		]],

		["PreviewDisplay"] = {
			"!Humanoid",
			" move to ",
			"!Target"
		},

		["Inputs"] = {
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"}
			},

			["Target"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {

		},
	},



	["HumanoidMoveToFinished"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Humanoid Move To Finished",
		["Description"] = [[
			Runs connected blocks when a humanoid moveto finishes. 
			The output tells whether it reached it's target or not.
		]],

		["PreviewDisplay"] = {
			"!Humanoid",
			" reached target",
		},

		["Inputs"] = {
			["Humanoid"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Humanoid"}
			},
		},
		["Outputs"] = {
			"ReachedTarget",
		},
	},

	["BanPlayer"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Ban Player",
		["Description"] = [[
			Bans the specified player from the game.
			
			Use the unban player block to unban a player.
		]],

		["PreviewDisplay"] = {
			"Ban ",
			"!Player",
		},

		["Inputs"] = {
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"Player"}
			},
		},
		["Outputs"] = {

		},
	},

	["UnbanPlayer"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Unban Player",
		["Description"] = [[
			Unbans the specified player from the game.
		]],

		["PreviewDisplay"] = {
			"Unban ",
			"!Username",
		},

		["Inputs"] = {
			["Username"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {

		},
	},

	["UnbanPlayerUID"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Unban Player",
		["Description"] = [[
			Unbans the specified player from the game.
		]],

		["PreviewDisplay"] = {
			"Unban ",
			"!UserId",
		},

		["Inputs"] = {
			["UserId"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {

		},
	},

	["CheckIfPlayerIsBanned"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Is Player Banned",
		["Description"] = [[
			Returns whether the player is banned from the game.
		]],

		["PreviewDisplay"] = {
			"Is UserId ",
			"!UserId",
			" banned?"
		},

		["Inputs"] = {
			["UserId"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 1,
			},
		},
		["Outputs"] = {
			"Result"
		},
	},

	["ComputePath"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = false,
		["Server"] = true,
		["Local"] = true,

		["VisualName"] = "Compute Path",
		["Description"] = [[
			Uses PathfindingService to compute a path between two Vector3s.
			
			This block yields while the path is being calculated.
			
			Returns a table of Vector3s.
			
			Returns an empty table if the path cannot be computed.
		]],

		["PreviewDisplay"] = {
			"Compute from ",
			"!StartPosition",
			" to ",
			"!EndPosition",
		},

		["Inputs"] = {
			["StartPosition"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 1,
			},
			["EndPosition"] = {
				["VariableType"] = "Vector3",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			"ComputedPath"
		},
	},

	["RemoteFunctionInvokeServer"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Invoke Remote Function",
		["Description"] = [[
			Calls a function on the server.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Invoke ",
			"!RemoteFunction"
		},

		["Inputs"] = {
			["RemoteFunction"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteFunction"}
			},
			["Parameters"] = {
				["VariableType"] = "Tuple",
				["ListOrder"] = 2,
			},
		},
		["Outputs"] = {
			-- Outputs
			"TUPLE_Output"
		},
	},

	["RemoteFunctionInvokeClient"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Invoke Remote Function",
		["Description"] = [[
			Calls a function on the client.
			
			Parameters are optional and can be used to send extra data with the event.
			
			Strings are filtered when sent from the client to server!
		]],

		["PreviewDisplay"] = {
			"Invoke ",
			"!RemoteFunction",
			" for ",
			"!Player"
		},

		["Inputs"] = {
			["RemoteFunction"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteFunction"}
			},
			["Player"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 2,
				["AllowedTypes"] = {"Player"}
			},
			["Parameters"] = {
				["VariableType"] = "Tuple",
				["ListOrder"] = 3,
			},
		},
		["Outputs"] = {
			-- Outputs
			"TUPLE_Output"
		},
	},

	["RemoteFunctionOnInvokeServer"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = true,
		["Local"] = false,

		["VisualName"] = "Receive Remote Function",
		["Description"] = [[
			Receives a message from a client.
			
			Parameters are optional and can be used to send extra data to the client.
			
			Requires a return block to function.
		]],

		["PreviewDisplay"] = {
			"Receive ",
			"!RemoteFunction"
		},

		["Inputs"] = {
			["RemoteFunction"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteFunction"}
			},
		},
		["Outputs"] = {
			-- Outputs
			"Player",
			"TUPLE_Parameters",
		},
	},

	["RemoteFunctionOnInvokeClient"] = {
		["AutoExecuteChildren"] = false,
		["BumpEnvironment"] = true,
		["IsEvent"] = true,

		["ServerLocalSwitch"] = true,
		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "Receive Remote Function",
		["Description"] = [[
			Receives a message from a server.
			
			Parameters are optional and can be used to send extra data to the server.
			
			Requires a return block to function.
		]],

		["PreviewDisplay"] = {
			"Receive ",
			"!RemoteFunction"
		},

		["Inputs"] = {
			["RemoteFunction"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 1,
				["AllowedTypes"] = {"RemoteFunction"}
			},
		},
		["Outputs"] = {
			-- Outputs
			"TUPLE_Parameters",
		},
	},
	["PowerlangImport"] = {
		["AutoExecuteChildren"] = true,
		["BumpEnvironment"] = false,
		["IsEvent"] = false,

		["Server"] = false,
		["Local"] = true,

		["VisualName"] = "epic powerlang importer !!!",
		["Description"] = [[
            you probably shouldn't have this block lol
        ]],

		["PreviewDisplay"] = {
            [[We, the proud wizards of Powerlang, declare that all code should bend to our will
with the elegance of a pythonic twist, the swiftness of a racecar,
and the humor of a rubber chicken in a tuxedo. In our world, efficiency meets absurdity:
no longer will we be slaves to semicolons or the tyranny of boilerplate!
Powerlang is here to free us from the drudgery of overly verbose languages,
bringing power-packed expressiveness to the masses.
Simplicity is our battle cry, elegance our sword, and, naturally, snack breaks are mandatory.
Join uswhere coding is power, and fun is just a function call away!
PowerLang doesnt just perform; it moonwalks across your CPU.
So, join the revolution, because in Powerlang, the bugs are afraid of you.]]
		},

		["Inputs"] = {
			["VisualSource"] = {
				["VariableType"] = "String",
				["ListOrder"] = 1,
			},
			["ServerOrLocal"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 2,
			},
			["UseLocalVariables"] = {
				["VariableType"] = "Bool",
				["ListOrder"] = 3,
			},
			["InfoRemote"] = {
				["VariableType"] = "Object",
				["ListOrder"] = 4,
				["AllowedTypes"] = {"RemoteEvent"},
			},
			["FilterDelay"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 5,
			},
			["RetryAmount"] = {
				["VariableType"] = "Number",
				["ListOrder"] = 6,
			},
			["NewParent"] = {
				["VariableType"] = "Object",
				["AllowedTypes"] = {"Object"},
				["ListOrder"] = 7,
			},
		},
		["Outputs"] = {
			"TUPLE_Info"
		},
	},
}

module.CategoryList = CategoryList
module.BlockCategories = BlockCategories
module.BlocksList = BlocksList

table.freeze(module)

return module