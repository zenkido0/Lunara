local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Lunara",
   Icon = 111530409813861, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Threads of Twilight...",
   LoadingSubtitle = "Tracing moonlit paths…",
   ShowText = "Lunara", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Moonlight"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "https://discord.gg/cRFErEWv93", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Lunara Key",
      Subtitle = "join my discord server to get key",
      Note = "https://discord.gg/cRFErEWv93", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"LunaraOntop123"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Main", 114045349662476) -- Title, Image

local Toggle = Tab:CreateToggle({
   Name = "Autofarm",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       autoFarmActive = Value
       if Value then
           spawn(function()
               while autoFarmActive do
                   for i, v in pairs(workspace:GetChildren()) do
                       if v.ClassName == "Model" and v:FindFirstChild("Container") or v.Name == "PortCraneOversized" then
                           v:Destroy()
                       end
                   end
                   wait(1)
               end
           end)
           spawn(function()
               while autoFarmActive do
                   local hum = game.Players.LocalPlayer.Character.Humanoid
                   local car = hum.SeatPart.Parent
                   car.PrimaryPart = car.Body:FindFirstChild("#Weight")
                   if not getfenv().first then
                       if workspace.Workspace:FindFirstChild("Buildings") then
                           workspace.Workspace.Buildings:Destroy()
                       end
                       car:PivotTo(CFrame.new(Vector3.new(-7594.541015625, -3.513848304748535, 5130.95263671875), Vector3.new(-6205.29833984375, -3.5030133724212646, 8219.853515625)))
                       wait(0.1)
                   end
                   car.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
                   getfenv().first = true
                   local location = Vector3.new(-6205.29833984375, 100, 8219.853515625)
                   repeat
                       task.wait()
                       mathlock = 550
                       car.PrimaryPart.Velocity = car.PrimaryPart.CFrame.LookVector * mathlock
                       car:PivotTo(CFrame.new(car.PrimaryPart.Position, location))
                   until game.Players.LocalPlayer:DistanceFromCharacter(location) < 50 or not autoFarmActive
                   car.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
                   location = Vector3.new(-7594.541015625, 100, 5130.95263671875)
                   repeat
                       task.wait()
                       mathlock = 550
                       car.PrimaryPart.Velocity = car.PrimaryPart.CFrame.LookVector * mathlock
                       car:PivotTo(CFrame.new(car.PrimaryPart.Position, location))
                   until game.Players.LocalPlayer:DistanceFromCharacter(location) < 50 or not autoFarmActive
                   car.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
               end
           end)
       else
           -- Optionally, you can add code to handle what happens when the toggle is turned off
       end
   end,
})

local Button = Tab:CreateButton({
   Name = "BoostFPS",
   Callback = function()
      -- The function that takes place when the button is pressed

      -- SUPER FAST MODE
      local Lighting = game:GetService("Lighting")
      local workspace = game:GetService("Workspace")

      local REMOVE_MESHES = false
      local DELETE_PARTICLES = true
      local DELETE_UI_3D = true
      local DELETE_HIGHLIGHTS = true

      local function nukeVisualCost(obj)
          if obj:IsA("BasePart") then
              obj.Material = Enum.Material.SmoothPlastic
              obj.Reflectance = 0
              obj.CastShadow = false

              if obj.Material == Enum.Material.Glass or obj.Material == Enum.Material.Neon then
                  obj.Material = Enum.Material.SmoothPlastic
              end

              if REMOVE_MESHES and obj:IsA("MeshPart") then
                  obj.Transparency = 1
              end
          end

          if obj:IsA("Texture") or obj:IsA("Decal") then
              obj.Transparency = 1
          end

          if DELETE_PARTICLES and (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")) then
              obj.Enabled = false
          end

          if DELETE_UI_3D and (obj:IsA("BillboardGui") or obj:IsA("SurfaceGui")) then
              obj.Enabled = false
          end

          if DELETE_HIGHLIGHTS and obj:IsA("Highlight") then
              obj.Enabled = false
          end
      end

      local function sweepWorld()
          for _, obj in ipairs(workspace:GetDescendants()) do
              nukeVisualCost(obj)
          end
      end

      local function flattenLighting()
          Lighting.GlobalShadows = false
          Lighting.ShadowSoftness = 0
          Lighting.Brightness = 1
          Lighting.Ambient = Color3.new(1,1,1)
          Lighting.OutdoorAmbient = Color3.new(1,1,1)

          for _, fx in ipairs(Lighting:GetChildren()) do
              if fx:IsA("PostEffect") then
                  fx.Enabled = false
              end
          end
      end

      local function simplifyTerrain()
          local terrain = workspace:FindFirstChildOfClass("Terrain")
          if terrain then
              terrain.WaterReflectance = 0
              terrain.WaterTransparency = 1
              terrain.WaterWaveSize = 0
              terrain.WaterWaveSpeed = 0
              terrain.WaterColor = Color3.new(1,1,1)
          end
      end

      flattenLighting()
      simplifyTerrain()
      sweepWorld()
      workspace.DescendantAdded:Connect(nukeVisualCost)

      print("SUPER FAST MODE ENABLED.")
   end,
})

local player = game.Players.LocalPlayer
local sound = Instance.new("Sound")
sound.Parent = player:WaitForChild("PlayerGui")
sound.Volume = 10
sound.Looped = true

local function PlayMusic(soundId)
    if not tonumber(soundId) then
        warn("Invalid SoundId")
        return
    end
    sound.SoundId = "rbxassetid://" .. soundId
    sound:Play()
end

local Input = Tab:CreateInput({
    Name = "Music player",
    CurrentValue = "",
    PlaceholderText = "Put a valid audio id",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
        -- Call PlayMusic with the input as the sound ID
        PlayMusic(Text)
    end,
})
