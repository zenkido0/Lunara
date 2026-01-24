local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- gui setup
local gui = Instance.new("ScreenGui")
gui.Name = "WindEzGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- dragging
local dragging, dragStart, startPos, dragInput

local function updateInput(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		updateInput(input)
	end
end)

-- title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.Text = "wind.ez"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0.4, 0)
button.Position = UDim2.new(0.1, 0, 0.4, 0)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.Font = Enum.Font.SourceSans
button.TextSize = 20
button.Text = "off"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 5)
btnCorner.Parent = button

-- logic
local isOn = false
local connections = {}

-- new humanized tag name
local TAG = "windnocollide"

local function shouldAffect(part)
	if not part:IsA("BasePart") then return false end
	local n = part.Name:lower()

	if n == "part" or n == "car" then
		return true
	end

	if part:FindFirstAncestor("NPCVehicles") then
		return true
	end

	return false
end

local function disableCollision(part)
	-- original collision state
	if part:GetAttribute("wind_originalcollide") == nil then
		part:SetAttribute("wind_originalcollide", part.CanCollide)
	end

	-- original transparency
	if part:GetAttribute("wind_originaltransparency") == nil then
		part:SetAttribute("wind_originaltransparency", part.Transparency)
	end

	part.CanCollide = false
	part.Transparency = 0.6

	CollectionService:AddTag(part, TAG)
end

local function restoreCollision(part)
	local c = part:GetAttribute("wind_originalcollide")
	if c ~= nil then
		part.CanCollide = c
		part:SetAttribute("wind_originalcollide", nil)
	end

	local t = part:GetAttribute("wind_originaltransparency")
	if t ~= nil then
		part.Transparency = t
		part:SetAttribute("wind_originaltransparency", nil)
	end

	CollectionService:RemoveTag(part, TAG)
end

local function applyToFolder(folder)
	for _, obj in ipairs(folder:GetDescendants()) do
		if shouldAffect(obj) then
			disableCollision(obj)
		end
	end

	local c = folder.DescendantAdded:Connect(function(newObj)
		if isOn and shouldAffect(newObj) then
			disableCollision(newObj)
		end
	end)

	table.insert(connections, c)
end

local function enable()
	local npc = Workspace:FindFirstChild("NPCVehicles")
	if npc then
		applyToFolder(npc)
	end

	for _, v in ipairs(Workspace:GetChildren()) do
		if v:IsA("Folder") and tonumber(v.Name) then
			applyToFolder(v)
		end
	end

	local wsC = Workspace.ChildAdded:Connect(function(child)
		if not isOn then return end
		if child.Name == "NPCVehicles" or (child:IsA("Folder") and tonumber(child.Name)) then
			applyToFolder(child)
		end
	end)

	table.insert(connections, wsC)
end

local function disable()
	for _, part in ipairs(CollectionService:GetTagged(TAG)) do
		restoreCollision(part)
	end

	for _, c in ipairs(connections) do
		c:Disconnect()
	end

	connections = {}
end

button.MouseButton1Click:Connect(function()
	isOn = not isOn

	if isOn then
		button.Text = "on"
		button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		button.TextColor3 = Color3.fromRGB(0, 0, 0)

		StarterGui:SetCore("SendNotification", {
			Title = "wind.ez",
			Text = "wind.ez is now active – npc car collision disabled",
			Duration = 5
		})

		enable()
	else
		button.Text = "off"
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		button.TextColor3 = Color3.fromRGB(255, 255, 255)

		StarterGui:SetCore("SendNotification", {
			Title = "wind.ez",
			Text = "wind.ez turned off – npc car collision restored",
			Duration = 5
		})

		disable()
	end
end)
