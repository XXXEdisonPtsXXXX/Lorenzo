-- DonLorenzo Hub (Полная финальная сборка)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- НАСТРОЙКА ТАБЛИЦЫ ПРИОРИТЕТОВ СБОРА
local ItemPriority = {
    "пони",       -- Сначала летит к вещам, где в названии есть "пони"
    "сплинк",     -- Затем к сплинкерам
    "sprink",
    "pony"
}

_G.LoopPickActive = false
_G.FPSBoostActive = false

-- 1. ОСНОВНОЙ ИНТЕРФЕЙС
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DL_Hub_Final"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 480, 0, 280)
MainFrame.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- 2. ЛЕВАЯ ПАНЕЛЬ (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BorderSizePixel = 0

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = Sidebar

-- КРУГЛЫЙ АВАТАР ИГРОКА
local AvatarIcon = Instance.new("ImageLabel")
AvatarIcon.Name = "AvatarIcon"
AvatarIcon.Parent = Sidebar
AvatarIcon.BackgroundTransparency = 1
AvatarIcon.Position = UDim2.new(0.15, 0, 0.08, 0)
AvatarIcon.Size = UDim2.new(0, 90, 0, 90)
AvatarIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

pcall(function()
    AvatarIcon.Image = "https://roblox.com" .. player.UserId .. "&width=150&height=150&format=png"
end)

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 45)
IconCorner.Parent = AvatarIcon

local Title = Instance.new("TextLabel")
Title.Parent = Sidebar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.45, 0)
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "DL HUB"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 12.0

-- КНОПКИ ВКЛАДОК
local TabBtn1 = Instance.new("TextButton")
TabBtn1.Parent = Sidebar
TabBtn1.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabBtn1.Position = UDim2.new(0.08, 0, 0.6, 0)
TabBtn1.Size = UDim2.new(0, 110, 0, 30)
TabBtn1.Font = Enum.Font.SourceSansBold
TabBtn1.Text = "Основное"
TabBtn1.TextColor3 = Color3.fromRGB(255, 255, 255)
TabBtn1.TextSize = 13.0

local TabBtn2 = Instance.new("TextButton")
TabBtn2.Parent = Sidebar
TabBtn2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabBtn2.Position = UDim2.new(0.08, 0, 0.74, 0)
TabBtn2.Size = UDim2.new(0, 110, 0, 30)
TabBtn2.Font = Enum.Font.SourceSansBold
TabBtn2.Text = "ФПС Буст"
TabBtn2.TextColor3 = Color3.fromRGB(180, 180, 180)
TabBtn2.TextSize = 13.0

-- 3. КОНТЕНТНЫЕ ОКНА
local MainContainer = Instance.new("Frame")
MainContainer.Parent = MainFrame
MainContainer.BackgroundTransparency = 1
MainContainer.Position = UDim2.new(0.28, 0, 0, 0)
MainContainer.Size = UDim2.new(0.72, 0, 1, 0)

-- Кнопка Автофарма
local ToggleFarmBtn = Instance.new("TextButton")
ToggleFarmBtn.Parent = MainContainer
ToggleFarmBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
ToggleFarmBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleFarmBtn.Size = UDim2.new(0, 310, 0, 45)
ToggleFarmBtn.Font = Enum.Font.SourceSansBold
ToggleFarmBtn.Text = "ТГ | @Don_Lorenzo17 [OFF]"
ToggleFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFarmBtn.TextSize = 14.0

-- Кнопка FPS Booster
local ToggleFPSBtn = Instance.new("TextButton")
ToggleFPSBtn.Parent = MainContainer
ToggleFPSBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleFPSBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleFPSBtn.Size = UDim2.new(0, 310, 0, 45)
ToggleFPSBtn.Font = Enum.Font.SourceSansBold
ToggleFPSBtn.Text = "СКРЫТЬ ЧУЖИЕ САДЫ: ВЫКЛ"
ToggleFPSBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleFPSBtn.TextSize = 14.0
ToggleFPSBtn.Visible = false

-- Кнопка СВЕРНУТЬ (-)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = MainFrame
MiniBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MiniBtn.Position = UDim2.new(0.93, 0, 0.03, 0)
MiniBtn.Size = UDim2.new(0, 24, 0, 24)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.TextSize = 14.0

-- Кнопка ОТКРЫТЬ (OPEN)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.Position = UDim2.new(0, 10, 0, 10)
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Text = "OPEN"
OpenBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
OpenBtn.Visible = false
local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 20)
OpenCorner.Parent = OpenBtn

-- Логика вкладок
TabBtn1.MouseButton1Click:Connect(function()
    ToggleFarmBtn.Visible = true; ToggleFPSBtn.Visible = false
    TabBtn1.TextColor3 = Color3.fromRGB(255, 255, 255); TabBtn2.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

TabBtn2.MouseButton1Click:Connect(function()
    ToggleFarmBtn.Visible = false; ToggleFPSBtn.Visible = true
    TabBtn1.TextColor3 = Color3.fromRGB(180, 180, 180); TabBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

MiniBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenBtn.Visible = false end)

-- Переключатели функций
ToggleFarmBtn.MouseButton1Click:Connect(function()
    _G.LoopPickActive = not _G.LoopPickActive
    if _G.LoopPickActive then
        ToggleFarmBtn.Text = "ТГ | @Don_Lorenzo17 [ON]"
        ToggleFarmBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleFarmBtn.Text = "ТГ | @Don_Lorenzo17 [OFF]"
        ToggleFarmBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
    end
end)

ToggleFPSBtn.MouseButton1Click:Connect(function()
    _G.FPSBoostActive = not _G.FPSBoostActive
    if _G.FPSBoostActive then
        ToggleFPSBtn.Text = "СКРЫТЬ ЧУЖИЕ САДЫ: ВКЛ"
        ToggleFPSBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleFPSBtn.Text = "СКРЫТЬ ЧУЖИЕ САДЫ: ВЫКЛ"
        ToggleFPSBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- ПЕРЕТАСКИВАНИЕ ХАБА ПАЛЬЦЕМ
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Поиск папки дропа
local function getDroppedFolder()
    return Workspace:FindFirstChild("Dropped") 
        or Workspace:FindFirstChild("DroppedItems") 
        or Workspace:FindFirstChild("Debris") 
        or Workspace:FindFirstChild("Items") 
        or Workspace
end

-- СВЕРХСКОРОСТНОЙ ТЕЛЕПОРТ
local function fastBypassMove(rootPart, targetCFrame)
    local startPos = rootPart.Position
    local endPos = targetCFrame.Position
    local distance = (startPos - endPos).Magnitude
    local stepDistance = 40 
    
    local noclipLoop = RunService.Stepped:Connect(function()
        if player.Character then
            for _, v in ipairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    
    if distance > stepDistance then
        local steps = math.floor(distance / stepDistance)
        for i = 1, steps do
            rootPart.CFrame = CFrame.new(startPos:Lerp(endPos, i / steps))
            RunService.Heartbeat:Wait()
        end
    end
    rootPart.CFrame = targetCFrame
    noclipLoop:Disconnect()
end

-- ЦИКЛ ФПС БУСТЕРА (GROW A GARDEN 2)
task.spawn(function()
    while true do
        task.wait(1)
        if _G.FPSBoostActive then
            local plots = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Gardens") or Workspace:FindFirstChild("PlayerPlots")
            if plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    if plot.Name ~= player.Name and plot.Name ~= player.DisplayName then
                        for _, obj in ipairs(plot:GetDescendants()) do
                            if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                                obj.Transparency = 1
                                obj.CanCollide = false
                            elseif obj:IsA("ParticleEmitter") or obj:IsA("Highlight") then
                                obj.Enabled = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ГЛАВНЫЙ ОПТИМИЗИРОВАННЫЙ ЦИКЛ АВТΟΣБОРА
task.spawn(function()
    while true do
        if not _G.LoopPickActive then
            task.wait(0.3) -- Засыпает, когда выключен
        else
            RunService.Heartbeat:Wait()
            local character = player.Character
