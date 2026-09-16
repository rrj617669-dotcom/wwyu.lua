-- Roblox Professional GUI: Highlight ESP & No Recoil
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Global Toggles
local ESP_Enabled = false
local NoRecoil_Enabled = false

-- 1. Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProCombatGUI"
ScreenGui.ResetOnSpawn = false

-- Safety attach to CoreGui or PlayerGui
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Frame (Window)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 170)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.Text = "Combat Hub v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- ESP Toggle Button
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0.9, 0, 0, 40)
ESPButton.Position = UDim2.new(0.05, 0, 0.3, 0)
ESPButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ESPButton.Text = "ESP (Highlight): OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 14
ESPButton.Font = Enum.Font.SourceSansSemibold
ESPButton.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 6)
BtnCorner1.Parent = ESPButton

-- No Recoil Toggle Button
local RecoilButton = Instance.new("TextButton")
RecoilButton.Size = UDim2.new(0.9, 0, 0, 40)
RecoilButton.Position = UDim2.new(0.05, 0, 0.60, 0)
RecoilButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
RecoilButton.Text = "No Recoil: OFF"
RecoilButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RecoilButton.TextSize = 14
RecoilButton.Font = Enum.Font.SourceSansSemibold
RecoilButton.Parent = MainFrame

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 6)
BtnCorner2.Parent = RecoilButton

-- 2. ESP Logic
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("ProGUI_Highlight")
            if ESP_Enabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ProGUI_Highlight"
                    highlight.Adornee = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.AlwaysOnTop = true
                    highlight.Parent = player.Character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end

ESPButton.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    if ESP_Enabled then
        ESPButton.Text = "ESP (Highlight): ON"
        ESPButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    else
        ESPButton.Text = "ESP (Highlight): OFF"
        ESPButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
    updateESP()
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if ESP_Enabled then updateESP() end
    end)
end)

-- 3. No Recoil Logic Loop
RecoilButton.MouseButton1Click:Connect(function()
    NoRecoil_Enabled = not NoRecoil_Enabled
    if NoRecoil_Enabled then
        RecoilButton.Text = "No Recoil: ON"
        RecoilButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    else
        RecoilButton.Text = "No Recoil: OFF"
        RecoilButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)

RunService.RenderStepped:Connect(function()
    if not NoRecoil_Enabled then return end
    local char = LocalPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function()
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local name = v.Name:lower()
                        if name:find("recoil") or name:find("shake") or name:find("spread") then
                            v.Value = 0
                        end
                    end
                end
            end)
        end
    end
end)
