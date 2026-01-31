local Collect1 = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Enabled = false
local HeartbeatConn
local CHECK_INTERVAL = 0.5 -- pode ajustar
local lastCheck = 0

-- Remote
local PlotAction = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction")

-- Função que coleta todos os money spots
local function CollectMoney()
    -- Pega todas as bases do Workspace
    if not workspace:FindFirstChild("Bases") then return end

    for _, base in pairs(workspace.Bases:GetChildren()) do
        local uuid = base.Name -- geralmente o nome da base é o uuid
        local args = {
            "Collect Money",
            string.format("{%s}", uuid),
            "1",
        }

        -- Invoke o remote
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

-- Cria Toggle na UI
function Collect1:CreateToggle(Tab)
    Farm:CreateToggle({
        Name = "Collect Money",
        CurrentValue = false,
        Flag = "CollectMoney",
        Callback = function(Value)
            Enabled = Value
            if Value then
                Start()
            else
                Stop()
            end
        end
    })
end

return FarmModule