local Collect1 = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Enabled = false
local HeartbeatConn
local CHECK_INTERVAL = 0.5 -- pode ajustar
local lastCheck = 0

local PlotAction

local function Init()
    PlotAction = ReplicatedStorage
        :WaitForChild("Packages", 5)
        :WaitForChild("Net", 5)
        :WaitForChild("RF/Plot.PlotAction", 5)
end

local function CollectMoney()
    if not workspace:FindFirstChild("Bases") then return end

    for _, base in pairs(workspace.Bases:GetChildren()) do
        local uuid = base.Name
        local args = {
            "Collect Money",
            string.format("{%s}", uuid),
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        }

        local success, err = pcall(function()
            PlotAction:InvokeServer(unpack(args))
        end)

        if not success then
            warn("Erro ao coletar money:", err)
        end
    end
end

-- Loop
local function Start()
    if HeartbeatConn then return end

    HeartbeatConn = RunService.Heartbeat:Connect(function()
        if not Enabled then return end

        local now = tick()
        if now - lastCheck < CHECK_INTERVAL then return end
        lastCheck = now

        CollectMoney()
    end)
end

local function Stop()
    if HeartbeatConn then
        HeartbeatConn:Disconnect()
        HeartbeatConn = nil
    end
end

print("CreateToggle chamado", Tab)
-- Cria Toggle na UI
function Collect1:CreateToggle(Tab)
    Tab:AddToggle({
        Name = "Collect Money",
        CurrentValue = false,
        Flag = "CollectMoney",
        Callback = function(Value)
    Enabled = Value
    if Value then
        if not PlotAction then
            Init()
            if not PlotAction then
                warn("PlotAction não encontrado")
                return
            end
        end
        Start()
    else
        Stop()
    end
end

return Collect1