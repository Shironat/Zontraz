local TeleportLogic = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

TeleportLogic.Enabled = false
TeleportLogic.Delay = 0.3

local partNames = {
    "ObbyEnd1",
    "ObbyEnd2",
    "ObbyEnd3"
}

task.spawn(function()
    while true do
        if TeleportLogic.Enabled then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local moneyParts = workspace:FindFirstChild("MoneyEventParts")

            if hrp and moneyParts then
                for _, name in ipairs(partNames) do
                    if not TeleportLogic.Enabled then break end

                    local part = moneyParts:FindFirstChild(name)
                    if part and part:IsA("BasePart") then
                        hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                        task.wait(TeleportLogic.Delay)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

return TeleportLogic