local Core = require(script.Parent.Parent.Core)
local SharedClasses = require(script.Parent.Parent.SharedClasses)

Core.Parse([[
@flag AllowNoSemicolons

event PlayerAdded(player) {
	leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	points = Instance.new("IntValue", leaderstats)
	points.Name = "Potatoes"
}

function SpawnPotato(position) {
	isPotatoNice = false
	if math.random(1,50) == 1 {
		isPotatoNice = true
	}
	newPotato = Instance.new("Part", workspace.Potatoes)
	newPotato.Shape = "Ball"
	newPotato.Size = Vector3.new(1,1,1)
	newPotato.Position = position
	newMesh = Instance.new("SpecialMesh", newPotato)
	newMesh.Scale = Vector3.new(1.5, 1.5, 1.5)
	newMesh.MeshId = "rbxassetid://477543051"
	newMesh.TextureId = "rbxassetid://477543054"
	Debris.addItem(newPotato, 60)
	if isPotatoNice {
		newMesh.VertexColor = Vector3.new(2,2,2)
		newPotato.Size = Vector3.new(4,4,4)
		newMesh.Scale = Vector3.new(6,6,6)
		Instance.new("Sparkles", newPotato)
	}
	
	event newPotato.Touched(otherPart) {
		if otherPart.Parent:FindFirstChild("Humanoid") {
			player = players.getPlayerFromCharacter(otherPart.Parent)
			player.leaderstats.Potatoes.Value = player.leaderstats.Potatoes.Value + 1
			sound = Instance.new("Sound", newPotato)
			sound.SoundId = "rbxassetid://3125624765"
			sound.PlayOnRemove = true
			if isPotatoNice {
				msg = Instance.new("Message", workspace)
				msg.Text = player.Name .. " just collected a Nice Potato!"
				Debris.addItem(msg, 2)
				player.leaderstats.Potatoes.Value = player.leaderstats.Potatoes.Value + 4
			}
			newPotato:Destroy()
		}
	}
}

while true {
	wait(1)
	position = Vector3.new(math.random(-100,100), 100, math.random(-100,100))
	SpawnPotato(position)
}

]], SharedClasses.ExecutableContext("<executed>", {}, false))
