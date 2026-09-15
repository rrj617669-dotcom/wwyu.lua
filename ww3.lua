-- Auto Clicker UI (Universal Target)
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalAutoClicker"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Control Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 130)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Auto Clicker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

-- Target Button (The circle you move to click area)
local TargetBtn = Instance.new("TextButton")
TargetBtn.Size = UDim2.new(0, 40, 0, 40)
TargetBtn.Position = UDim2.new(0.5, -20, 0.5, -20)
TargetBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
TargetBtn.BackgroundTransparency = 0.4
TargetBtn.Text = "Target"
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.Font = Enum.Font.SourceSansBold
TargetBtn.TextSize = 12
TargetBtn.Active = true
TargetBtn.Draggable = true
TargetBtn.Parent = ScreenGui

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(1, 0)
TargetCorner.Parent = TargetBtn

-- Toggle AutoClick Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
ToggleBtn.Text = "Start Auto Click"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = Frame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

-- Speed Note
local Note = Instance.new("TextLabel")
Note.Size = UDim2.new(1, 0, 0, 25)
Note.Position = UDim2.new(0, 0, 0.75, 0)
Note.Text = "Drag red target to desired location"
Note.TextColor3 = Color3.fromRGB(180, 180, 180)
Note.BackgroundTransparency = 1
Note.Font = Enum.Font.SourceSans
Note.TextSize = 12
Note.Parent = Frame

-- Logic
local clicking = false

local function performClicks()
    while clicking do
        -- Trigger Virtual Click at Target location
        local centerPos = TargetBtn.AbsolutePosition + (TargetBtn.AbsoluteSize / 2)
        
        -- Fire inputs/gui click simulation
        pcall(function()
            local guiObjects = PlayerGui:GetGuiObjectsAtPosition(centerPos.X, centerPos.Y)
            for _, obj in ipairs(guiObjects) do
                if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    if obj ~= TargetBtn and obj ~= ToggleBtn then
                        for _, conn in ipairs(getconnections(obj.MouseButton1Click)) do
                            conn:Fire()
                        end
                        for _, conn in ipairs(getconnections(obj.Activated)) do
                            conn:Fire()
                        end
                    end
                end
            end
        end)
        
        task.wait(0.001) -- Minimum delay to prevent game freezing
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    clicking = not clicking
    if clicking then
        ToggleBtn.Text = "Stop"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.spawn(performClicks)
    else
        ToggleBtn.Text = "Start Auto Click"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    end
end)
