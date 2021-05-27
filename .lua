--Temporal Aimbot
wait()
 
--Custom Game Support
 
local games = {
    {GameId = 532222553, X_CHANGE = 0.05, Y_CHANGE = 0.04, MOUSE_OFFSET = Vector2.new(0, 0)}, --Island Royale
    {GameId = 113491250, X_CHANGE = 0.14, Y_CHANGE = 0.14, MOUSE_OFFSET = Vector2.new(0, 0), NO_HUMANOIDS = true}, --Phantom Forces
    {GameId = 1168263273, X_CHANGE = 0.08, Y_CHANGE = 0.08, MOUSE_OFFSET = Vector2.new(0, 0)} --Bad Buisness
}
 
local isBB = false
if game.GameId == 1168263273 then
    characters = workspace.Characters
    isBB = true
end

local adjustOffset
for i,v in pairs (games) do
    if game.GameId == v.GameId then
        X_CHANGE = v.X_CHANGE
        Y_CHANGE = v.Y_CHANGE
        MOUSE_OFFSET = v.MOUSE_OFFSET * ( workspace.CurrentCamera.ViewportSize / Vector2.new(2560, 1377) )
        NO_HUMANOIDS = v.NO_HUMANOIDS

        adjustOffset = v.MOUSE_OFFSET
    end
end
 
--Variables
local version = "1.9"
 
local stopped = false
local minimized = false
 
local _settings = {
    enabled = true,
    ffa = false,
    range = 150,
    predict = true,
    showRange = true,
    aimPart = "Head"
}
 
local RunService = game:GetService("RunService") --Get the Run Service.
local InputService = game:GetService("UserInputService") --Get the User Input Service.
local Players = game:GetService("Players") --Get the Players service.
local player = Players.LocalPlayer --Get the Local Player.
local playerGui = player.PlayerGui
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
    local p = Input or {MoveMouse = nil} --Setup for ProtoSmasher mouse movement.
local MoveMouse = mousemoverel or p.MoveMouse --Get the mouse move function.
local gui = game:GetObjects("rbxassetid://3757696276")[1]
gui.Parent = game:GetService("CoreGui")
    local main = gui.Main
    local top = main.Top
    local buttons = main.Buttons
local clicking = {L = false, R = false}
 
top.Title.Text = "This was made by rent XD"..version

if main:FindFirstChild("PleaseUpdate") then
    main.PleaseUpdate:Destroy()
end

--Functions
 
function rotateCamera(x, y) --Function for rotating camera along X and Y axis with the MoveMouse function.
    MoveMouse(y / Y_CHANGE, x / X_CHANGE) --Move the mouse to turn the camera.
end
 
function isHovering(frame)
    local aPos = frame.AbsolutePosition
    local aSiz = frame.AbsoluteSize
   
    if mouse.X >= aPos.X and mouse.X <= aPos.X + aSiz.X and mouse.Y >= aPos.Y and mouse.Y <= aPos.Y + aSiz.Y then
        return true
    else
        return false
    end
end
 
--Events
 
top.Close.MouseButton1Click:Connect(function()
    stopped = true
    wait()
    gui:Destroy()
end)
 
top.Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        main.BackgroundTransparency = 1
        buttons.Visible = false
        main.Logo.Visible = false
    else
        main.BackgroundTransparency = 0
        buttons.Visible = true
        main.Logo.Visible = true
    end
end)
 
function BB_localChr ()
    local _record = {math.huge, nil}
    for i,v in pairs (characters:GetChildren()) do
        if v.Body:FindFirstChild(_settings.aimPart) then
            local dist = (v.Body[_settings.aimPart].Position - camera.CFrame.Position).Magnitude
            if dist < _record[1] then
                _record[1] = dist
                _record[2] = v
            end
        end
    end
    return _record[2]
end
 
function BB_isSameTeam (chr) --Special targetting function for Bad Buisness
    if chr and chr == BB_localChr() then
        return true
    end
    for i,v in pairs (playerGui:GetChildren()) do
        if v.Name == "NameGui" then
            if v.Adornee then
                if v.Adornee.Parent.Parent == chr then
                    return true
                end
            end
        end
    end
    return false
   
end
 
local holding_aim = false
 
InputService.InputBegan:Connect(function(input)
    if input.KeyCode == AIM_KEY then
        holding_aim = true
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        clicking.L = true
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and USE_RIGHT_CLICK then
        clicking.R = true
    end
    if input.KeyCode == TOGGLE_VIS_KEY then
        gui.Enabled = not gui.Enabled
    end
end)
 
InputService.InputEnded:Connect(function(input)
    if input.KeyCode == AIM_KEY then
        holding_aim = false
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        clicking.L = false
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and USE_RIGHT_CLICK then
        clicking.R = false
    end
end)
 
if not MoveMouse and false then --If no mouse movement function exists, then...
    --error("Script failed: Your exploit has no mouse movement function") --...print this message.
else --Otherwise, if the function does exist, then execute this code
   
    --print("Temporal Aimbot v"..version.." Starting...") --Print message. UPDATE 9/16/2020: GAMES CAN EASILY SEE WHAT MESSAGES GET PRINTED TO CONSOLE LMAO SORRY
   
    wait(0.5)
   
    local target = nil --The current player target
    local _prevPos = nil
    local record = {player = nil, distance = nil}
   
    local mPos = Vector2.new(mouse.X, mouse.Y)
   
    if not isBB then
        Players.PlayerRemoving:Connect(function(plr)
            if plr == target then
                target = nil
                _prevPos = nil
                record = {player = nil, distance = nil}
            end
        end)
    else
        characters.ChildRemoved:Connect(function(chr)
            if chr == target then
                target = nil
                _prevPos = nil
                record = {player = nil, distance = nil}
            end
        end)
    end
   
    local dragging = false
    local prevPos = Vector2.new(mouse.X, mouse.Y)
   
    function toggle (button)
        if button.BackgroundColor3 == Color3.new(0, 0, 0) then
            button.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
            button.TextColor3 = Color3.new(0, 0, 0)
        else
            button.BackgroundColor3 = Color3.new(0, 0, 0)
            button.TextColor3 = Color3.fromRGB(85, 0, 127)
        end
    end
   
    if _settings.enabled then
        toggle(buttons.Enabled)
    end
    if _settings.ffa then
        toggle(buttons.FFA)
    end
    if _settings.predict then
        toggle(buttons.Predict)
    end
    if _settings.showRange then
        toggle(buttons.ShowRange)
    end
   
    buttons.Range.Text = "Range: "..tostring(_settings.range)
   
    buttons.Range.FocusLost:Connect(function()
        local num = tonumber(buttons.Range.Text)
        if num then
            _settings.range = num
            buttons.Range.Text = "Range: "..tostring(num)
        else
            buttons.Range.Text = "Range: "..tostring(_settings.range)
        end
    end)
    
    buttons.AimPart.Text = "AimPart: "..tostring(_settings.aimPart)
   
    buttons.AimPart.FocusLost:Connect(function()
        _settings.aimPart = buttons.AimPart.Text
        
        buttons.AimPart.Text = "AimPart: "..tostring(_settings.aimPart)
    end)

    buttons.Enabled.MouseButton1Click:Connect(function()
        toggle(buttons.Enabled)
        _settings.enabled = not _settings.enabled
    end)
    buttons.FFA.MouseButton1Click:Connect(function()
        toggle(buttons.FFA)
        _settings.ffa = not _settings.ffa
    end)
    buttons.Predict.MouseButton1Click:Connect(function()
        toggle(buttons.Predict)
        _settings.predict = not _settings.predict
    end)
    buttons.ShowRange.MouseButton1Click:Connect(function()
        toggle(buttons.ShowRange)
        _settings.showRange = not _settings.showRange
    end)
   
    RunService.RenderStepped:Connect(function() --Fires every frame, handles precice aiming
        
        if _settings.enabled and not stopped then
            
            mPos = Vector2.new(mouse.X, mouse.Y)
            if game.GameId == 532222553 and player.PlayerGui:FindFirstChild("Core_UI") then
                local core = player.PlayerGui.Core_UI
                if core.Center_Dot.Visible then
                    realMPos = core.Center_Dot.Dot.AbsolutePosition + core.Center_Dot.Dot.AbsoluteSize / 2
                else
                    realMPos = core.Crosshairs.Center.AbsolutePosition + core.Crosshairs.Center.AbsoluteSize / 2
                end
            else
                realMPos = mPos + MOUSE_OFFSET
            end
           
            if not dragging and clicking.L and isHovering(top) then
                dragging = true
            elseif dragging and clicking.L then
                local dif = mPos - prevPos
                main.Position = main.Position + UDim2.new(0, dif.X, 0, dif.Y)
            else
                dragging = false
            end
           
            local function t (txt)
                buttons.Hint.Text = txt
            end
           
            if isHovering(buttons.Enabled) then
                t("enable or disable the aimbot yknow :P")
            elseif isHovering(buttons.FFA) then
                t("team check or no team check.")
            elseif isHovering(buttons.Predict) then
                t("counter lag predict.")
            elseif isHovering(buttons.ShowRange) then
                t("show the circle.")
            elseif isHovering(buttons.Range) then
                t("The max amount of pixels away from your mouse a player can be in order for them to be potentially targeted. Please note that the target is detirmened by whoever is closest to the camera, not distance from the mouse.")
            elseif isHovering(buttons.AimPart) then
                t("The name of the part in the target's character to lock onto.")
            else
                t("Make sure to set your sensitivity to 0.36 (1 bar) or else the aimbot will freak out! (Set to '1' on Windows App Version) Report any bugs to me on Discord. This was made by rent XD")
            end
           
            if target then
               
                if not isBB then
                    if target.Character and target.Character:FindFirstChild(_settings.aimPart) and target.Character[_settings.aimPart]:IsA("BasePart") and (clicking.R or holding_aim) and (target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0.01) or NO_HUMANOIDS then
                       
                        local _sPos, onScreen = camera:WorldToScreenPoint(target.Character[_settings.aimPart].Position)
                        local sPos = Vector2.new(_sPos.X, _sPos.Y)
                        if onScreen then
                           
                            local ray = camera:ScreenPointToRay(realMPos.X, realMPos.Y)
                            local pos
                            local _pos = target.Character[_settings.aimPart].Position
                            if _settings.predict and _prevPos then
                                pos = _pos + (_pos - _prevPos) * 3
                            else
                                pos = _pos
                            end
                           
                            local temp1 = CFrame.new(camera.CFrame.Position, pos)
                            local temp2 = Instance.new("Part", workspace)
                            temp2.Name = "a"..tostring(math.random(100, 10000000))
                            temp2.Anchored = true
                            temp2.CanCollide = false
                            temp2.Transparency = 1
                            temp2.CFrame = temp1
                            local targetRotation = temp2.Orientation
                            local temp3 = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + ray.Direction)
                            temp2.CFrame = temp3
                            local currentRotation = temp2.Orientation
                            temp2:Destroy()
                           
                            if targetRotation.Y < -90 and currentRotation.Y > 90 then
                                targetRotation = Vector3.new(targetRotation.X, targetRotation.Y + 360, targetRotation.Z)
                            end
                            if currentRotation.Y < -90 and targetRotation.Y > 90 then
                                currentRotation = Vector3.new(currentRotation.X, currentRotation.Y + 360, currentRotation.Z)
                            end
                            if targetRotation.X < -90 and currentRotation.X > 90 then
                                targetRotation = Vector3.new(targetRotation.X, targetRotation.X + 360, targetRotation.Z)
                            end
                            if currentRotation.X < -90 and targetRotation.X > 90 then
                                currentRotation = Vector3.new(currentRotation.X, currentRotation.X + 360, currentRotation.Z)
                            end
                           
                            local dif = currentRotation - targetRotation
                           
                            rotateCamera(dif.X, dif.Y)
                           
                            _prevPos = _pos
                           
                        else
                            target = nil
                            _prevPos = nil
                            record = {player = nil, distance = nil}
                        end
                       
                    else
                        target = nil
                        _prevPos = nil
                        record = {player = nil, distance = nil}
                    end
                else
                    if target.Body:FindFirstChild(_settings.aimPart) and target.Body[_settings.aimPart]:IsA("BasePart") and (clicking.R or holding_aim) and target:FindFirstChild("Health") and target.Health.Value > 0 then
                       
                        local _sPos, onScreen = camera:WorldToScreenPoint(target.Body[_settings.aimPart].Position)
                        local sPos = Vector2.new(_sPos.X, _sPos.Y)
                        if onScreen then
                           
                            local ray = camera:ScreenPointToRay(realMPos.X, realMPos.Y)
                            local pos
                            local _pos = target.Body[_settings.aimPart].Position
                            if _settings.predict and _prevPos then
                                pos = _pos + (_pos - _prevPos) * 3
                            else
                                pos = _pos
                            end
                           
                            local temp1 = CFrame.new(camera.CFrame.Position, pos)
                            local temp2 = Instance.new("Part", workspace)
                            temp2.Name = "a"..tostring(math.random(100, 10000000))
                            temp2.Anchored = true
                            temp2.CanCollide = false
                            temp2.Transparency = 1
                            temp2.CFrame = temp1
                            local targetRotation = temp2.Orientation
                            local temp3 = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + ray.Direction)
                            temp2.CFrame = temp3
                            local currentRotation = temp2.Orientation
                            temp2:Destroy()
                           
                            if targetRotation.Y < -90 and currentRotation.Y > 90 then
                                targetRotation = Vector3.new(targetRotation.X, targetRotation.Y + 360, targetRotation.Z)
                            end
                            if currentRotation.Y < -90 and targetRotation.Y > 90 then
                                currentRotation = Vector3.new(currentRotation.X, currentRotation.Y + 360, currentRotation.Z)
                            end
                            if targetRotation.X < -90 and currentRotation.X > 90 then
                                targetRotation = Vector3.new(targetRotation.X, targetRotation.X + 360, targetRotation.Z)
                            end
                            if currentRotation.X < -90 and targetRotation.X > 90 then
                                currentRotation = Vector3.new(currentRotation.X, currentRotation.X + 360, currentRotation.Z)
                            end
                           
                            local dif = currentRotation - targetRotation
                           
                            rotateCamera(dif.X, dif.Y)
                           
                            _prevPos = _pos
                           
                        else
                            target = nil
                            _prevPos = nil
                            record = {player = nil, distance = nil}
                        end
                       
                    else
                        target = nil
                        _prevPos = nil
                        record = {player = nil, distance = nil}
                    end
                end
               
            end
           
            prevPos = mPos
           
        else
            target = nil
            _prevPos = nil
            record = {player = nil, distance = nil}
        end
       
        if not stopped and main:FindFirstChild("Circle") then
            main.Circle.Position = UDim2.new(0, realMPos.X - main.AbsolutePosition.X, 0, realMPos.Y - main.AbsolutePosition.Y)
        end
       
    end)
   
    while wait(0.1) do --Loop that fires less often, to save performance
 		if clicking.L and USE_LEFT_CLICK then
			holding_aim = true
		elseif USE_LEFT_CLICK then
			local found = false
			for i,v in pairs (InputService:GetKeysPressed()) do
				if v == AIM_KEY then
					found = true
				end
			end
			holding_aim = found
		end
		
        local c = clicking.R or holding_aim --Shortcut for detecting lockon button
 
        if c and _settings.enabled and not target and not stopped then
            
            if not isBB then
                for i,v in pairs (Players:GetPlayers()) do
                    if v ~= player and (v.Team ~= player.Team or _settings.ffa) then
                        if v.Character then
                            if v.Character:FindFirstChild(_settings.aimPart) and v.Character[_settings.aimPart]:IsA("BasePart") and (v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid:IsA("Humanoid") and v.Character.Humanoid.Health > 0.01) or NO_HUMANOIDS then
                                local _sPos, onScreen = camera:WorldToScreenPoint(v.Character[_settings.aimPart].Position)
                                local sPos = Vector2.new(_sPos.X, _sPos.Y)
                                if onScreen then
                                    if (sPos - realMPos).Magnitude <= _settings.range then
                                        local dist = (camera.CFrame.Position - v.Character[_settings.aimPart].Position).Magnitude
                                        if not record.player or dist < record.distance then
                                            record = {player = v, distance = dist}
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                local lChr = BB_localChr()
                if lChr then
                    for i,v in pairs (characters:GetChildren()) do
                        if v ~= lChr and (not BB_isSameTeam(v) or _settings.ffa) then
                            if v.Body:FindFirstChild(_settings.aimPart) and v.Body[_settings.aimPart]:IsA("BasePart") and v:FindFirstChild("Health") and v.Health.Value > 0 then
                                local _sPos, onScreen = camera:WorldToScreenPoint(v.Body[_settings.aimPart].Position)
                                local sPos = Vector2.new(_sPos.X, _sPos.Y)
                                if onScreen then
                                    if (sPos - realMPos).Magnitude <= _settings.range then
                                        local dist = (camera.CFrame.Position - v.Body[_settings.aimPart].Position).Magnitude
                                        if not record.player or dist < record.distance then
                                            record = {player = v, distance = dist}
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
           
            if record.player then
                target = record.player
                record = {player = nil, distance = nil}
            end
        elseif not c then
            target = nil
            _prevPos = nil
            record = {player = nil, distance = nil}
        end
        
        if main:FindFirstChild("Circle") then
            main.Circle.Size = UDim2.new(0, _settings.range * 2, 0, _settings.range * 2)
        end
        
        if adjustOffset then
            MOUSE_OFFSET = adjustOffset * ( workspace.CurrentCamera.ViewportSize / Vector2.new(2560, 1377) )
        end

        if _settings.showRange and not stopped and main:FindFirstChild("Circle") then
            main.Circle.Visible = true
        elseif not stopped and main:FindFirstChild("Circle") then
            main.Circle.Visible = false
        end
    end
   
end
