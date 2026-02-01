return function(state)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local DANGER_DISTANCE = 150
    local CHECK_INTERVAL = 0.01
    local TELEPORT_HEIGHT_OFFSET = 3
    local TWEEN_DURATION = 0.15
    local SAFE_ZONE_DISTANCE = 15

    local isTweening = false
    local lastCheck = 0
    local connection

    local function getSafeGaps()
        local gaps = {}

        local misc = workspace:FindFirstChild("Misc")
        if not misc then return gaps end

        local gapsFolder = misc:FindFirstChild("Gaps")
        if not gapsFolder then return gaps end

        for _, gap in pairs(gapsFolder:GetChildren()) do
            for _, child in pairs(gap:GetChildren()) do
                if child:IsA("BasePart") then
                    gaps[#gaps + 1] = {
                        name = gap.Name,
                        part = child,
                        position = child.Position
                    }
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

        local tween = TweenService:Create(
            humanoidRootPart,
            TweenInfo.new(TWEEN_DURATION, Enum.EasingStyle.Linear),
            { CFrame = CFrame.new(targetPos) }
        )

        tween:Play()
        tween.Completed:Once(function()
            isTweening = false
        end)
    end

    local function findBestGap()
        local gaps = getSafeGaps()
        if #gaps == 0 then return nil end

        local pos = humanoidRootPart.Position
        local look = humanoidRootPart.CFrame.LookVector

        local closestBehind, minDist = nil, math.huge

        for _, gap in pairs(gaps) do
            local dir = (gap.position - pos).Unit
            if look:Dot(dir) < 0 then
                local dist = (gap.position - pos).Magnitude
                if dist < minDist then
                    minDist = dist
                    closestBehind = gap
                end
            end
        end

        if closestBehind then return closestBehind end

        table.sort(gaps, function(a, b)
            return (a.position - pos).Magnitude < (b.position - pos).Magnitude
        end)

        return gaps[1]
    end

    local function getActiveWaveHitboxes()
        local hitboxes = {}
        local folder = workspace:FindFirstChild("ActiveTsunamis")

        if not folder then return hitboxes end

        for _, tsunami in pairs(folder:GetChildren()) do
            local hitbox = tsunami:FindFirstChild("Hitbox")
            if hitbox and hitbox:IsA("BasePart") then
                hitboxes[#hitboxes + 1] = hitbox
            end
        end

        return hitboxes
    end

    connection = RunService.Heartbeat:Connect(function()
        if not state.Enabled then
            connection:Disconnect()
            return
        end

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
                if gap then
                    fastTweenToSafety(gap.part)
                end
                break
            end
        end
    end)
end