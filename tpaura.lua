local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function closest()
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (Character or HumanoidRootPart) then return end

    local TargetDistance = math.huge
    local Target

    for i,v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local TargetHRP = v.Character.HumanoidRootPart
            local mag = (HumanoidRootPart.Position - TargetHRP.Position).magnitude
            if mag < TargetDistance then
                TargetDistance = mag
                Target = v
            end
        end
    end

    return Target
end

local c = game.Players.LocalPlayer.Character
local o = c.HumanoidRootPart
local p = Instance.new("Part",workspace)
local range = 20
local go = Vector3.new(0,0,0)
p.Transparency = 0.5
p.CanCollide = false
p.Anchored = true
p.Position = o.Position 
p.Size = Vector3.new(1,1,1)
workspace.Camera.CameraSubject = p
local s = p:Clone()
task.spawn(function()
    repeat task.wait()
        if (closest().Character.HumanoidRootPart.Position-o.Position).magnitude < range and closest().Character.Humanoid.Health > 0 and (o.Position-p.Position).magnitude < range then
            s.Position = closest().Character.HumanoidRootPart.Position + Vector3.new(0,0,2)
            s.CFrame = CFrame.lookAt(s.Position,closest().Character.HumanoidRootPart.Position)
            o.CFrame = s.CFrame
        else
            o.CFrame = p.CFrame
        end
    until c.Humanoid.Health <= 0
end)
game:GetService("UserInputService").InputBegan:Connect(function(k, gameProcessedEvent)
    if not gameProcessedEvent then
        if k.KeyCode == Enum.KeyCode.W then
            go = Vector3.new(1,0,0)
        elseif k.KeyCode == Enum.KeyCode.S then
            go = Vector3.new(-1,0,0)
        elseif k.KeyCode == Enum.KeyCode.A then
            go = Vector3.new(0,0,-1)
        elseif k.KeyCode == Enum.KeyCode.D then
            go = Vector3.new(0,0,1)
        elseif k.KeyCode == Enum.KeyCode.Space then
            go = Vector3.new(0,1,0)
        elseif k.KeyCode == Enum.KeyCode.E then
            go = Vector3.new(0,-1,0)
        end
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(k, gameProcessedEvent)
    if not gameProcessedEvent then
        if k.KeyCode == Enum.KeyCode.W or k.KeyCode == Enum.KeyCode.S or k.KeyCode == Enum.KeyCode.A or k.KeyCode == Enum.KeyCode.D or k.KeyCode == Enum.KeyCode.E or k.KeyCode == Enum.KeyCode.Space then
            go = Vector3.new(0,0,0)
        end
    end
end)

c.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        repeat task.wait()
            child:Activate()
        until child.Parent ~= c
    end
end)

repeat task.wait()
    p.Position = p.Position + go
until c.Humanoid.Health <= 0