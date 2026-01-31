local TsunamiEscape = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Config
local DANGER_DISTANCE = 50
local CHECK_INTERVAL = 0.1
local TELEPORT_HEIGHT_OFFSET = 3
local TWEEN_DURATION = 0.15
local SAFE_ZONE_DISTANCE = 15

-- States
local isTweening = false
local Enabled = false
local HeartbeatConn
local lastCheck = 0

-- Funções internas
local function getSafeGaps()
    local gaps = {}
    if not workspace:FindFirstChild("Misc") or not workspace.Misc:FindFirstChild("Gaps") then
        return gaps
    end
    for _, gap in pairs(workspace.Misc.Gaps:GetChildren()) do
        for _, child in pairs(gap:GetChildren()) do
            if child:IsA("BasePart") then
                table.insert(gaps, { name = gap.Name, part = child, position = child.Position })
                break
            end
        end
    end
    return gaps
end

local function isInSafeZone()
    local playerPos = humanoidRootPart.Position
    for _, gap in pairs(getSafeGaps()) do
        if (gap.position - playerPos).Magnitude <= SAFE_ZONE_DISTANCE then
            return true
        end
    end
    return false
end

local function fastTweenToSafety(targetPart)
    if isTweening then return end
    isTweening = true
    local targetPos = targetPart.Position + Vector3.new(0, TELEPORT_HEIGHT_OFFSET, 0)
    local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(TWEEN_DURATION, Enum.EasingStyle.Linear), { CFrame = CFrame.new(targetPos) })
    tween:Play()
    tween.Completed:Once(function() isTweening = false end)
end

local function findBestGap()
    local gaps = getSafeGaps()
    if #gaps == 0 then return nil end
    local pos = humanoidRootPart.Position
    local look = humanoidRootPart.CFrame.LookVector
    local best, bestDist = nil, math.huge
    for _, gap in pairs(gaps) do
        local dir = (gap.position - pos).Unit
        local dot = look:Dot(dir)
        local dist = (gap.position - pos).Magnitude
        if dot < 0 and dist < bestDist then
            best = gap
            bestDist = dist
        end
    end
    if best then return best end
    for _, gap in pairs(gaps) do
        local dist = (gap.position - pos).Magnitude
        if dist < bestDist then
            best = gap
            bestDist = dist
        end
    end
    return best
end

local function getActiveWaveHitboxes()
    local hitboxes = {}
    local folder = workspace:FindFirstChild("ActiveTsunamis")
    if folder then
        for _, tsunami in pairs(folder:GetChildren()) do
            local hitbox = tsunami:FindFirstChild("Hitbox")
            if hitbox and hitbox:IsA("BasePart") then
                table.insert(hitboxes, hitbox)
            end
        end
    end
    return hitboxes
end

-- Loop
local function Start()
    if HeartbeatConn then return end
    HeartbeatConn = RunService.Heartbeat:Connect(function()
        if not Enabled then return end
        local now = tick()
        if now - lastCheck < CHECK_INTERVAL then return end
        lastCheck = now
        if not character or not character.Parent then
            character = player.Character
            if not character then return end
            humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        end
        if isTweening or isInSafeZone() then return end
        for _, hitbox in pairs(getActiveWaveHitboxes()) do
            if (hitbox.Position - humanoidRootPart.Position).Magnitude <= DANGER_DISTANCE then
                local gap = findBestGap()
                if gap then fastTweenToSafety(gap.part) end
                break
            end
        end
    end)
end

local function Stop()
    if HeartbeatConn then
        HeartbeatConn:Disconnect()
        HeartbeatConn = nil
    end
end

-- Cria Toggle na UI
function TsunamiEscape:CreateToggle(Tab)
    Tab:AddToggle({
        Name = "Auto Escape Tsunami",
        CurrentValue = false,
        Flag = "AutoEscapeTsunami",
        Callback = function(Value)
            Enabled = Value
            if Value then Start() else Stop() end
        end
    })
end

return TsunamiEscape