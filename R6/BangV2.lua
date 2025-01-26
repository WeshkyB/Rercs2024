-- by pyst
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Create the ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "ModernGUI"

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true

-- Squircle Shape
local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 20)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleBar.BorderSizePixel = 0

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.Size = UDim2.new(0, 50, 1, 0)
TitleLabel.Position = UDim2.new(0, 5, 0, 0)
TitleLabel.Text = "Bang V2"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextSize = 14

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.Size = UDim2.new(0, 25, 1, 0)
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = TitleBar
MinimizeButton.Size = UDim2.new(0, 50, 1, 0)
MinimizeButton.Position = UDim2.new(1, -75, 0, 0)
MinimizeButton.Text = "Hide"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
MinimizeButton.BorderSizePixel = 0

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    if not minimized then
        MainFrame.Size = UDim2.new(0, 300, 0, 25)
        MinimizeButton.Text = "Show"
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 150)
        MinimizeButton.Text = "Hide"
    end
    minimized = not minimized
end)

-- Text Box
local TargetTextBox = Instance.new("TextBox")
TargetTextBox.Parent = MainFrame
TargetTextBox.Size = UDim2.new(0.9, 0, 0, 30)
TargetTextBox.Position = UDim2.new(0.05, 0, 0.3, 0)
TargetTextBox.PlaceholderText = "Enter target name"
TargetTextBox.Text = ""
TargetTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetTextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TargetTextBox.BorderSizePixel = 0

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = MainFrame
ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0.6, 0)
ToggleButton.Text = "Start"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
ToggleButton.BorderSizePixel = 0

-- Functionality
local following = false
local targetPlayer = nil
local animationId = "189854234" -- 182789003 use this id if u prefer

ToggleButton.MouseButton1Click:Connect(function()
    if not following then
        -- Start following
        local targetName = TargetTextBox.Text:lower()
        targetPlayer = nil
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():find(targetName) or player.DisplayName:lower():find(targetName) then
                targetPlayer = player
                break
            end
        end
        
        if targetPlayer and targetPlayer.Character then
            following = true
            ToggleButton.Text = "Stop"
            
            -- Animation
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://" .. animationId
            local animator = humanoid:LoadAnimation(animation)

            coroutine.wrap(function()
                local lastCFrame = nil
                while following do
                    local targetCharacter = targetPlayer.Character
                    if targetCharacter and targetCharacter.PrimaryPart then
                        local targetCFrame = targetCharacter.PrimaryPart.CFrame
                        
                        -- Position your character behind and face the target
                        local followCFrame = targetCFrame * CFrame.new(0, 0, 1.2) -- Slightly closer to the target
                        
                        if not lastCFrame or (followCFrame.Position - lastCFrame.Position).Magnitude > 0.1 or
                            (followCFrame.LookVector - lastCFrame.LookVector).Magnitude > 0.1 then
                            lastCFrame = followCFrame

                            -- Move behind the target and face it
                            LocalPlayer.Character:SetPrimaryPartCFrame(
                                CFrame.new(followCFrame.Position) *
                                CFrame.Angles(0, math.atan2(-targetCFrame.LookVector.X, -targetCFrame.LookVector.Z), 0)
                            )
                        end
                        
                        -- Play animation
                        animator:Play()
                        task.wait(0.1)
                        animator:Stop()
                        task.wait(0.1)
                    else
                        -- Stop if target is invalid
                        following = false
                        ToggleButton.Text = "Start"
                        break
                    end
                end
            end)()
        else
            print("Target not found!")
        end
    else
        -- Stop following
        following = false
        ToggleButton.Text = "Start"
    end
end)
