-- Roblox Executor Universal No Recoil GUI
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- إنشاء واجهة المستخدم (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NoRecoilGUI"
ScreenGui.ResetOnSpawn = false

-- تجنب اكتشاف الواجهة أو التداخل مع Roblox CoreGui
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- الإطار الرئيسي (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, -65)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- إمكانية سحب النافذة
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- شريط العنوان (Title Bar)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleLabel.Text = "No Recoil Script"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleLabel

-- زر التشغيل/الإيقاف (Toggle Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.85, 0, 0, 45)
ToggleButton.Position = UDim2.new(0.075, 0, 0.45, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- أحمر (معطل)
ToggleButton.Text = "No Recoil: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

----------------------------------------------------
-- منطق الـ No Recoil
----------------------------------------------------
local noRecoilEnabled = false
local renderConnection = nil

local function applyNoRecoil()
    local character = LocalPlayer.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        -- البحث عن قيم الارتداد داخل السلاح وتصفرها
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                local name = obj.Name:lower()
                if name:find("recoil") or name:find("kick") or name:find("spread") then
                    obj.Value = 0
                end
            end
        end
    end
end

-- تفعيل / تعطيل الخاصية عند الضغط على الزر
ToggleButton.MouseButton1Click:Connect(function()
    noRecoilEnabled = not noRecoilEnabled
    
    if noRecoilEnabled then
        ToggleButton.Text = "No Recoil: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50) -- أخضر (مفعل)
        
        -- تشغيل الحلقة لتصفير القيم بشكل مستمر
        renderConnection = RunService.RenderStepped:Connect(function()
            if noRecoilEnabled then
                applyNoRecoil()
            end
        end)
    else
        ToggleButton.Text = "No Recoil: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- أحمر (معطل)
        
        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end
    end
end)
