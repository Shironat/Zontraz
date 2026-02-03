local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local RemoteFunctions = ReplicatedStorage:WaitForChild("RemoteFunctions")
local RF_UpgradeSpeed = RemoteFunctions:WaitForChild("UpgradeSpeed")
local RF_Rebirth = RemoteFunctions:WaitForChild("Rebirth")

local Remote = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("Net")
    :WaitForChild("RF/Plot.PlotAction")

local Bases = workspace:WaitForChild("Bases")

local TsunamiLogic = {}

local MoneyEnabled = false
local MinhaBase = nil
local valorAtual = 1
local VALOR_MAX = 10
local intervalo = 0.4
local acumulador = 0

local EventCoinEnabled = false
local isTweening = false
local CHECK_INTERVAL = 2
local TWEEN_DURATION = 0.12

local AtivoUpgrade = false
local UpgradeSlot = nil
local UpgradeInterval = 0.01

local UpgradeSpeedEnabled = false
local RebirthEnabled = false

local UPGRADE_SPEED_INTERVAL = 0.1
local REBIRTH_INTERVAL = 0.1

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    hrp = char:WaitForChild("HumanoidRootPart")
end)

local function BuscarMinhaBase()
    for _, base in ipairs(Bases:GetChildren()) do
        if base:IsA("Model") then
            local PlayerName = base:FindFirstChild("PlayerName", true)

            if PlayerName
                and PlayerName:IsA("TextLabel")
                and (
                    PlayerName.Text == LocalPlayer.Name
                    or PlayerName.Text == LocalPlayer.DisplayName
                ) then

                MinhaBase = base
                print("Base:", MinhaBase.Name)
                return true
            end
        end
    end
    return false
end

local function ResolverBase()
    for tentativa = 1, 10 do
        if BuscarMinhaBase() then
            return true
        end
        task.wait(0.5)
    end

    warn("Base nao encontrada")
    return false
end

TsunamiLogic.ResolverBase = ResolverBase -- FIX (export)

RunService.Heartbeat:Connect(function(dt)
    if not MoneyEnabled then return end -- FIX
    if not MinhaBase then return end

    acumulador += dt
    if acumulador < intervalo then return end
    acumulador = 0

    local valor = tostring(valorAtual)

    task.spawn(function()
        pcall(function()
            Remote:InvokeServer(
                "Collect Money",
                MinhaBase.Name,
                valor
            )
        end)
    end)

    valorAtual += 1
    if valorAtual > VALOR_MAX then
        valorAtual = 1
    end
end)

function TsunamiLogic.ToggleMoney(state)
    MoneyEnabled = state

    if state and not MinhaBase then
        ResolverBase()
    end
end

function TsunamiLogic.ResetBase()
    MinhaBase = nil
    ResolverBase()
end

local function tweenToPosition(targetPos)
    if isTweening or not hrp then return end
    isTweening = true

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(TWEEN_DURATION, Enum.EasingStyle.Linear),
        { CFrame = CFrame.new(targetPos) }
    )

    tween:Play()
    tween.Completed:Once(function()
        isTweening = false
    end)
end

RunService.RenderStepped:Connect(function(dt)
    if not EventCoinEnabled then return end -- FIX

    TsunamiLogic._lastCheck = (TsunamiLogic._lastCheck or 0) + dt
    if TsunamiLogic._lastCheck < CHECK_INTERVAL then return end
    TsunamiLogic._lastCheck = 0
end)

function TsunamiLogic.GetBrainrots()
    local result = {}

    if not MinhaBase then
        if not ResolverBase() then
            return result
        end
    end

    for _, obj in ipairs(MinhaBase:GetChildren()) do
        if obj:IsA("Model") then
            local slotNumber = obj.Name:lower():match("slot (%d+) brainrot")

            if slotNumber then
                for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("Model") then
                        table.insert(result, {
                            Slot = tonumber(slotNumber),
                            Name = child.Name
                        })
                        break
                    end
                end
            end
        end
    end

    return result
end

function TsunamiLogic.ToggleUpgrade(state, slot)
    AtivoUpgrade = state

    if state then
        UpgradeSlot = slot
        print("AutoUpgrade ON | Slot:", UpgradeSlot)
    else
        UpgradeSlot = nil
    end
end

function TsunamiLogic.UpgradeBrainrot(slotNumber)
    if not MinhaBase then
        if not ResolverBase() then return end
    end

    pcall(function()
        Remote:InvokeServer(
            "Upgrade Brainrot",
            MinhaBase.Name,
            tostring(slotNumber)
        )
    end)
end

task.spawn(function()
    while true do
        if AtivoUpgrade and UpgradeSlot then
            TsunamiLogic.UpgradeBrainrot(UpgradeSlot)
        end
        task.wait(UpgradeInterval)
    end
end)

function TsunamiLogic.ToggleUpgrade(state, slot)
    AtivoUpgrade = state
    UpgradeSlot = slot
end

function TsunamiLogic.ToggleUpgradeSpeed(state)
    UpgradeSpeedEnabled = state
end

task.spawn(function()
    while true do
        if UpgradeSpeedEnabled then
            pcall(function()
                RF_UpgradeSpeed:InvokeServer(10)
            end)
        end
        task.wait(UPGRADE_SPEED_INTERVAL)
    end
end)

function TsunamiLogic.ToggleRebirth(state)
    RebirthEnabled = state
end

task.spawn(function()
    while true do
        if RebirthEnabled then
            pcall(function()
                RF_Rebirth:InvokeServer()
            end)
        end
        task.wait(REBIRTH_INTERVAL)
    end
end)

return TsunamiLogic