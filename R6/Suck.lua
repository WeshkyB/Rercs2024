-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local UsernameBox = Instance.new("TextBox")
local ToggleButton = Instance.new("TextButton")

-- GUI Properties
ScreenGui.Name = "GetSuckedGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
local mainCorner = Instance.new("UICorner", MainFrame)
mainCorner.CornerRadius = UDim.new(0, 15)

-- Title Bar
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
local titleBarCorner = Instance.new("UICorner", TitleBar)
titleBarCorner.CornerRadius = UDim.new(0, 15)

-- Title Label
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Suck"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
local closeButtonCorner = Instance.new("UICorner", CloseButton)
closeButtonCorner.CornerRadius = UDim.new(0, 15)

-- Minimize Button
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14
local minimizeButtonCorner = Instance.new("UICorner", MinimizeButton)
minimizeButtonCorner.CornerRadius = UDim.new(0, 15)

-- Username Input Box
UsernameBox.Name = "UsernameBox"
UsernameBox.Parent = MainFrame
UsernameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
UsernameBox.Size = UDim2.new(0, 260, 0, 30)
UsernameBox.Position = UDim2.new(0.5, -130, 0.5, -20)
UsernameBox.Font = Enum.Font.Gotham
UsernameBox.PlaceholderText = "Target's Username"
UsernameBox.Text = ""
UsernameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameBox.TextSize = 14
local usernameBoxCorner = Instance.new("UICorner", UsernameBox)
usernameBoxCorner.CornerRadius = UDim.new(0, 15)

-- Toggle Button
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ToggleButton.Size = UDim2.new(0, 260, 0, 30)
ToggleButton.Position = UDim2.new(0.5, -130, 0.5, 20)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Start"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
local toggleButtonCorner = Instance.new("UICorner", ToggleButton)
toggleButtonCorner.CornerRadius = UDim.new(0, 15)

-- GUI Logic
local minimized = false
local running = false
local originalGravity
local attachmentLoop
local animTrack
local targetPlayer

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Size = minimized and UDim2.new(0, 300, 0, 30) or UDim2.new(0, 300, 0, 150)
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

ToggleButton.MouseButton1Click:Connect(function()
    if not running then
        ToggleButton.Text = "Stop"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        running = true

        local victim = UsernameBox.Text:lower()

        -- Find target player by matching either username or display name
        for _, player in pairs(game.Players:GetPlayers()) do
            if string.find(player.Name:lower(), victim) or string.find(player.DisplayName:lower(), victim) then
                targetPlayer = player
                break
            end
        end

        if targetPlayer then
            local localPlayer = game.Players.LocalPlayer
            local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

            -- Find the target's torso or lower body part (Pelvis area)
            local targetTorso = targetPlayer.Character:FindFirstChild("LowerTorso") or targetPlayer.Character:FindFirstChild("UpperTorso")

            if humanoidRootPart and targetRootPart and targetTorso then
                originalGravity = workspace.Gravity
                workspace.Gravity = 0 -- Set gravity to 0 to keep the character floating

                -- Play animation
                local animationId = "rbxassetid://178130996" -- Replace with valid animation ID
                local animation = Instance.new('Animation')
                animation.AnimationId = animationId

                local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    animTrack = humanoid:LoadAnimation(animation)
                    animTrack:Play()
                    animTrack:AdjustSpeed(1)
                end

                -- Attach the local player character to the target character's torso (this does not loop)
                attachmentLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    if running then
                        -- Update the local player's position to be in front of the target's torso
                        humanoidRootPart.CFrame = targetTorso.CFrame * CFrame.new(0, -2.3, -1.0) * CFrame.Angles(0, math.pi, 0)
                    end
                end)
            end
        end
    else
        -- Stop the process and everything running
        ToggleButton.Text = "Start"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        running = false

        -- Restore gravity
        if originalGravity then
            workspace.Gravity = originalGravity
        end

        -- Disconnect loops and stop animations
        if attachmentLoop then
            attachmentLoop:Disconnect() -- Disconnect the attachment loop
            attachmentLoop = nil -- Clear the loop variable to prevent accidental access
        end
        if animTrack then
            animTrack:Stop() -- Stop the animation
            animTrack = nil -- Clear the animation variable
        end
    end
end)
