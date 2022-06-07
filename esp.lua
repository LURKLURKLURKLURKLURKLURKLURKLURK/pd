-- idc if you use this but please credit me
--[[
    [Credits]:
    Cripware: Box Sizing and Box positioning 
    IonHub: inspo 
    
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
local wtsp = Camera.WorldToScreenPoint 
local wtvp = Camera.WorldToViewportPoint
local rgb = Color3.fromRGB
local find_first_child = game.FindFirstChild
local find_first_child_of_class = game.FindFirstChildOfClass
local m_floor = math.floor
local i_new = Instance.new 

local esp = { 
    enabled = false,
    players = true, 
    max_distance_players = 10000, 
    max_distance_objects = 5000,
    box = {enabled = false, color = rgb(255,255,255), outline = false},
    inner_box = {enabled = false, color = rgb(0,0,0),transparency = 0.3},
    name = {enabled = false, color = rgb(255,255,255), outline = false},
    distance = {enabled = false, color = rgb(255,255,255), outline = false},
    health = {enabled = false, color = rgb(0,255,0), outline = false},
    healthbar = {outline = false, enabled = false, higher = rgb(0,255,0), lower = rgb(255,0,0)},
    tool = {enabled = false, color = rgb(255,255,255), outline = false},
    tracers = {enabled = false, color = rgb(255,255,255)},
    highlights = {fillcolor = rgb(255,255,255), chams = false, enabled = false, visible = rgb(0,255,0),non_visible = rgb(255,0,0), outline_color = rgb(0,0,0), fill_transparency = 0.5, outline_transparency = 0},
    objects = {},
    visible_check = false,
    font = 2,
    fontsize = 13,
    measurement = 'studs',
}

getgenv().esp = esp 
local utils = {}; do
    function utils.draw(class, properties)
        local drawing = new_drawing(class)
        for i,v in pairs(properties) do
            drawing[i] = v
        end
        return drawing
    end
    
    function utils.instance(class,properties)
        local instance = i_new(class)
        for i,v in pairs(properties) do
            instance[i] = v
        end
        return instance
    end

    function utils.gethealth(obj)
        local Health = {} 
        if obj:IsA('Model') and find_first_child(obj,'Humanoid') then -- adds support for custom things
            health.health = find_first_child(obj,'Humanoid').Health
            health.maxhealth = find_first_child(obj,'Humanoid').MaxHealth 
            return Health
        elseif obj:IsA('Player') then 
            health.health = find_first_child(obj.Character,'Humanoid').Health 
            health.maxhealth = find_first_child(obj.Character,'Humanoid').Health
        end
    end
    
    function utils.get_magnitude(obj_1,obj_2)
        return (obj_1 - obj_2).Magnitude
    end
    
    function utils.remove_esp(obj)
        if rawget(esp.objects, obj) then
            for _, drawing in next, esp.objects[obj] do
                drawing:Remove()
            end
            esp.objects[obj] = nil;
        end
    end
    
    function utils.add_esp_player(obj)
        local drawn_objects = {} 
        drawn_objects.Highlight = utils.instance('Highlight',{
            DepthMode = 'AlwaysOnTop',
            Enabled = false,
        })
        drawn_objects.Name = utils.draw('Text',{
            Font = esp.font, 
            Size = esp.size, 
            Text = '',
            Visible = false, 
            Color = esp.name.color,
            Center = true,
        });
        drawn_objects.Distance = utils.draw('Text',{
            Font = esp.font, 
            Size = esp.size, 
            Text = '',
            Visible = false, 
            Color = esp.distance.color,
            Center = true, 
        });
        drawn_objects.Tool = utils.draw('Text',{
            Font = esp.font, 
            Size = esp.size, 
            Text = '',
            Visible = false, 
            Color = esp.tool.color,
            Center = true,
        })
        drawn_objects.Box_Outline = utils.draw('Square',{
            Visible = false, 
            Color = rgb(0,0,0),
            Filled = false,
            Thickness = 3,
        });
        drawn_objects.Box = utils.draw('Square',{
            Size = Vec2(0,0),
            Color = esp.box.color,
            Filled = false,
            Thickness = 1,
            Visible = false, 
        });
        drawn_objects.inner_box = utils.draw('Square',{
            Visible = false, 
            Size = Vec2(0,0),
            Filled = true,
            Thickness = 0,
            Color = esp.inner_box.color
        });
        drawn_objects.Healthbar_Outline = utils.draw('Line',{
            Visible = false,
            Thickness = 3.5,
        });
        drawn_objects.Healthbar = utils.draw('Line',{
            Visible = false,
            Thickness = 1.5,
        });
        esp.objects[obj] = drawn_objects;
    end
    
    function utils.update_player_esp(obj,array)
        local character = obj.Character
        if esp.enabled and esp.players and character ~= nil and find_first_child(character,'HumanoidRootPart') ~= nil then
            local hrp = find_first_child(character,'HumanoidRootPart')

            local pos, is_on_screen = wtvp(Camera, hrp.Position)
            local fov_size = (wtvp(Camera,hrp.Position - Vec3(0, 3, 0)).Y - wtvp(Camera,hrp.Position + Vec3(0, 2.6, 0)).Y) / 2
            local box_size = Vec2(m_floor(fov_size * 1.8), m_floor(fov_size * 2.3))
            local box_pos = Vec2(m_floor(pos.X - fov_size * 1.8 / 2), m_floor(pos.Y - fov_size * 1.9/ 2))
            local bottom_bounds = 0
            local top_bounds = 0 
            local bottom_offset = Vector2.new(box_size.X / 2 + box_pos.X, box_size.Y + box_pos.Y + 1)
            local top_offset = Vector2.new(box_size.X / 2 + box_pos.X, box_pos.Y - 16)
            local distance = math.floor(utils.get_magnitude(hrp.Position,find_first_child(LP.Character,'HumanoidRootPart').Position))
                
            if is_on_screen and distance < esp.max_distance_players then
                if esp.highlights.enabled then
                    array.Highlight.Parent = game.GetService(game,'CoreGui') 
                    array.Highlight.Adornee = character
                    array.Highlight.Enabled = true
                    array.Highlight.OutlineTransparency = esp.highlights.outline_transparency
                    array.Highlight.FillTransparency = esp.highlights.fill_transparency
                    array.Highlight.OutlineColor = esp.highlights.outline_color
                    
                    --if esp.highlights.chams then 
                        local parts_array = Camera:GetPartsObscuringTarget({ -- visible check 
                            character.HumanoidRootPart.Position,
                            
                        },{LP.Character,character,workspace.CurrentCamera:FindFirstChild('ViewModel')})
                        if #parts_array > 1 then
                            array.Highlight.FillColor = esp.highlights.non_visible
                        elseif #parts_array < 1 then 
                                array.Highlight.FillColor = esp.highlights.visible 
                        end
                        --else 
                         --   array.Highlight.FillColor = esp.highlights.fillcolor
                    --end
                    else 
                        array.Highlight.Enabled = false
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
                    
                if esp.distance.enabled then 
                    array.Distance.Visible = true 
                    array.Distance.Position = Vec2(bottom_offset.X, bottom_offset.Y + bottom_bounds)
                    array.Distance.Color = esp.distance.color 
                    array.Distance.Text = tostring(distance)..' '..esp.measurement
                    array.Distance.Size = esp.fontsize
                    array.Distance.Font = esp.font
                    array.Distance.Outline = esp.distance.outline 
                    bottom_bounds = bottom_bounds + 14
                    else 
                        array.Distance.Visible = false
                end
                
                if esp.inner_box.enabled then 
                    array.inner_box.Size = Vec2(box_size.X-3,box_size.Y-3)
                    array.inner_box.Position = Vec2(box_pos.X+1.5,box_pos.Y+1.5)
                    array.inner_box.Visible = true 
                    array.inner_box.Color = esp.inner_box.color 
                    array.inner_box.Transparency = esp.inner_box.transparency
                    else
                        array.inner_box.Visible = false 
                end
                
                if esp.box.enabled then 
                    array.Box.Size = box_size 
                    array.Box.Position = box_pos
                    array.Box.Color = esp.box.color 
                    array.Box.Visible = true 
                    array.Box_Outline.Visible = esp.box.outline 
                    array.Box_Outline.Size = box_size 
                    array.Box_Outline.Position = box_pos
                    else 
                        array.Box.Visible = false 
                        array.Box_Outline.Visible = false
                end
                    
                if esp.healthbar.enabled then 
                    array.Healthbar.Visible = true 
                    array.Healthbar.Color = esp.healthbar.lower:lerp(esp.healthbar.higher,character.Humanoid.Health / character.Humanoid.MaxHealth);
                    array.Healthbar.From = Vec2((box_pos.X - 5), box_pos.Y + box_size.Y)
                    array.Healthbar.To = Vec2(array.Healthbar.From.X, array.Healthbar.From.Y - (character.Humanoid.Health / character.Humanoid.MaxHealth) * box_size.Y)
                    array.Healthbar_Outline.Visible = esp.healthbar.outline 
                    array.Healthbar_Outline.Color = rgb(0,0,0)
                    array.Healthbar_Outline.From = Vec2(array.Healthbar.From.X, box_pos.Y + box_size.Y + 1 )
                    array.Healthbar_Outline.To = Vec2(array.Healthbar.From.X, (array.Healthbar.From.Y -1 * box_size.Y) - 1)
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
                    array.Highlight.Enabled = false
            end
            else 
                array.inner_box.Visible = false
                array.Highlight.Enabled = false 
                array.Tool.Visible = false 
                array.Healthbar.Visible = false 
                array.Healthbar_Outline.Visible = false 
                array.Name.Visible = false 
                array.Distance.Visible = false 
                array.Box.Visible = false 
                array.Box_Outline.Visible = false
        end
    end
end

for i,v in next, Players:GetChildren() do
    if v ~= LP then 
        utils.add_esp_player(v)
    end
end

Players.PlayerAdded:Connect(function(v)
    utils.add_esp_player(v)
end)

Players.PlayerRemoving:Connect(function(v)
    utils.remove_esp(v)
end)
RunService.RenderStepped:Connect(function()
    for player, drawings in next, esp.objects do
        if drawings and player then
            utils.update_player_esp(player, drawings);
        end
    end
end)

return esp
