-- // Pyromorphite Hub v3.3 — Pixel Arcade Edition (Fling GUI Upgrade)
-- Step-by-step fix: Added Select/Clear All buttons, fixed Close button corners, 100% English.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Color Palette
local EmeraldGreen = Color3.fromRGB(0, 255, 100)
local ActiveRed = Color3.fromRGB(255, 50, 50)
local DarkGray = Color3.fromRGB(30, 30, 30)
local Black = Color3.fromRGB(15, 15, 15)

-- Safe UI Parent
local TargetParent = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui", TargetParent)
ScreenGui.Name = "PyromorphiteHub"
ScreenGui.ResetOnSpawn = false

-- Global States
local visualEnabled = false
local visualizers = {}
local noclip = false
local noclipConnection = nil

-- // 1. TOGGLE BUTTON ("P")
local toggleButton = Instance.new("TextButton", ScreenGui)
toggleButton.Size = UDim2.new(0, 38, 0, 38)
toggleButton.Position = UDim2.new(0, 40, 0, 150)
toggleButton.BackgroundColor3 = Black
toggleButton.Text = "P"
toggleButton.TextColor3 = EmeraldGreen
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.Arcade
toggleButton.BorderSizePixel = 0
toggleButton.ZIndex = 10
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(1, 0)

local btnStroke = Instance.new("UIStroke", toggleButton)
btnStroke.Color = EmeraldGreen; btnStroke.Thickness = 2; btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local btnDragging, btnDragInput, btnDragStart, btnStartPos
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


-- // 2. MAIN HUB WINDOW
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 280)
Main.Position = UDim2.new(0.5, -190, 0.5, -140)
Main.BackgroundColor3 = DarkGray; Main.BorderSizePixel = 0; Main.Visible = false; Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = EmeraldGreen; mainStroke.Thickness = 2; mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Title Label
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1; Title.Text = ""; Title.TextColor3 = EmeraldGreen
Title.Font = Enum.Font.Arcade; Title.TextSize = 22

-- Typewriter Effect
local function typewrite(label, text)
	label.Text = ""
	for i = 1, #text do
		label.Text = string.sub(text, 1, i)
		task.wait(0.04)
	end
end

-- Button Grid Scrolling Frame
local ScrollGrid = Instance.new("ScrollingFrame", Main)
ScrollGrid.Size = UDim2.new(1, -20, 1, -60); ScrollGrid.Position = UDim2.new(0, 10, 0, 50)
ScrollGrid.BackgroundTransparency = 1; ScrollGrid.BorderSizePixel = 0
ScrollGrid.ScrollBarThickness = 4; ScrollGrid.ScrollBarImageColor3 = EmeraldGreen

local UIPadding = Instance.new("UIPadding", ScrollGrid)
UIPadding.PaddingTop = UDim.new(0, 5); UIPadding.PaddingBottom = UDim.new(0, 5)

local UIGridLayout = Instance.new("UIGridLayout", ScrollGrid)
UIGridLayout.CellSize = UDim2.new(0, 110, 0, 40); UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Generate 16 Slots
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

-- Configure Active Slots Text
Buttons[1].Text = "1PCT [OFF]"; Buttons[1].TextColor3 = EmeraldGreen; Buttons[1]:FindFirstChildOfClass("UIStroke").Color = EmeraldGreen
Buttons[2].Text = "Noclip [OFF]"; Buttons[2].TextColor3 = EmeraldGreen; Buttons[2]:FindFirstChildOfClass("UIStroke").Color = EmeraldGreen
Buttons[3].Text = "Fling GUI"; Buttons[3].TextColor3 = EmeraldGreen; Buttons[3]:FindFirstChildOfClass("UIStroke").Color = EmeraldGreen

ScrollGrid.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 20)
UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScrollGrid.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 20)
end)


-- // 3. OPEN/CLOSE ANIMATIONS
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

-- Window Drag System
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
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)


-- ====================================================================
-- FUNCTION 1: 1PCT TRACERS (3D FOV Cone)
-- ====================================================================
local FOV_ANGLE = math.rad(110)
local FOV_RANGE = 30
local SEGMENTS = 12
local HEIGHT_OFFSET = -1.5

local function createVisualizer()
	local parts = {}
	for i = 1, SEGMENTS do
		local wedge = Instance.new("WedgePart")
		wedge.Anchored = true; wedge.CanCollide = false
		wedge.Material = Enum.Material.Neon; wedge.Color = EmeraldGreen
		wedge.Transparency = 0.25; wedge.CastShadow = false
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

local function clearAllVisuals()
	for _, parts in pairs(visualizers) do
		for _, obj in ipairs(parts) do
			if obj.wedge then obj.wedge:Destroy() end
			if obj.Line1 then obj.Line1:Destroy() end
			if obj.Line2 then obj.Line2:Destroy() end
		end
	end
	visualizers = {}
end

Buttons[1].MouseButton1Click:Connect(function()
	visualEnabled = not visualEnabled
	if visualEnabled then
		Buttons[1].Text = "1PCT [ON]"; Buttons[1].TextColor3 = ActiveRed
		Buttons[1]:FindFirstChildOfClass("UIStroke").Color = ActiveRed
	else
		Buttons[1].Text = "1PCT [OFF]"; Buttons[1].TextColor3 = EmeraldGreen
		Buttons[1]:FindFirstChildOfClass("UIStroke").Color = EmeraldGreen
		clearAllVisuals()
	end
end)

RunService.RenderStepped:Connect(function()
	if visualEnabled then
		for _, p in ipairs(Players:GetPlayers()) do updateVisualizer(p) end
	end
end)


-- ====================================================================
-- FUNCTION 2: NOCLIP (With Collision Fix Toggle)
-- ====================================================================
Buttons[2].MouseButton1Click:Connect(function()
	noclip = not noclip
	if noclip then
		Buttons[2].Text = "Noclip [ON]"; Buttons[2].TextColor3 = ActiveRed
		Buttons[2]:FindFirstChildOfClass("UIStroke").Color = ActiveRed
		noclipConnection = RunService.Stepped:Connect(function()
			if Player.Character then
				for _, part in ipairs(Player.Character:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end)
	else
		Buttons[2].Text = "Noclip [OFF]"; Buttons[2].TextColor3 = EmeraldGreen
		Buttons[2]:FindFirstChildOfClass("UIStroke").Color = EmeraldGreen
		if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
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
-- FUNCTION 3: UPGRADED PYROMORPHITE FLING GUI (100% English & Smooth Corners)
-- ====================================================================
local function CreateEmbeddedFlingGUI()
	local FlingGui = Instance.new("ScreenGui", TargetParent)
	FlingGui.Name = "EmbeddedFlingGUI"; FlingGui.ResetOnSpawn = false

	local FMain = Instance.new("Frame", FlingGui)
	FMain.Size = UDim2.new(0, 320, 0, 390) -- Slightly taller for utility buttons
	FMain.Position = UDim2.new(0.5, -160, 0.5, -195)
	FMain.BackgroundColor3 = DarkGray; FMain.BorderSizePixel = 0; FMain.Active = true; FMain.Draggable = true
	Instance.new("UICorner", FMain).CornerRadius = UDim.new(0, 12)

	local fMainStroke = Instance.new("UIStroke", FMain)
	fMainStroke.Color = EmeraldGreen; fMainStroke.Thickness = 2; fMainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local TitleBar = Instance.new("Frame", FMain)
	TitleBar.Size = UDim2.new(1, 0, 0, 30); TitleBar.BackgroundColor3 = Black; TitleBar.BorderSizePixel = 0
	Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12) -- Matches main window

	-- Extra frame to hide bottom corners of title bar for design cohesion
	local TitleFill = Instance.new("Frame", TitleBar)
	TitleFill.Size = UDim2.new(1, 0, 0, 10); TitleFill.Position = UDim2.new(0, 0, 1, -10)
	TitleFill.BackgroundColor3 = Black; TitleFill.BorderSizePixel = 0

	local FTitle = Instance.new("TextLabel", TitleBar)
	FTitle.Size = UDim2.new(1, -35, 1, 0); FTitle.BackgroundTransparency = 1
	FTitle.Text = "Pyromorphite Fling GUI"; FTitle.TextColor3 = EmeraldGreen; FTitle.Font = Enum.Font.Arcade; FTitle.TextSize = 16

	-- Close Button [X] with Fixed Corner Radii
	local CloseButton = Instance.new("TextButton", TitleBar)
	CloseButton.Position = UDim2.new(1, -30, 0, 2)
	CloseButton.Size = UDim2.new(0, 26, 0, 26)
	CloseButton.BackgroundColor3 = Black; CloseButton.Text = "X"; CloseButton.TextColor3 = ActiveRed
	CloseButton.Font = Enum.Font.Arcade; CloseButton.TextSize = 16; CloseButton.ZIndex = 5
	Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6) -- FIXED: Rounded edge fix
	local clStk = Instance.new("UIStroke", CloseButton)
	clStk.Color = ActiveRed; clStk.Thickness = 1.5

	local StatusLabel = Instance.new("TextLabel", FMain)
	StatusLabel.Position = UDim2.new(0, 10, 0, 40); StatusLabel.Size = UDim2.new(1, -20, 0, 25)
	StatusLabel.BackgroundTransparency = 1; StatusLabel.Text = "Select targets to fling"
	StatusLabel.TextColor3 = EmeraldGreen; StatusLabel.Font = Enum.Font.Arcade; StatusLabel.TextSize = 14

	local SelectionFrame = Instance.new("Frame", FMain)
	SelectionFrame.Position = UDim2.new(0, 10, 0, 70); SelectionFrame.Size = UDim2.new(1, -20, 0, 180); SelectionFrame.BackgroundColor3 = Black
	Instance.new("UICorner", SelectionFrame).CornerRadius = UDim.new(0, 8)

	local PlayerScrollFrame = Instance.new("ScrollingFrame", SelectionFrame)
	PlayerScrollFrame.Position = UDim2.new(0, 5, 0, 5); PlayerScrollFrame.Size = UDim2.new(1, -10, 1, -10); PlayerScrollFrame.BackgroundTransparency = 1
	PlayerScrollFrame.ScrollBarThickness = 4; PlayerScrollFrame.ScrollBarImageColor3 = EmeraldGreen

	-- UTILITY PANELS: Select All / Clear All (English layout)
	local SelectAllBtn = Instance.new("TextButton", FMain)
	SelectAllBtn.Position = UDim2.new(0, 10, 0, 260); SelectAllBtn.Size = UDim2.new(0.5, -15, 0, 30)
	SelectAllBtn.BackgroundColor3 = Black; SelectAllBtn.Text = "SELECT ALL"; SelectAllBtn.TextColor3 = EmeraldGreen
	SelectAllBtn.Font = Enum.Font.Arcade; SelectAllBtn.TextSize = 12
	Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0, 6)
	local saStk = Instance.new("UIStroke", SelectAllBtn)
	saStk.Color = EmeraldGreen; saStk.Thickness = 1

	local ClearAllBtn = Instance.new("TextButton", FMain)
	ClearAllBtn.Position = UDim2.new(0.5, 5, 0, 260); ClearAllBtn.Size = UDim2.new(0.5, -15, 0, 30)
	ClearAllBtn.BackgroundColor3 = Black; ClearAllBtn.Text = "CLEAR ALL"; ClearAllBtn.TextColor3 = EmeraldGreen
	ClearAllBtn.Font = Enum.Font.Arcade; ClearAllBtn.TextSize = 12
	Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0, 6)
	local caStk = Instance.new("UIStroke", ClearAllBtn)
	caStk.Color = EmeraldGreen; caStk.Thickness = 1

	-- Action Buttons: Start / Stop
	local StartButton = Instance.new("TextButton", FMain)
	StartButton.Position = UDim2.new(0, 10, 0, 305); StartButton.Size = UDim2.new(0.5, -15, 0, 40)
	StartButton.BackgroundColor3 = Black; StartButton.Text = "START FLING"; StartButton.TextColor3 = EmeraldGreen
	StartButton.Font = Enum.Font.Arcade; StartButton.TextSize = 14
	Instance.new("UICorner", StartButton).CornerRadius = UDim.new(0, 8)
	local startStk = Instance.new("UIStroke", StartButton)
	startStk.Color = EmeraldGreen; startStk.Thickness = 1.5

	local StopButton = Instance.new("TextButton", FMain)
	StopButton.Position = UDim2.new(0.5, 5, 0, 305); StopButton.Size = UDim2.new(0.5, -15, 0, 40)
	StopButton.BackgroundColor3 = Black; StopButton.Text = "STOP FLING"; StopButton.TextColor3 = EmeraldGreen
	StopButton.Font = Enum.Font.Arcade; StopButton.TextSize = 14
	Instance.new("UICorner", StopButton).CornerRadius = UDim.new(0, 8)
	local stopStk = Instance.new("UIStroke", StopButton)
	stopStk.Color = EmeraldGreen; stopStk.Thickness = 1.5

	local SelectedTargets = {}
	local CheckboxObjects = {}
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
		CheckboxObjects = {}
		local yPosition = 5
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player then
				local PlayerEntry = Instance.new("Frame", PlayerScrollFrame)
				PlayerEntry.Size = UDim2.new(1, -10, 0, 30); PlayerEntry.Position = UDim2.new(0, 5, 0, yPosition); PlayerEntry.BackgroundColor3 = Black
				Instance.new("UICorner", PlayerEntry).CornerRadius = UDim.new(0, 4)
				
				local ClickArea = Instance.new("TextButton", PlayerEntry)
				ClickArea.Size = UDim2.new(1, 0, 1, 0); ClickArea.BackgroundTransparency = 1; ClickArea.Text = "  " .. p.Name
				ClickArea.TextColor3 = EmeraldGreen; ClickArea.TextXAlignment = Enum.TextXAlignment.Left; ClickArea.Font = Enum.Font.Arcade

				local Checkmark = Instance.new("TextLabel", PlayerEntry)
				Checkmark.Size = UDim2.new(0, 30, 1, 0); Checkmark.Position = UDim2.new(1, -30, 0, 0); Checkmark.BackgroundTransparency = 1
				Checkmark.Text = "[X]"; Checkmark.TextColor3 = ActiveRed; Checkmark.Visible = SelectedTargets[p.Name] ~= nil; Checkmark.Font = Enum.Font.Arcade

				CheckboxObjects[p.Name] = Checkmark

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

	-- Utility Click Connections
	SelectAllBtn.MouseButton1Click:Connect(function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player then
				SelectedTargets[p.Name] = p
				if CheckboxObjects[p.Name] then CheckboxObjects[p.Name].Visible = true end
			end
		end
		UpdateStatus()
	end)

	ClearAllBtn.MouseButton1Click:Connect(function()
		SelectedTargets = {}
		for _, chk in pairs(CheckboxObjects) do chk.Visible = false end
		UpdateStatus()
	end)

	local function SkidFling(TargetPlayer)