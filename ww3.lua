-- Custom No Recoil GUI for Map Framework (Executor / Luau)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 1. إنشاء واجهة المستخدم (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MapNoRecoilGUI"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 140)
MainFrame.Position = UDim2.new(0.5, -115, 0.4, -70)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.Text = "Custom No Recoil"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.85, 0, 0, 45)
ToggleButton.Position = UDim2.new(0.075, 0, 0.48, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ToggleButton.Text = "No Recoil: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

----------------------------------------------------
-- 2. منطق تجميد الارتداد (No Recoil Logic)
----------------------------------------------------
local enabled = false
local isMouseDown = false
local lockedPitch = 0
local renderConnection = nil

-- التقاط بدء وانهاء الضغط على الزر الأيسر للماوس
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMouseDown = true
        local _, pitch, _ = Camera.CFrame:ToOrientation()
        lockedPitch = pitch
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMouseDown = false
    end
end)

-- تصفير أي محاولة لرفع الكاميرا رأسياً أثناء الإطلاق
local function processNoRecoil()
    if not enabled or not isMouseDown then return end
    
    local x, y, z = Camera.CFrame:ToOrientation()
    -- قفل الارتداد الرأسي (Pitch) لمنع ارتفاع السلاح للأعلى
    Camera.CFrame = CFrame.new(Camera.CFrame.Position) * CFrame.Angles(lockedPitch, y, z)
end

-- زر التفعيل والإيقاف
ToggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    
    if enabled then
        ToggleButton.Text = "No Recoil: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        
        renderConnection = RunService.RenderStepped:Connect(processNoRecoil)
    else
        ToggleButton.Text = "No Recoil: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        
        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end
    end
end)
