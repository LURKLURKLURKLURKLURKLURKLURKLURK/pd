--[[
    [TODO]:
    
    Add needed functions: 🟢️
    Add ESP To Players: 🟢
    Add boxes: 🟢️
    Add names: 🟢️
    Add distance: 🟢️
    Add tools: 🟢️ 
    Add Healthbars: 🟢️ 
    Add Highlights: 🟢️
    Add Chams: 🟢️ 
    Add Font Changing: 🟢️ 
    Add Size Changing: 🟢️ 
    
    Add Bold: 🔴
    Add Inner Box: 🟢
    
    
    [Items]:
    🟢 Done
    🔴 Planned, havent gotten to
    🟠 WIP 
]]

if getgenv().esp then
    print('esp already loaded')
    return wait(9e9) 
end 

local Players = game.GetService(game,'Players')
local RunService = game.GetService(game,'RunService')

local LP = Players.LocalPlayer 
local Camera = workspace.CurrentCamera 
local CF = CFrame.new
local Vec3 = Vector3.new
local Vec2 = Vector2.new
local new_drawing = Drawing.new
local WTSP = Camera.WorldToScreenPoint 
local wtvp = Camera.WorldToViewportPoint
local rgb = Color3.fromRGB
local find_first_child = game.FindFirstChild
local find_first_child_of_class = game.FindFirstChildOfClass
local m_floor = math.floor
local i_new = Instance.new 
local GBB = workspace.GetBoundingBox

local esp = { 
    enabled = true,
    players = true, 
    max_distance_players = 10000, 
    max_distance_objects = 5000,
    box = {enabled = true, color = rgb(255,255,255), outline = true},
    inner_box = {enabled = true, color = rgb(0,0,0),transparency = 0.3},
    name = {enabled = true, color = rgb(255,255,255), outline = true},
    distance = {enabled = true, color = rgb(255,255,255), outline = true},
    health = {enabled = true, color = rgb(0,255,0), outline = true},
    healthbar = {outline = true, enabled = true, higher = rgb(0,255,0), lower = rgb(255,0,0)},
    tool = {enabled = true, color = rgb(255,255,255), outline = true},
    tracers = {enabled = false, color = rgb(255,255,255)},
    highlights = {fillcolor = rgb(86,0,232), enabled = true, outline_color = rgb(0,0,0), fill_transparency = 0.5, outline_transparency = 0},
    objects = {},
    visible_check = false,
    font = 2,
    fontsize = 13,
    measurement = 'meters',
}

do
    function esp.draw(class, properties)
        local drawing = new_drawing(class)
        for i,v in pairs(properties) do
            drawing[i] = v
        end
        return drawing
    end
    
    function esp.instance(class,properties)
        local instance = i_new(class)
        for i,v in pairs(properties) do
            instance[i] = v
        end
        return instance
    end

    function esp.get_magnitude(obj_1,obj_2)
        return (obj_1 - obj_2).Magnitude
    end
    
    function esp.remove_esp(obj)
        if rawget(esp.objects, obj) then
            for _, drawing in next, esp.objects[obj] do
                drawing:Remove()
            end
            esp.objects[obj] = nil;
        end
    end
    
    function esp.add_esp_player(obj)
        local drawn_objects = {} 
        drawn_objects.Highlight = esp.instance('Highlight',{
            DepthMode = 'AlwaysOnTop',
            Enabled = false,
        })
        drawn_objects.inner_box = esp.draw('Square',{
            Visible = false, 
            Size = Vec2(0,0),
            Filled = true,
            Thickness = 0,
            Color = esp.inner_box.color
        });
        drawn_objects.Name = esp.draw('Text',{
            Font = esp.font, 
            Size = esp.size, 
            Text = '',
            Visible = false, 
            Color = esp.name.color,
            Center = true,
        });
        drawn_objects.Distance = esp.draw('Text',{
            Font = esp.font, 
            Size = esp.size, 
            Text = '',
            Visible = false, 
            Color = esp.distance.color,
            Center = true, 
        });
        drawn_objects.Tool = esp.draw('Text',{
            Font = esp.font, 
            Size = esp.size, 
            Text = '',
            Visible = false, 
            Color = esp.tool.color,
            Center = true,
        })
        drawn_objects.Box_Outline = esp.draw('Square',{
            Visible = false, 
            Color = rgb(0,0,0),
            Filled = false,
            Thickness = 3.5,
        });
        drawn_objects.Box = esp.draw('Square',{
            Size = Vec2(0,0),
            Color = esp.box.color,
            Filled = false,
            Thickness = 1,
            Visible = false, 
        });
        
        drawn_objects.health_text = esp.draw('Text',{
            Visible = false, 
            Size = esp.fontsize,
            Font = esp.font,
            Outline = true,
            Center = false, 
            Color = esp.health.color,
        })
        drawn_objects.Healthbar_Outline = esp.draw('Line',{
            Visible = false,
            Thickness = 3.5,
        });
        drawn_objects.Healthbar = esp.draw('Line',{
            Visible = false,
            Thickness = 1,
        });
        esp.objects[obj] = drawn_objects;
    end
    
    function esp.update_player_esp(obj,array)
        local character = obj.Character
        if esp.enabled and esp.players and character ~= nil and find_first_child(character,'HumanoidRootPart') ~= nil then
            local hrp = find_first_child(character,'HumanoidRootPart')

            local Pos, Size = GBB(character)
			local Height = (Camera.CFrame - Camera.CFrame.p) * Vec3(0, (math.clamp(Size.Y, 1, 10) + 0.5) / 2, 0)
			Height = math.abs(WTSP(Camera, Pos.Position + Height).Y - WTSP(Camera, Pos.Position - Height).Y)
			Size = (Vec2(Height / 1.5, Height))
			local ScreenPosition, OnScreen = wtvp(Camera, Pos.Position)
			local Position = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - (Size / 2))
		
            local bottom_bounds = 0
            local top_bounds = 0 
            local bottom_offset = Vector2.new(Size.X / 2 + Position.X, Size.Y + Position.Y + 1)
            local top_offset = Vector2.new(Size.X / 2 + Position.X, Position.Y - 16)
            local distance = math.floor(esp.get_magnitude(hrp.Position,find_first_child(LP.Character,'HumanoidRootPart').Position) / 3.57142857143)
                
            if OnScreen and distance < esp.max_distance_players then
                if esp.highlights.enabled then
                    array.Highlight.Parent = game.GetService(game,'CoreGui') 
                    array.Highlight.Adornee = character
                    array.Highlight.Enabled = true
                    array.Highlight.OutlineTransparency = esp.highlights.outline_transparency
                    array.Highlight.FillTransparency = esp.highlights.fill_transparency
                    array.Highlight.OutlineColor = esp.highlights.outline_color
                    array.Highlight.FillColor = esp.highlights.fillcolor
                end
                if esp.name.enabled then 
                    array.Name.Visible = true 
                    array.Name.Position = Vec2(top_offset.X,top_offset.Y - top_bounds)
                    array.Name.Color = esp.name.color 
                    array.Name.Text = tostring(obj.Name)
                    array.Name.Size = esp.fontsize
                    array.Name.Font = esp.font
                    array.Name.Outline = esp.name.outline
                    
                    
                    top_bounds = top_bounds + 14 
                    else 
                        array.Name.Visible = false
                end
                
                if esp.health.enabled then 
                    array.health_text.Visible = true 
                    array.health_text.Position = Vec2((Position.X-30), array.Healthbar.To.Y)
                    array.health_text.Font = esp.font 
                    array.health_text.Text = tostring(m_floor(character.Humanoid.Health))
                    array.health_text.Color = esp.healthbar.lower:lerp(esp.healthbar.higher,character.Humanoid.Health / character.Humanoid.MaxHealth);
                    array.health_text.Outline = esp.health.outline
                    else 
                        array.health_text.Visible = false
                end
                
                if esp.distance.enabled then 
                    array.Distance.Visible = true 
                    array.Distance.Position = Vec2(bottom_offset.X, bottom_offset.Y + bottom_bounds)
                    array.Distance.Color = esp.distance.color 
                    array.Distance.Text = tostring(m_floor(distance))..' '..esp.measurement
                    array.Distance.Size = esp.fontsize
                    array.Distance.Font = esp.font
                    array.Distance.Outline = esp.distance.outline 
                    bottom_bounds = bottom_bounds + 14
                    else 
                        array.Distance.Visible = false
                end
                
                if esp.inner_box.enabled then 
                    array.inner_box.Size = Vec2(Size.X-3,Size.Y-3)
                    array.inner_box.Position = Vec2(Position.X+1.5,Position.Y+1.5)
                    array.inner_box.Visible = true 
                    array.inner_box.Color = esp.inner_box.color 
                    array.inner_box.Transparency = esp.inner_box.transparency
                    else
                        array.inner_box.Visible = false 
                end
                
                if esp.box.enabled then 
                    array.Box.Size = Size 
                    array.Box.Position = Position
                    array.Box.Color = esp.box.color 
                    array.Box.Visible = true 
                    array.Box_Outline.Visible = esp.box.outline 
                    array.Box_Outline.Size = Size 
                    array.Box_Outline.Position = Position
                    else 
                        array.Box.Visible = false 
                        array.Box_Outline.Visible = false
                end
                    
                if esp.healthbar.enabled then 
                    array.Healthbar.Visible = true 
                    array.Healthbar.Color = esp.healthbar.lower:lerp(esp.healthbar.higher,character.Humanoid.Health / character.Humanoid.MaxHealth);
                    array.Healthbar.From = Vec2((Position.X - 5), Position.Y + Size.Y)
                    array.Healthbar.To = Vec2(array.Healthbar.From.X, array.Healthbar.From.Y - (character.Humanoid.Health / character.Humanoid.MaxHealth) * Size.Y)
                    array.Healthbar_Outline.Visible = esp.healthbar.outline 
                    array.Healthbar_Outline.Color = rgb(0,0,0)
                    array.Healthbar_Outline.From = Vec2(array.Healthbar.From.X, Position.Y + Size.Y + 1 )
                    array.Healthbar_Outline.To = Vec2(array.Healthbar.From.X, (array.Healthbar.From.Y -1 * Size.Y) - 1)
                    else 
                        array.Healthbar.Visible = false 
                        array.Healthbar_Outline.Visible = false
                end
    
                if esp.tool.enabled then 
                    array.Tool.Visible = true 
                    array.Tool.Position = Vec2(bottom_offset.X,bottom_offset.Y + bottom_bounds)
                    array.Tool.Size = esp.fontsize 
                    array.Tool.Text = tostring(game.GetService(game,'ReplicatedStorage').Players[tostring(obj)].Status.GameplayVariables.EquippedTool.Value)
                    array.Tool.Font = esp.font
                    array.Tool.Outline = esp.tool.outline
                    bottom_bounds = bottom_bounds + 14 
                    else 
                        array.Tool.Visible = false 
                end
                else 
                    array.Tool.Visible = false 
                    array.Healthbar.Visible = false 
                    array.Healthbar_Outline.Visible = false 
                    array.Name.Visible = false 
                    array.Distance.Visible = false 
                    array.Box.Visible = false 
                    array.inner_box.Visible = false 
                    array.Box_Outline.Visible = false 
                    array.health_text.Visible = false
            end
            else 
                array.inner_box.Visible = false
                array.Tool.Visible = false 
                array.Healthbar.Visible = false 
                array.Healthbar_Outline.Visible = false 
                array.Name.Visible = false 
                array.Distance.Visible = false 
                array.Box.Visible = false 
                array.Box_Outline.Visible = false
                array.health_text.Visible = false
        end
    end
end

for i,v in next, Players:GetChildren() do
    if v~=LP then 
        esp.add_esp_player(v)
    end
end

Players.PlayerAdded:Connect(function(v)
    esp.add_esp_player(v)
end)

Players.PlayerRemoving:Connect(function(v)
    esp.remove_esp(v)
end)
RunService.RenderStepped:Connect(function()
    for player, drawings in next, esp.objects do
        if drawings and player then
            esp.update_player_esp(player, drawings);
        end
    end
end)

getgenv().esp = esp 
return esp
