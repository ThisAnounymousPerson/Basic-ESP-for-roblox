-- This script creates a red selection box around each player within 100000 studs of the local player
local MAX_DISTANCE = 100000 -- Maximum radius to highlight players

-- Function to add or remove a red box depending on the distance
local function updateRedBox(player, character, rootPart)
    local function distanceCheck()
        while true do
            -- Check if the local player character and root part exist
            local localPlayer = game.Players.LocalPlayer
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local localRootPart = localPlayer.Character.HumanoidRootPart
                local distance = (localRootPart.Position - rootPart.Position).Magnitude
                
                -- Check if the player is within the 100000 stud radius
                if distance <= MAX_DISTANCE then
                    -- If SelectionBox doesn't exist, create one
                    if not rootPart:FindFirstChild("SelectionBox") then
                        local selectionBox = Instance.new("SelectionBox")
                        selectionBox.Adornee = rootPart -- Attach the box to the part
                        selectionBox.Color3 = Color3.new(1, 0, 0) -- Red color (RGB)
                        selectionBox.LineThickness = 0.05 -- Thickness of the box lines
                        selectionBox.AlwaysOnTop = true -- Make the box visible through walls
                        selectionBox.Parent = rootPart -- Parent the SelectionBox to the part
                    end
                else
                    -- If the player is out of range, remove the SelectionBox if it exists
                    if rootPart:FindFirstChild("SelectionBox") then
                        rootPart.SelectionBox:Destroy()
                    end
                end
            end
            wait(1) -- Check every second
        end
    end
    
    coroutine.wrap(distanceCheck)() -- Run the distance check in a separate thread
end

-- Function to handle a new player
local function addPlayerHighlighting(player)
    player.CharacterAdded:Connect(function(character)
        -- Wait for the character's HumanoidRootPart to load
        local rootPart = character:WaitForChild("HumanoidRootPart")
        updateRedBox(player, character, rootPart)
    end)
end

-- Listen for new players
game.Players.PlayerAdded:Connect(addPlayerHighlighting)

-- Handle existing players already in the game
for _, player in pairs(game.Players:GetPlayers()) do
    addPlayerHighlighting(player)
end
