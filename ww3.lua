-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 1. Highlight ESP Implementation
local function applyHighlight(character)
    if not character:FindFirstChild("HumanoidRootPart") then return end
    if character:FindFirstChild("CustomESP_Highlight") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "CustomESP_Highlight"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- لون التعبئة (أحمر)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- لون الإطار (أبيض)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.AlwaysOnTop = true
    highlight.Parent = character
end

-- Apply ESP to existing and new players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then applyHighlight(player.Character) end
        player.CharacterAdded:Connect(applyHighlight)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(applyHighlight)
    end
end)

-- 2. No Recoil & Camera Shake Fix Implementation
RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    
    -- التأكد من السلاح الحالي (Tool)
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        -- البحث عن أي متغيرات تخص الـ Recoil أو الـ Spread داخل السلاح أو الـ Modules التابعة له وتصفيرها
        -- (هذه الطريقة تتعامل مع غالبية سكربتات الأسلحة الشائعة في روبلوكس)
        pcall(function()
            -- بعض السكربتات تخزن الإعدادات في مجلد Config أو Settings داخل الأداة
            local settingsModule = tool:FindFirstChild("Settings") or tool:FindFirstChild("Config") or tool:FindFirstChild("Values")
            if settingsModule then
                -- محاولة تعديل خصائص الارتداد إذا كانت معرفة بأسماء شائعة
                if settingsModule:FindFirstChild("Recoil") then settingsModule.Recoil.Value = 0 end
                if settingsModule:FindFirstChild("CameraShake") then settingsModule.CameraShake.Value = 0 end
                if settingsModule:FindFirstChild("Spread") then settingsModule.Spread.Value = 0 end
            end
        end)
    end
end)
