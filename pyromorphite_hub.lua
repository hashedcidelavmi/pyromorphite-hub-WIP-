-- // Pyromorphite Hub v4.0 — Emerald Arcade (Monolithic Clean Build)
-- Оптимизация: убраны лимиты экрана, добавлены кнопки [X] и [Reboot] в шапку.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Изумрудная палитра
local EmeraldGreen = Color3.fromRGB(0, 255, 100)
local ActiveRed = Color3.fromRGB(255, 50, 50)
local DarkGray = Color3.fromRGB(30, 30, 30)
local Black = Color3.fromRGB(15, 15, 15)

local TargetParent = Player:WaitForChild("PlayerGui")

-- Ссылка на твой RAW гитхаб для функции авто-ребута
local GitHubRawURL = "https://raw.githubusercontent.com/hashedcidelavmi/pyromorphite-hub-WIP-/main/hub.lua"

-- Переменные для глобальной очистки
local noclipConnection = nil
local visualEnabled = false
local noclip = false

-- Глобальная функция очистки всех дочерних процессов
local function KillAllScripts()
	-- 1. Выключаем и чистим 1PCT
	visualEnabled = false
	for _, desc in ipairs(Workspace:GetDescendants()) do
		if desc.Name == "FOVTracer" or desc.Name == "Line1" or desc.Name == "Line2" then
			desc:Destroy()
		end
	end
	
	-- 2. Выключаем и чистим Ноклип
	if noclipConnection then 
		noclipConnection:Disconnect() 
		noclipConnection = nil
	end
	pcall(function()
		local char = Player.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = true end
			end
		end
	end)
	
	-- 3. Закрываем встроенный флингер, если он был открыт
	local embeddedFling = TargetParent:FindFirstChild("EmbeddedFlingGUI")
	if embeddedFling then embeddedFling:Destroy() end
	
	-- 4. Удаляем сам Хаб
	local mainHub = TargetParent:FindFirstChild("PyromorphiteHub")
	if mainHub then mainHub:Destroy() end
end


-- // 1. КНОПКА ОТКРЫТИЯ ХАБА ("P")
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 38, 0, 38)
toggleButton.Position = UDim2.new(0, 40, 0, 150)
toggleButton.BackgroundColor3 = Black
toggleButton.Text = "P"
toggleButton.TextColor3 = EmeraldGreen
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.Arcade
toggleButton.BorderSizePixel = 0
toggleButton.ZIndex = 10
toggleButton.Parent = ScreenGui
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(1, 0)

local btnStroke = Instance.new("UIStroke", toggleButton)
btnStroke.Color = EmeraldGreen; btnStroke.Thickness = 2; btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local btnDragging = false
local btnDragInput, btnDragStart, btnStartPos
local dragDistance = 0

toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		btnDragging = true; dragDistance = 0; btnDragStart = input.Position; btnStartPos = toggleButton.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then btnDragging = false end end)
	end
end)
toggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then btnDragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == btnDragInput and btnDragging then
		local delta = input.Position - btnDragStart
		dragDistance = dragDistance + delta.Magnitude
		toggleButton.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
	end
end)


-- // 2. ГЛАВНОЕ ОКНО ХАБА
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 280)
Main.Position = UDim2.new(0.5, -190, 0.5, -140)
Main.BackgroundColor3 = DarkGray; Main.BorderSizePixel = 0; Main.Visible = false; Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = EmeraldGreen; mainStroke.Thickness = 2; mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Шапка/Заголовок
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1; Title.Text = ""; Title.TextColor3 = EmeraldGreen
Title.Font = Enum.Font.Arcade; Title.TextSize = 22

local function typewrite(label, text)
	label.Text = ""
	for i = 1, #text do
		label.Text = string.sub(text, 1, i)
		task.wait(0.04)
	end
end

-- КНОПКА ЗАКРЫТИЯ [X] (Справа в шапке)
local CloseHubBtn = Instance.new("TextButton", Main)
CloseHubBtn.Size = UDim2.new(0, 25, 0, 25)
CloseHubBtn.Position = UDim2.new(1, -35, 0, 5)
CloseHubBtn.BackgroundColor3 = Black
CloseHubBtn.Text = "X"
CloseHubBtn.TextColor3 = ActiveRed
CloseHubBtn.Font = Enum.Font.Arcade
CloseHubBtn.TextSize = 14
CloseHubBtn.ZIndex = 5
Instance.new("UICorner", CloseHubBtn).CornerRadius = UDim.new(0, 6)
local closeStroke = Instance.new("UIStroke", CloseHubBtn)
closeStroke.Color = ActiveRed; closeStroke.Thickness = 1.5; closeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

CloseHubBtn.MouseButton1Click:Connect(function()
	KillAllScripts()
end)

-- КНОПКА ПЕРЕЗАГРУЗКИ [↻] (Слева в шапке)
local RebootHubBtn = Instance.new("TextButton", Main)
RebootHubBtn.Size = UDim2.new(0, 25, 0, 25)
RebootHubBtn.Position = UDim2.new(0, 10, 0, 5)
RebootHubBtn.BackgroundColor3 = Black
RebootHubBtn.Text = "R" -- Сигнализирует о Reboot
RebootHubBtn.TextColor3 = EmeraldGreen
RebootHubBtn.Font = Enum.Font.Arcade
RebootHubBtn.TextSize = 14
RebootHubBtn.ZIndex = 5
Instance.new("UICorner", RebootHubBtn).CornerRadius = UDim.new(0, 6)
local rebootStroke = Instance.new("UIStroke", RebootHubBtn)
rebootStroke.Color = EmeraldGreen; rebootStroke.Thickness = 1.5; rebootStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

RebootHubBtn.MouseButton1Click:Connect(function()
	KillAllScripts() -- Сносим всё старое
	task.wait(0.2)
	-- Качаем и запускаем чистую версию заново
	pcall(function()
		loadstring(game:HttpGet(GitHubRawURL, true))()
	end)
end)


-- Сетка кнопок (Опущена до 55 пикселей для идеального отображения рамок)
local ScrollGrid = Instance.new("ScrollingFrame", Main)
ScrollGrid.Size = UDim2.new(1, -20, 1, -65); ScrollGrid.Position = UDim2.new(0, 10, 0, 55)
ScrollGrid.BackgroundTransparency = 1; ScrollGrid.BorderSizePixel = 0
ScrollGrid.ScrollBarThickness = 4; ScrollGrid.ScrollBarImageColor3 = EmeraldGreen

local UIPadding = Instance.new("UIPadding", ScrollGrid)
UIPadding.PaddingTop = UDim.new(0, 5); UIPadding.PaddingBottom = UDim.new(0, 5)

local UIGridLayout = Instance.new("UIGridLayout", ScrollGrid)
UIGridLayout.CellSize = UDim2.new(0, 110, 0, 40); UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Генерация 16 кнопок
local Buttons = {}
for i = 1, 16 do
	local btn = Instance.new("TextButton", ScrollGrid)
	btn.Name = "Button"..i; btn.BackgroundColor3 = Black; btn.Font = Enum.Font.Arcade; btn.TextSize = 12; btn.BorderSizePixel = 0
	btn.LayoutOrder = i
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	
	local btnStk = Instance.new("UIStroke", btn)
	btnStk.Thickness = 1.5; btnStk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	
	btn.Text = ""
	btnStk.Color = Color3.fromRGB(45, 45, 45)
	
	Buttons[i] = btn
end

-- Топ-3 функциональных слота сверху
Buttons[1].Text = "1PCT [OFF]"; Buttons[1].TextColor3 = EmeraldGreen; Buttons[1]:FindFirstChildOfClass("UIStroke").Color = EmeraldGreen
Buttons[2].Text = "Noclip [OFF]"; Buttons[2].TextColor3 = EmeraldGreen; Buttons[2]:FindFirstChildOfClass("UIStroke").Color = EmeraldGreen
Buttons[3].Text = "Fling GUI"; Buttons[3].TextColor3 = EmeraldGreen; Buttons[3]:FindFirstChildOfClass("UIStroke").Color = EmeraldGreen

ScrollGrid.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 20)
UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScrollGrid.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 20)
end)


-- // 3. ОБЩИЙ ДРАГ И ТВИНИНГ ХАБА (Без лимитов на вылет за экран)
local open = false
local function animateOpen()
	Main.Visible = true; Main.Size = UDim2.new(0, 0, 0, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 380, 0, 280),
		Position = UDim2.new(0.5, -190, 0.5, -140)
	}):Play()
	task.spawn(function() typewrite(Title, "pyromorphite hub") end)
end

local function animateClose()
	Title.Text = ""
	local tween = TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	tween:Play()
	tween.Completed:Connect(function() Main.Visible = false end)
end

toggleButton.MouseButton1Click:Connect(function()
	if dragDistance < 5 then
		if open then animateClose() else animateOpen() end
		open = not open
	end
end)

local dragging, dragInput, dragStart, startPos
Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true; dragStart = input.Position; startPos = Main.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
Title.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		-- Свободный классический драг без математических clamp-зажимов
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)


-- ====================================================================
-- ФУНКЦИЯ 1: 1PCT TRACERS (3D FOV Cone)
-- ====================================================================
local FOV_ANGLE = math.rad(110)
local FOV_RANGE = 30
local SEGMENTS = 12
local HEIGHT_OFFSET = -1.5
local visualizers = {}

local function createVisualizer()
	local parts = {}
	for i = 1, SEGMENTS do
		local wedge = Instance.new("WedgePart")
		wedge.Anchored = true; wedge.CanCollide = false
		wedge.Material = Enum.Material.Neon; wedge.Color = EmeraldGreen
		wedge.Transparency = 0.25; wedge.CastShadow = false
		wedge.Name = "FOVTracer"
		wedge.Parent = Workspace
		parts[i] = {wedge = wedge, Line1 = nil, Line2 = nil}
	end
	return parts
end

local function updateVisualizer(player)
	if not visualEnabled or player == Player then return end
	if not player.Character or not player.Character:FindFirstChild("Head") then return end
	local head = player.Character.Head
	local parts = visualizers[player] or createVisualizer()
	visualizers[player] = parts

	local isObserved = Camera.CameraSubject and Camera.CameraSubject:IsDescendantOf(player.Character)
	local viewCF = isObserved and Camera.CFrame or head.CFrame
	local origin = (isObserved and Camera.CFrame.Position or head.Position) + Vector3.new(0, HEIGHT_OFFSET, 0)
	local startAngle = -FOV_ANGLE / 2

	for i = 1, SEGMENTS do
		local angle1 = startAngle + (i - 1) * (FOV_ANGLE / SEGMENTS)
		local angle2 = startAngle + i * (FOV_ANGLE / SEGMENTS)
		local midDir = ((viewCF * CFrame.Angles(0, angle1, 0)).LookVector + (viewCF * CFrame.Angles(0, angle2, 0)).LookVector).Unit
		local length = FOV_RANGE
		local width = length * math.tan(FOV_ANGLE / SEGMENTS)

		local wedge = parts[i].wedge
		if wedge then
			wedge.Size = Vector3.new(width * 1.2, 0.5, length) 
			wedge.CFrame = CFrame.new(origin + midDir * (length / 2), origin) * CFrame.Angles(math.rad(-90), 0, 0)
		end

		local function updateLine(lineKey, from, to)
			local beam = parts[i][lineKey]
			if not beam or not beam.Parent then
				beam = Instance.new("Part", Workspace)
				beam.Anchored = true; beam.CanCollide = false; beam.Transparency = 0
				beam.Material = Enum.Material.Neon; beam.Color = EmeraldGreen
				parts[i][lineKey] = beam
			end
			beam.Size = Vector3.new(0.05, 0.05, (from - to).Magnitude)
			beam.CFrame = CFrame.new((from + to) / 2, to) * CFrame.Angles(0, math.pi, 0)
		end

		if wedge then
			updateLine("Line1", wedge.Position + (wedge.CFrame.RightVector * wedge.Size.X / 2), head.Position + Vector3.new(0, 0.25, 0))
			updateLine("Line2", wedge.Position - (wedge.CFrame.RightVector * wedge.Size.X / 2), head.Position + Vector3.new(0, 0.25, 0))
		end
	end
end

Buttons[1].MouseButton1Click:Connect(function()
	visualEnabled = not visualEnabled
	if visualEnabled then
		Buttons[1].Text = "1PCT [ON]"
		Buttons[1].TextColor3 = ActiveRed
		Buttons[1]:FindFirstChildOfClass("UIStroke").Color = ActiveRed
	else
		Buttons[1].Text = "1PCT [OFF]"
		Buttons[1].TextColor3 = EmeraldGreen
		Buttons[1]:FindFirstChildOfClass("UIStroke").Color = EmeraldGreen
		-- Ручная зачистка при выключении
		for _, parts in pairs(visualizers) do
			for _, obj in ipairs(parts) do
				if obj.wedge then obj.wedge:Destroy() end
				if obj.Line1 then obj.Line1:Destroy() end
				if obj.Line2 then obj.Line2:Destroy() end
			end
		end
		visualizers = {}
	end
end)

RunService.RenderStepped:Connect(function()
	if visualEnabled then
		for _, p in ipairs(Players:GetPlayers()) do updateVisualizer(p) end
	end
end)


-- ====================================================================
-- ФУНКЦИЯ 2: NOCLIP
-- ====================================================================
Buttons[2].MouseButton1Click:Connect(function()
	noclip = not noclip
	if noclip then
		Buttons[2].Text = "Noclip [ON]"
		Buttons[2].TextColor3 = ActiveRed
		Buttons[2]:FindFirstChildOfClass("UIStroke").Color = ActiveRed
		
		noclipConnection = RunService.Stepped:Connect(function()
			if Player.Character then
				for _, part in ipairs(Player.Character:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end)
	else
		Buttons[2].Text = "Noclip [OFF]"
		Buttons[2].TextColor3 = EmeraldGreen
		Buttons[2]:FindFirstChildOfClass("UIStroke").Color = EmeraldGreen
		
		if noclipConnection then 
			noclipConnection:Disconnect() 
			noclipConnection = nil
		end
		
		task.spawn(function()
			local char = Player.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") and (part.Name == "HumanoidRootPart" or part.Name == "UpperTorso" or part.Name == "LowerTorso" or part.Name == "Torso" or part.Name == "Head") then
						part.CanCollide = true
					end
				end
			end
		end)
	end
end)


-- ====================================================================
-- ФУНКЦИЯ 3: ВСТРОЕННЫЙ PYROMORPHITE FLING GUI
-- ====================================================================
local function CreateEmbeddedFlingGUI()
	local FlingGui = Instance.new("ScreenGui", TargetParent)
	FlingGui.Name = "EmbeddedFlingGUI"
	FlingGui.ResetOnSpawn = false

	local FMain = Instance.new("Frame", FlingGui)
	FMain.Size = UDim2.new(0, 300, 0, 350)
	FMain.Position = UDim2.new(0.5, -150, 0.5, -175)
	FMain.BackgroundColor3 = DarkGray; FMain.BorderSizePixel = 0; FMain.Active = true; FMain.Draggable = true
	Instance.new("UICorner", FMain).CornerRadius = UDim.new(0, 12)

	local fMainStroke = Instance.new("UIStroke", FMain)
	fMainStroke.Color = EmeraldGreen; fMainStroke.Thickness = 2; fMainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local TitleBar = Instance.new("Frame", FMain)
	TitleBar.Size = UDim2.new(1, 0, 0, 30); TitleBar.BackgroundColor3 = Black; TitleBar.BorderSizePixel = 0

	local FTitle = Instance.new("TextLabel", TitleBar)
	FTitle.Size = UDim2.new(1, -30, 1, 0); FTitle.BackgroundTransparency = 1
	FTitle.Text = "Pyromorphite Fling GUI"; FTitle.TextColor3 = EmeraldGreen; FTitle.Font = Enum.Font.Arcade; FTitle.TextSize = 16

	local CloseButton = Instance.new("TextButton", TitleBar)
	CloseButton.Position = UDim2.new(1, -30, 0, 0); CloseButton.Size = UDim2.new(0, 30, 0, 30)
	CloseButton.BackgroundColor3 = Black; CloseButton.Text = "X"; CloseButton.TextColor3 = EmeraldGreen
	CloseButton.Font = Enum.Font.Arcade; CloseButton.TextSize = 18

	local StatusLabel = Instance.new("TextLabel", FMain)
	StatusLabel.Position = UDim2.new(0, 10, 0, 40); StatusLabel.Size = UDim2.new(1, -20, 0, 25)
	StatusLabel.BackgroundTransparency = 1; StatusLabel.Text = "Select targets to fling"
	StatusLabel.TextColor3 = EmeraldGreen; StatusLabel.Font = Enum.Font.Arcade; StatusLabel.TextSize = 14

	local SelectionFrame = Instance.new("Frame", FMain)
	SelectionFrame.Position = UDim2.new(0, 10, 0, 70); SelectionFrame.Size = UDim2.new(1, -20, 0, 200); SelectionFrame.BackgroundColor3 = Black

	local PlayerScrollFrame = Instance.new("ScrollingFrame", SelectionFrame)
	PlayerScrollFrame.Position = UDim2.new(0, 5, 0, 5); PlayerScrollFrame.Size = UDim2.new(1, -10, 1, -10); PlayerScrollFrame.BackgroundTransparency = 1

	local StartButton = Instance.new("TextButton", FMain)
	StartButton.Position = UDim2.new(0, 10, 0, 280); StartButton.Size = UDim2.new(0.5, -15, 0, 40)
	StartButton.BackgroundColor3 = Black; StartButton.Text = "START FLING"; StartButton.TextColor3 = EmeraldGreen
	StartButton.Font = Enum.Font.Arcade; StartButton.TextSize = 14

	local StopButton = Instance.new("TextButton", FMain)
	StopButton.Position = UDim2.new(0.5, 5, 0, 280); StopButton.Size = UDim2.new(0.5, -15, 0, 40)
	StopButton.BackgroundColor3 = Black; StopButton.Text = "STOP FLING"; StopButton.TextColor3 = EmeraldGreen
	StopButton.Font = Enum.Font.Arcade; StopButton.TextSize = 14

	local SelectedTargets = {}
	local PlayerCheckboxes = {}
	local FlingActive = false

	local function Message(t, txt, dur)
		pcall(function() StarterGui:SetCore("SendNotification", {Title = t, Text = txt, Duration = dur or 3}) end)
	end

	local function UpdateStatus()
		local count = 0 for _ in pairs(SelectedTargets) do count = count + 1 end
		StatusLabel.Text = FlingActive and "Flinging " .. count .. " target(s)" or count .. " target(s) selected"
	end

	local function RefreshPlayerList()
		for _, child in pairs(PlayerScrollFrame:GetChildren()) do child:Destroy() end
		PlayerCheckboxes = {}
		local yPosition = 5
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player then
				local PlayerEntry = Instance.new("Frame", PlayerScrollFrame)
				PlayerEntry.Size = UDim2.new(1, -10, 0, 30); PlayerEntry.Position = UDim2.new(0, 5, 0, yPosition); PlayerEntry.BackgroundColor3 = Black
				
				local ClickArea = Instance.new("TextButton", PlayerEntry)
				ClickArea.Size = UDim2.new(1, 0, 1, 0); ClickArea.BackgroundTransparency = 1; ClickArea.Text = p.Name
				ClickArea.TextColor3 = EmeraldGreen; ClickArea.TextXAlignment = Enum.TextXAlignment.Left; ClickArea.Font = Enum.Font.Arcade

				local Checkmark = Instance.new("TextLabel", PlayerEntry)
				Checkmark.Size = UDim2.new(0, 30, 1, 0); Checkmark.Position = UDim2.new(1, -30, 0, 0); Checkmark.BackgroundTransparency = 1
				Checkmark.Text = "v"; Checkmark.TextColor3 = EmeraldGreen; Checkmark.Visible = SelectedTargets[p.Name] ~= nil; Checkmark.Font = Enum.Font.Arcade

				ClickArea.MouseButton1Click:Connect(function()
					if SelectedTargets[p.Name] then
						SelectedTargets[p.Name] = nil; Checkmark.Visible = false
					else
						SelectedTargets[p.Name] = p; Checkmark.Visible = true
					end
					UpdateStatus()
				end)
				yPosition = yPosition + 35
			end
		end
		PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition + 5)
	end

	local function SkidFling(TargetPlayer)
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local RootPart = Humanoid and Humanoid.RootPart
		local TCharacter = TargetPla