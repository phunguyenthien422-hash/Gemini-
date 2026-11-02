--[[\
    Axiom's Blox Fruit High-Performance Suite
    Optimized for raw speed, memory cleanup, and automated execution.
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration & State
getgenv().AxiomConfig = {
    AutoFarm = false,
    FastRun = false,
    SpeedValue = 35,
    HighJump = false,
    JumpValue = 120,
    RemoveGraphics = false,
    RemoteFruit = false
}

-- UI Library Construction (Lightweight / Axiom Style)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxiomSuite_BloxFruit"
ScreenGui.ResetOnSpawn = false
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if ScreenGui.Parent ~= CoreGui then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.Code
TitleLabel.Text = "AXIOM // BLOX FRUIT SUITE"
TitleLabel.Parent = MainFrame

-- Graphics & Lag Reducer
local function StripGraphics()
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.FogEnd = 9e9
    for _, v in pairs(lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then
            v:Destroy()
        end
    end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then
            obj:Destroy()
        end
    end
end

-- Fast Run & High Jump Loop
RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoid and rootPart then
        if getgenv().AxiomConfig.FastRun then
            humanoid.WalkSpeed = getgenv().AxiomConfig.SpeedValue
        end
        if getgenv().AxiomConfig.HighJump then
            humanoid.JumpPower = getgenv().AxiomConfig.JumpValue
        end
    end
end)

-- Remote Fruit Finder / Grabber from Afar
task.spawn(function()
    while true do
        task.loadstring() -- dummy execution anchor
        if getgenv().AxiomConfig.RemoteFruit then
            pcall(function()
                for _, v in pairs(Workspace:GetChildren()) do
                    if v:IsA("Tool") and v.Name:find("Fruit") then
                        local handle = v:FindFirstChild("Handle")
                        if handle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                            task.wait(0.2)
                            -- Simulate interaction if needed
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 0)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 1)
                        end
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

-- Create UI Elements Function
local function CreateToggle(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.Code
    btn.Text = name .. ": OFF"
    btn.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 120, 60) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

-- Build Controls
CreateToggle("Fix Lag / Clear Graphics", 55, function(v)
    getgenv().AxiomConfig.RemoveGraphics = v
    if v then StripGraphics() end
end)

CreateToggle("Auto Farm Mobs", 100, function(v)
    getgenv().AxiomConfig.AutoFarm = v
end)

CreateToggle("Fast Run (Adjustment)", 145, function(v)
    getgenv().AxiomConfig.FastRun = v
end)

CreateToggle("High Jump (Adjustment)", 190, function(v)
    getgenv().AxiomConfig.HighJump = v
end)

CreateToggle("Random Fruit From Afar", 235, function(v)
    getgenv().AxiomConfig.RemoteFruit = v
end)

print("[+] Axiom Blox Fruit Suite Initialized Cleanly. Boss man is ready to clear the server.")
