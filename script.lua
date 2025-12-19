--// Dig To Escape //--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- PATH BASE
local BASE_PATH = workspace.Map.Functional.SpawnedItems

-- Raridades em inglês
local rarities = {"All", "Common", "Uncommon", "Rare", "Epic", "Legendary"}
local selected = "All"

--==// OLD SCRIPTS   

local sgui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sgui.ResetOnSpawn = false
sgui.Name = "PurpleBringCompact"

-- Main Frame (mantido exatamente como no modelo)
local main = Instance.new("Frame", sgui)
main.Size = UDim2.new(0, 280, 0, 360)
main.Position = UDim2.new(0.5, -140, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(45, 35, 85)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

-- Title (mantido exatamente como no modelo)
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "Dig to Escape"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(220, 200, 255)

-- Tab Buttons Frame (mantido exatamente como no modelo)
local tabButtons = Instance.new("Frame", main)
tabButtons.Size = UDim2.new(1, 0, 0, 40)
tabButtons.Position = UDim2.new(0, 0, 0, 45)
tabButtons.BackgroundColor3 = Color3.fromRGB(60, 45, 110)

local tabList = Instance.new("UIListLayout", tabButtons)
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0, 6)
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content Frame (mantido exatamente como no modelo)
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -20, 1, -100)
content.Position = UDim2.new(0, 10, 0, 90)
content.BackgroundTransparency = 1

-- Tabs table
local tabs = {}
local currentTab = nil

local function openTab(tabName)
    if currentTab then currentTab.Visible = false end
    currentTab = tabs[tabName]
    currentTab.Visible = true
end

local function createTab(name)
    local btn = Instance.new("TextButton", tabButtons)
    btn.Size = UDim2.new(0.3, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(100, 80, 160)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local container = Instance.new("Frame", content)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Visible = false

    local list = Instance.new("UIListLayout", container)
    list.Padding = UDim.new(0, 10)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.SortOrder = Enum.SortOrder.LayoutOrder

    tabs[name] = container

    btn.MouseButton1Click:Connect(function()
        openTab(name)
        for _, b in pairs(tabButtons:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(100, 80, 160)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(140, 100, 220)
    end)

    if not currentTab then
        btn.BackgroundColor3 = Color3.fromRGB(140, 100, 220)
        openTab(name)
    end

    return container
end

--==// FUNÇÕES GERAIS //==
local function newButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(100, 70, 160)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

--==// TAB: BRING //==
local bringTab = createTab("Bring")

-- Dropdown
local dropdown = Instance.new("TextButton", bringTab)
dropdown.Size = UDim2.new(0.9, 0, 0, 55)
dropdown.BackgroundColor3 = Color3.fromRGB(70, 40, 130)
dropdown.Text = ""
dropdown.AutoButtonColor = false

local dropCorner = Instance.new("UICorner")
dropCorner.CornerRadius = UDim.new(0, 14)
dropCorner.Parent = dropdown

local dropText = Instance.new("TextLabel", dropdown)
dropText.Size = UDim2.new(1, -50, 1, 0)
dropText.Position = UDim2.new(0, 15, 0, 0)
dropText.BackgroundTransparency = 1
dropText.Text = "All items"  -- Em inglês
dropText.TextColor3 = Color3.new(1,1,1)
dropText.Font = Enum.Font.GothamBold
dropText.TextSize = 18
dropText.TextXAlignment = Enum.TextXAlignment.Left

local arrow = Instance.new("TextLabel", dropdown)
arrow.Size = UDim2.new(0, 40, 1, 0)
arrow.Position = UDim2.new(1, -45, 0, 0)
arrow.BackgroundTransparency = 1
arrow.Text = "▼"
arrow.TextColor3 = Color3.new(1,1,1)
arrow.TextSize = 28

local dropList = Instance.new("ScrollingFrame", dropdown)
dropList.Size = UDim2.new(1, 0, 0, 150)
dropList.Position = UDim2.new(0, 0, 1, 5)
dropList.BackgroundColor3 = Color3.fromRGB(70, 40, 130)
dropList.Visible = false
dropList.ScrollBarThickness = 4
dropList.ScrollBarImageColor3 = Color3.fromRGB(140, 70, 255)

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 14)
listCorner.Parent = dropList

local listLayout = Instance.new("UIListLayout", dropList)
listLayout.Padding = UDim.new(0, 6)

local function updateCanvas()
    dropList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 30)
end
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

for _, rarity in ipairs(rarities) do
    local opt = Instance.new("TextButton", dropList)
    opt.Size = UDim2.new(1, -10, 0, 50)
    opt.BackgroundColor3 = Color3.fromRGB(90, 50, 160)
    opt.TextColor3 = Color3.new(1,1,1)
    opt.Font = Enum.Font.GothamBold
    opt.TextSize = 18
    opt.AutoButtonColor = false

    local optCorner = Instance.new("UICorner")
    optCorner.CornerRadius = UDim.new(0, 8)
    optCorner.Parent = opt

    if rarity == "All" then
        opt.Text = "All items"
        opt.BackgroundColor3 = Color3.fromRGB(90, 50, 160)
    else
        opt.Text = rarity  -- Nome em inglês puro
    end

    opt.MouseEnter:Connect(function()
        TweenService:Create(opt, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 70, 200)}):Play()
    end)
    opt.MouseLeave:Connect(function()
        TweenService:Create(opt, TweenInfo.new(0.2), {
            BackgroundColor3 = rarity == "All" and Color3.fromRGB(90, 50, 160) or Color3.fromRGB(90, 50, 160)
        }):Play()
    end)

    opt.MouseButton1Click:Connect(function()
        selected = rarity
        dropText.Text = rarity == "All" and "All items" or rarity
        dropList.Visible = false
        arrow.Text = "▼"
    end)
end

updateCanvas()

dropdown.MouseButton1Click:Connect(function()
    dropList.Visible = not dropList.Visible
    arrow.Text = dropList.Visible and "▲" or "▼"
    if dropList.Visible then updateCanvas() end
end)

-- Espaçador invisível pra empurrar o botão TRAZER mais pra baixo
local spacer = Instance.new("Frame", bringTab)
spacer.Size = UDim2.new(1, 0, 0, 120)
spacer.BackgroundTransparency = 1
spacer.BorderSizePixel = 0

-- Botão TRAZER (mantido igual)
local bringBtn = Instance.new("TextButton", bringTab)
bringBtn.Size = UDim2.new(0.9, 0, 0, 60)
bringBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 255)
bringBtn.Text = "🚀 Bring items"
bringBtn.TextColor3 = Color3.new(1,1,1)
bringBtn.Font = Enum.Font.GothamBold
bringBtn.TextSize = 20
bringBtn.AutoButtonColor = false

local bringCorner = Instance.new("UICorner")
bringCorner.CornerRadius = UDim.new(0, 16)
bringCorner.Parent = bringBtn

local bringGrad = Instance.new("UIGradient", bringBtn)
bringGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 50, 220))
}
bringGrad.Rotation = 90

bringBtn.MouseEnter:Connect(function()
    TweenService:Create(bringBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(160, 80, 255)}):Play()
end)
bringBtn.MouseLeave:Connect(function()
    TweenService:Create(bringBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 60, 255)}):Play()
end)

-- Função bring (agora funciona com nomes em inglês)
local function bringItems()
    if selected == "All" then
        bringBtn.Text = "🔄 Bringing all..."
        local count = 0
        for _, rarityName in ipairs(rarities) do
            if rarityName ~= "All" then
                local folder = BASE_PATH:FindFirstChild(rarityName)
                if folder then
                    for _, obj in ipairs(folder:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            obj.CFrame = hrp.CFrame * CFrame.new(0, 0, -6)
                            count += 1
                        elseif obj:IsA("Model") and obj.PrimaryPart then
                            obj:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, -6))
                            count += 1
                        end
                    end
                end
            end
        end
        bringBtn.Text = "✅ " .. count .. " items"
        task.wait(2.5)
        bringBtn.Text = "🚀 Bring items"
        print("💜 Brought " .. count .. " items from all rarities!")
        return
    end

    local folder = BASE_PATH:FindFirstChild(selected)
    if not folder then
        bringBtn.Text = "❌ Not found!"
        task.wait(2)
        bringBtn.Text = "🚀 Bring items"
        return
    end

    local count = 0
    bringBtn.Text = "🔄 Bringing..."
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CFrame = hrp.CFrame * CFrame.new(0, 0, -6)
            count += 1
        elseif obj:IsA("Model") and obj.PrimaryPart then
            obj:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, -6))
            count += 1
        end
    end
    bringBtn.Text = "✅ " .. count .. " items!"
    task.wait(2)
    bringBtn.Text = "🚀 Bring items"
    print("💜 Brought " .. count .. " " .. selected .. " items!")
end

bringBtn.MouseButton1Click:Connect(bringItems)

--==// TAB: PLAYER //==
local playerTab = createTab("Player")

local function hum()
    return player.Character and player.Character:FindFirstChildOfClass("Humanoid")
end

local function createToggleNumber(name, default, applyFunc)
    local frame = Instance.new("Frame", playerTab)
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(100, 70, 160)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.45, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  "..name
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 18
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0.25, 0, 0.7, 0)
    toggle.Position = UDim2.new(0.47, 0, 0.15, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(130, 90, 200)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 18
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 10)

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.25, 0, 0.7, 0)
    box.Position = UDim2.new(0.75, 0, 0.15, 0)
    box.BackgroundTransparency = 1
    box.PlaceholderText = tostring(default)
    box.Text = ""
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 18

    local enabled = false
    local value = default

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.Text = enabled and "ON" or "OFF"
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(80,200,120) or Color3.fromRGB(130,90,200)

        applyFunc(enabled, value)
    end)

    box.FocusLost:Connect(function(enter)
        if not enter then return end
        local num = tonumber(box.Text)

        if num and num >= 1 and num <= 200 then
            value = num
            box.PlaceholderText = tostring(value)
            box.Text = ""

            if enabled then
                applyFunc(true, value)
            end
        else
            box.Text = ""
        end
    end)
end

createToggleNumber("WalkSpeed", 37.95, function(on, val)
    local h = hum()
    if h then
        h.WalkSpeed = on and val or 37.95
    end
end)

createToggleNumber("JumpPower", 50, function(on, val)
    local h = hum()
    if h then
        if on then
            h.JumpPower = val
            h.JumpHeight = val / 3
        else
            h.JumpPower = 50
            h.JumpHeight = 7
        end
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    local h = hum()
    if h then
        h.WalkSpeed = 37.95
        h.JumpPower = 50
        h.JumpHeight = 7
    end
end)

newButton(playerTab, "Infinite Jump", function(btn)
    local inf = not _G.InfiniteJumpEnabled
    _G.InfiniteJumpEnabled = inf

    btn.Text = inf and "Infinite Jump: ON" or "Infinite Jump"

    if inf and not _G.InfiniteJumpConnection then
        _G.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local chr = player.Character
            local hum = chr and chr:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    elseif not inf and _G.InfiniteJumpConnection then
        _G.InfiniteJumpConnection:Disconnect()
        _G.InfiniteJumpConnection = nil
    end
end)

local fullbrightEnabled = false
local savedLighting = nil  -- Vai salvar os valores exatamente antes de ativar

newButton(playerTab, "Fullbright", function(btn)
    fullbrightEnabled = not fullbrightEnabled
    btn.Text = fullbrightEnabled and "Fullbright: ON" or "Fullbright"

    if fullbrightEnabled then
        -- Salva o estado atual ANTES de mudar (pra restaurar exatamente esse depois)
        savedLighting = {
            Brightness = Lighting.Brightness,
            GlobalShadows = Lighting.GlobalShadows,
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            ClockTime = Lighting.ClockTime,
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart
        }

        -- Liga Fullbright (luz total, meio-dia)
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.ClockTime = 12  -- Meio-dia pra clarear tudo
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    else
        -- Desliga e restaura EXATAMENTE o que estava antes de ativar
        if savedLighting then
            Lighting.Brightness = savedLighting.Brightness
            Lighting.GlobalShadows = savedLighting.GlobalShadows
            Lighting.Ambient = savedLighting.Ambient
            Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
            Lighting.ClockTime = savedLighting.ClockTime
            Lighting.FogEnd = savedLighting.FogEnd
            Lighting.FogStart = savedLighting.FogStart
        end
    end
end)

-- Botão Fast Proximity
local fastProximityEnabled = false
local fastProximityLoop = nil

newButton(playerTab, "Fast Proximity", function(btn)
    fastProximityEnabled = not fastProximityEnabled
    btn.Text = fastProximityEnabled and "Fast Proximity: ON" or "Fast Proximity"

    if fastProximityEnabled then
        -- Liga o loop que acelera os prompts
        fastProximityLoop = task.spawn(function()
            while fastProximityEnabled do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        obj.HoldDuration = 0.1  -- Tempo bem curto (ajuste se quiser 0.05 ou 0)
                        obj.MaxActivationDistance = 20  -- Opcional: aumenta o alcance
                    end
                end
                task.wait(1)  -- Atualiza rápido, mas sem lagar
            end
        end)
    else
        -- Desliga o loop
        if fastProximityLoop then
            task.cancel(fastProximityLoop)
            fastProximityLoop = nil
        end

        -- Restaura os valores padrão dos prompts (opcional, mas recomendado)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0.25  -- Valor padrão comum (mude se o jogo usar outro)
                obj.MaxActivationDistance = 20  -- Valor padrão comum
            end
        end
    end
end)

--==// TAB: ESP //==
local espTab = createTab("ESP")

local espEnabled = false
local espConnections = {}
local espColor = Color3.fromRGB(255, 0, 0)  -- Cor padrão: vermelho
local espFillTrans = 0.5  -- Transparência padrão do preenchimento

local function applyESP(model)
    if not model or model:FindFirstChild("ESP_HL") then return end
    local hl = Instance.new("Highlight")
    hl.Name = "ESP_HL"
    hl.FillColor = espColor
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = espFillTrans
    hl.OutlineTransparency = 0
    hl.Parent = model
end

local function updateESP(model)
    local hl = model:FindFirstChild("ESP_HL")
    if hl then
        hl.FillColor = espColor
        hl.FillTransparency = espFillTrans
    end
end

local function removeESP(model)
    local hl = model:FindFirstChild("ESP_HL")
    if hl then hl:Destroy() end
end

-- Botão principal ESP Players
newButton(espTab, "ESP Players", function(btn)
    espEnabled = not espEnabled
    btn.Text = espEnabled and "ESP Players: ON" or "ESP Players"

    if espEnabled then
        -- Aplica em jogadores atuais
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                applyESP(plr.Character)
            end
        end

        -- Novos jogadores
        espConnections.playerAdded = Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                if espEnabled then applyESP(char) end
            end)
        end)

        -- Quando jogador sai
        espConnections.playerRemoving = Players.PlayerRemoving:Connect(function(plr)
            if plr.Character then removeESP(plr.Character) end
        end)
    else
        -- Remove de todos
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then removeESP(plr.Character) end
        end

        -- Desconecta tudo
        for _, conn in pairs(espConnections) do
            conn:Disconnect()
        end
        espConnections = {}
    end
end)


-- Botão ESP Items (corrigido - pega TODOS os itens, mesmo os "problemáticos")
local espItemsEnabled = false
local espItemsConnection = nil

local function applyItemESP(obj)
    if not obj then return end

    -- Evita duplicar Highlight
    if obj:FindFirstChild("ESP_ITEM_HL") then return end

    local hl = Instance.new("Highlight")
    hl.Name = "ESP_ITEM_HL"
    hl.FillColor = Color3.fromRGB(180, 0, 255)  -- Roxo
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0
    hl.Adornee = obj  -- Aplica no objeto inteiro (Model ou Part)

    -- Coloca o Highlight em um lugar válido
    if obj:IsA("Model") then
        local anyPart = obj:FindFirstChildWhichIsA("BasePart")
        if anyPart then
            hl.Parent = anyPart
        else
            -- Se não tiver nenhuma BasePart, coloca no Model (raramente acontece)
            hl.Parent = obj
        end
    else
        hl.Parent = obj
    end
end

local function removeItemESP(obj)
    local hl = obj:FindFirstChild("ESP_ITEM_HL")
    if hl then hl:Destroy() end

    -- Remove também de partes dentro do model
    if obj:IsA("Model") then
        for _, part in pairs(obj:GetDescendants()) do
            local hl2 = part:FindFirstChild("ESP_ITEM_HL")
            if hl2 then hl2:Destroy() end
        end
    end
end

newButton(espTab, "ESP Items", function(btn)
    espItemsEnabled = not espItemsEnabled
    btn.Text = espItemsEnabled and "ESP Items: ON" or "ESP Items"

    if espItemsEnabled then
        -- Aplica em todos os itens já existentes (em todas as pastas)
        for _, folder in pairs(BASE_PATH:GetChildren()) do
            for _, item in pairs(folder:GetDescendants()) do
                if item:IsA("Model") or item:IsA("BasePart") then
                    applyItemESP(item)
                end
            end
        end

        -- Detecta novos itens spawnados ou recriados
        espItemsConnection = BASE_PATH.DescendantAdded:Connect(function(desc)
            if espItemsEnabled and (desc:IsA("Model") or desc:IsA("BasePart")) then
                applyItemESP(desc)
            end
        end)
    else
        -- Remove ESP de todos os itens
        for _, folder in pairs(BASE_PATH:GetChildren()) do
            for _, item in pairs(folder:GetDescendants()) do
                removeItemESP(item)
            end
        end

        -- Desconecta o evento
        if espItemsConnection then
            espItemsConnection:Disconnect()
            espItemsConnection = nil
        end
    end
end)

-- Botão ESP NPCs (azul claro)
local espNPCsEnabled = false
local espNPCsConnection = nil

local function applyNPCHL(obj)
    if not obj or obj:FindFirstChild("ESP_NPC_HL") then return end
    
    local target = obj
    if obj:IsA("Model") and obj.PrimaryPart then
        target = obj.PrimaryPart
    elseif not obj:IsA("BasePart") then
        return
    end

    local hl = Instance.new("Highlight")
    hl.Name = "ESP_NPC_HL"
    hl.FillColor = Color3.fromRGB(100, 200, 255)  -- Azul claro bonito
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0
    hl.Adornee = obj  -- Funciona em Model inteiro
    hl.Parent = target
end

local function removeNPCHL(obj)
    if obj:IsA("Model") then
        for _, part in pairs(obj:GetDescendants()) do
            local hl = part:FindFirstChild("ESP_NPC_HL")
            if hl then hl:Destroy() end
        end
    else
        local hl = obj:FindFirstChild("ESP_NPC_HL")
        if hl then hl:Destroy() end
    end
end

newButton(espTab, "ESP NPCs", function(btn)
    espNPCsEnabled = not espNPCsEnabled
    btn.Text = espNPCsEnabled and "ESP NPCs: ON" or "ESP NPCs"

    if espNPCsEnabled then
        local spawnedNPCs = workspace.Map.Functional:FindFirstChild("SpawnedNPCs")
        if spawnedNPCs then
            -- Aplica em todos os NPCs já existentes
            for _, npc in pairs(spawnedNPCs:GetDescendants()) do
                if npc:IsA("Model") or npc:IsA("BasePart") then
                    applyNPCHL(npc)
                end
            end

            -- Detecta novos NPCs spawnados
            espNPCsConnection = spawnedNPCs.DescendantAdded:Connect(function(desc)
                task.wait(0.1)
                if espNPCsEnabled and (desc:IsA("Model") or desc:IsA("BasePart")) then
                    applyNPCHL(desc)
                end
            end)
        end
    else
        local spawnedNPCs = workspace.Map.Functional:FindFirstChild("SpawnedNPCs")
        if spawnedNPCs then
            -- Remove ESP de todos os NPCs
            for _, npc in pairs(spawnedNPCs:GetDescendants()) do
                removeNPCHL(npc)
            end
        end

        -- Desconecta o evento
        if espNPCsConnection then
            espNPCsConnection:Disconnect()
            espNPCsConnection = nil
        end
    end
end)

-- Botão ESP Vents (cinza claro - só em VentDoor)
local espVentsEnabled = false
local espVentsConnection = nil

local function applyVentHL(obj)
    if not obj or obj.Name ~= "VentDoor" or obj:FindFirstChild("ESP_VENT_HL") then return end
    
    local target = obj
    if obj:IsA("Model") and obj.PrimaryPart then
        target = obj.PrimaryPart
    elseif not obj:IsA("BasePart") then
        return
    end

    local hl = Instance.new("Highlight")
    hl.Name = "ESP_VENT_HL"
    hl.FillColor = Color3.fromRGB(200, 200, 200)  -- Cinza claro
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0
    hl.Adornee = obj  -- Funciona no objeto inteiro
    hl.Parent = target
end

local function removeVentHL(obj)
    if obj.Name == "VentDoor" then
        local hl = obj:FindFirstChild("ESP_VENT_HL")
        if hl then hl:Destroy() end
        
        -- Remove também de partes dentro do model, se for o caso
        if obj:IsA("Model") then
            for _, part in pairs(obj:GetDescendants()) do
                local hl2 = part:FindFirstChild("ESP_VENT_HL")
                if hl2 then hl2:Destroy() end
            end
        end
    end
end

newButton(espTab, "ESP Vents", function(btn)
    espVentsEnabled = not espVentsEnabled
    btn.Text = espVentsEnabled and "ESP Vents: ON" or "ESP Vents"

    local ventsFolder = workspace.Map.Functional.Objects:FindFirstChild("Vents")
    if not ventsFolder then return end

    if espVentsEnabled then
        -- Aplica em todos os VentDoor já existentes
        for _, obj in pairs(ventsFolder:GetDescendants()) do
            applyVentHL(obj)
        end

        -- Detecta novos VentDoor que spawnarem
        espVentsConnection = ventsFolder.DescendantAdded:Connect(function(desc)
            task.wait(0.1)
            if espVentsEnabled then
                applyVentHL(desc)
            end
        end)
    else
        -- Remove ESP de todos os VentDoor
        for _, obj in pairs(ventsFolder:GetDescendants()) do
            removeVentHL(obj)
        end

        -- Desconecta o evento
        if espVentsConnection then
            espVentsConnection:Disconnect()
            espVentsConnection = nil
        end
    end
end)

-- Botão ESP Batteries (amarelo)
local espBatteriesEnabled = false
local espBatteriesConnection = nil

local function applyBatteryHL(obj)
    if not obj or obj:FindFirstChild("ESP_BATTERY_HL") then return end
    
    local target = obj
    if obj:IsA("Model") and obj.PrimaryPart then
        target = obj.PrimaryPart
    elseif not obj:IsA("BasePart") then
        return
    end

    local hl = Instance.new("Highlight")
    hl.Name = "ESP_BATTERY_HL"
    hl.FillColor = Color3.fromRGB(255, 255, 0)  -- Amarelo vivo
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0
    hl.Adornee = obj  -- Funciona no objeto inteiro
    hl.Parent = target
end

local function removeBatteryHL(obj)
    if obj:IsA("Model") then
        for _, part in pairs(obj:GetDescendants()) do
            local hl = part:FindFirstChild("ESP_BATTERY_HL")
            if hl then hl:Destroy() end
        end
    else
        local hl = obj:FindFirstChild("ESP_BATTERY_HL")
        if hl then hl:Destroy() end
    end
end

newButton(espTab, "ESP Batteries", function(btn)
    espBatteriesEnabled = not espBatteriesEnabled
    btn.Text = espBatteriesEnabled and "ESP Batteries: ON" or "ESP Batteries"

    local batteriesFolder = workspace.Map.Functional.JanitorEnding:FindFirstChild("SpawnedBatteries")
    if not batteriesFolder then 
        warn("Pasta SpawnedBatteries não encontrada!")
        return 
    end

    if espBatteriesEnabled then
        -- Aplica em todos os itens já existentes na pasta
        for _, battery in pairs(batteriesFolder:GetDescendants()) do
            if battery:IsA("Model") or battery:IsA("BasePart") then
                applyBatteryHL(battery)
            end
        end

        -- Detecta novas baterias que spawnarem ou forem recriadas
        espBatteriesConnection = batteriesFolder.DescendantAdded:Connect(function(desc)
            task.wait(0.1)
            if espBatteriesEnabled and (desc:IsA("Model") or desc:IsA("BasePart")) then
                applyBatteryHL(desc)
            end
        end)
    else
        -- Remove ESP de todos os itens na pasta
        for _, battery in pairs(batteriesFolder:GetDescendants()) do
            removeBatteryHL(battery)
        end

        -- Desconecta o evento
        if espBatteriesConnection then
            espBatteriesConnection:Disconnect()
            espBatteriesConnection = nil
        end
    end
end)

-- Respawn
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
end)

-- Função de callback do botão
local callback = Instance.new("BindableFunction")
callback.OnInvoke = function(button)
    if button == "OK" then
        if setclipboard then
            setclipboard("https://www.youtube.com/@Find_Nulla827Oldestview")
            print("Link copiado com sucesso!")
        else
            warn("Executor não suporta setclipboard")
        end
    end
end

-- NOTIFICAÇÃO
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Made By Old Scripts";
    Text = "Click OK to copy the link to my channel";
    Icon = "rbxassetid://6379388631"; -- icone de virus so pra dar um pouco de susto kkkk
    Duration = 6;
    Button1 = "OK";
    Callback = callback;
})

-- Somzinho de carregado
task.spawn(function()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://3023237993"
    s.Volume = 0.4
    s.Parent = game:GetService("SoundService")
    s:Play()
    task.delay(3, function() s:Destroy() end)
end)

print("[loaded]")
