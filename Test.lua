local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Lunara",
   Icon = 111530409813861,
   LoadingTitle = "Threads of Twilight...",
   LoadingSubtitle = "Tracing moonlit paths…",
   ShowText = "Lunara",
   Theme = "Amethyst",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Moonlight"
   },
   Discord = {
      Enabled = false,
      Invite = "https://discord.gg/cRFErEWv93",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "Lunara Key",
      Subtitle = "join my discord server to get key",
      Note = "https://discord.gg/cRFErEWv93",
      FileName = "Key",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"LunaraOntop123"}
   }
})

local Tab = Window:CreateTab("Main", 114045349662476)

local Toggle = Tab:CreateToggle({
    Name = "Auto Vehicle Tween",
    CurrentValue = false,
    Flag = "AutoTweenToggle",
    Callback = function(Value)
        autoFarmActive = Value

        if autoFarmActive then
            spawn(function()
                local checkpoints = {
                    Vector3.new(-8472.7, 1.7, 1750.7),
                    Vector3.new(-8680.8, 1.7, 1540.1),
                    Vector3.new(-8885.7, 1.7, 1324.1),
                    Vector3.new(-9096.2, 1.8, 1119.8),
                    Vector3.new(-9318.4, 1.7, 907.5),
                    Vector3.new(-9532.9, 1.7, 686.9),
                    Vector3.new(-9744.1, 1.8, 479.0),
                    Vector3.new(-9955.3, 1.8, 264.7),
                    Vector3.new(-10160.1, 1.8, 56.2),
                    Vector3.new(-10376.1, 1.7, -160.1),
                    Vector3.new(-10587.7, 1.7, -375.6),
                    Vector3.new(-10797.5, 1.8, -584.4),
                    Vector3.new(-11009.2, 1.7, -796.2),
                    Vector3.new(-11220.5, 1.7, -1007.3),
                    Vector3.new(-11436.4, 1.8, -1222.0),
                    Vector3.new(-11647.4, 1.8, -1435.4),
                    Vector3.new(-11854.0, 1.7, -1641.6),
                    Vector3.new(-12070.2, 1.8, -1855.8),
                    Vector3.new(-12290.0, 1.7, -2061.5),  -- New checkpoint 1
                    Vector3.new(-12625.8, 1.7, -2396.9)   -- New checkpoint 2
                }

                for i, v in pairs(workspace:GetChildren()) do
                    if v.ClassName == "Model" and (v:FindFirstChild("Container") or v.Name == "PortCraneOversized") then
                        v:Destroy()
                    end
                end

                local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then
                    local car = hum.SeatPart.Parent
                    car.PrimaryPart = car.Body:FindFirstChild("#Weight")

                    for _, checkpoint in ipairs(checkpoints) do
                        if not autoFarmActive then break end
                        local location = checkpoint + Vector3.new(0, 2, 0)
                        repeat
                            task.wait()
                            local mathlock = 448
                            car.PrimaryPart.Velocity = (location - car.PrimaryPart.Position).Unit * mathlock
                            car:PivotTo(CFrame.new(car.PrimaryPart.Position, location))
                        until (car.PrimaryPart.Position - location).Magnitude < 10 or not autoFarmActive
                        car.PrimaryPart.Velocity = Vector3.new(0,0,0)
                    end
                end
            end)
        end
    end,
})

local Button = Tab:CreateButton({
   Name = "BoostFPS",
   Callback = function()
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
        PlayMusic(Text)
    end,
})
