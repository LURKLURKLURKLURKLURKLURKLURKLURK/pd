--[[
  i dont really care if you use this, the code is SHIT anyway
]]

local utils = {}
utils.InventoryViewerGUI = Instance.new("ScreenGui")
local backframe = Instance.new("Frame")
local innerframe = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
utils.accent = Instance.new("Frame")
local Inventory = Instance.new("Frame")

local playervalues = Instance.new("Folder")
local players_name_bold = Instance.new("TextLabel")
local players_name = Instance.new("TextLabel")

local player_inventory = Instance.new("TextLabel")
local player_inventory_bold = Instance.new("TextLabel")

local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")

function utils.AddInventoryItem(name,TYPE)
    local ITEM_NAME = name
    local TYPE = TYPE or 'normal' -- not added y et 
    if type(ITEM_NAME) == 'string' then
        ITEM_NAME = name 
    else 
        ITEM_NAME = tostring(name)
    end
    local Item = Instance.new('TextLabel')
    Item.Parent = Inventory
    Item.BackgroundTransparency = 1.000
    Item.Size = UDim2.new(0, 191, 0, 17)
    Item.Font = Enum.Font.Code
    Item.Text = ITEM_NAME
    Item.TextColor3 = Color3.fromRGB(163, 163, 163)
    Item.TextSize = 14.000
    Item.Name = ITEM_NAME
    Item.TextColor3 = Color3.fromRGB(225,225,225)
    Item.TextXAlignment = Enum.TextXAlignment.Left
    Item.Position = UDim2.new(0, 0, 0, 0)
end

function utils.CheckPlayer(player)
    local Distance = math.floor((player.Character.Head.Position - game.Players.LocalPlayer.Character.Head.Position).magnitude)
    players_name_bold.Text = tostring(player)
    players_name.Text = tostring(player)

    for i,v in next, game.ReplicatedStorage.Players:GetChildren() do
        if tostring(v) == tostring(player) then 
            local InventoryTab = {}
            local ClothingTab = {} 
            for a,x in next, v:GetDescendants() do
                if x:IsA('StringValue') then
                    if x.Parent.Name == 'Inventory' and not table.find(InventoryTab,x) then
                        table.insert(InventoryTab, x)
                    elseif x.Parent.Name == 'Clothing' and not table.find(ClothingTab,x) then 
                        table.insert(ClothingTab, x)
                    end
                elseif x:IsA('ObjectValue') then 
                    if x.Parent.name =='Hotbar' and not table.find(InventoryTab,x) then 
                        table.insert(InventoryTab,x.Value)
                    end
                end
            end
            for i,v in next, InventoryTab do
                if not Inventory:FindFirstChild(tostring(v)) then
                    --[[if table.find(weapons,tostring(v)) then 
                        AddInventoryItem(tostring(v),'weapon')
                    elseif table.find(consumables,tostring(v)) then 
                        AddInventoryItem(tostring(v),'consumable')
                    elseif tostring(v) == 'Rubles' then 
                        AddInventoryItem(tostring(v),'money')
                        else ]]
                            AddInventoryItem(tostring(v))
                    --end
                end
            end
            for i,v in next, ClothingTab do
                if not Inventory:FindFirstChild(tostring(v)) then 
                    AddInventoryItem(tostring(v),'clothing')
                end
            end
            
        end
    end
end

function utils.ClearInventory()
    inner_frame_offset = 38
    for i,v in next, Inventory:GetChildren() do 
        if v:IsA('TextLabel') then 
            v:Destroy()
        end
    end
end

--// Inventory Searcher 
InventoryViewerGUI.Parent = game.CoreGui 
syn.protect_gui(InventoryViewerGUI)
InventoryViewerGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

backframe.Name = "backframe"
backframe.Parent = InventoryViewerGUI
backframe.BackgroundColor3 = Color3.fromRGB(78, 78, 78)
backframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
backframe.Position = UDim2.new(0.00401860476, 0, 0.231227651, 0)

backframe.Size = UDim2.new(0, 203, 0, 42)
innerframe.Name = "innerframe"
innerframe.Parent = backframe
innerframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
innerframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
innerframe.Position = UDim2.new(0, 2, 0, 2)
innerframe.Size = UDim2.new(0, 199, 0, 38)

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(20, 20, 20)), ColorSequenceKeypoint.new(0.94, Color3.fromRGB(20, 20, 20)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(27, 27, 27))}
UIGradient.Rotation = 270
UIGradient.Parent = innerframe

playervalues.Name = "playervalues"
playervalues.Parent = innerframe

players_name.Name = "players_name"
players_name.Parent = playervalues
players_name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
players_name.BackgroundTransparency = 1.000
players_name.Position = UDim2.new(0, 3, 0, 1.5)
players_name.Size = UDim2.new(0, 191, 0, 17)
players_name.Font = Enum.Font.Code
players_name.Text = "players_name"
players_name.TextColor3 = Color3.fromRGB(245, 245, 245)
players_name.TextSize = 14.000
players_name.TextXAlignment = Enum.TextXAlignment.Left

players_name_bold.Name = "players_name_bold"
players_name_bold.Parent = playervalues
players_name_bold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
players_name_bold.BackgroundTransparency = 1.000
players_name_bold.Position = UDim2.new(0, 3, 0, 1.5)
players_name_bold.Size = UDim2.new(0, 191, 0, 17)
players_name_bold.Font = Enum.Font.Code
players_name_bold.Text = "players_name"
players_name_bold.TextColor3 = Color3.fromRGB(245, 245, 245)
players_name_bold.TextSize = 14.000
players_name_bold.TextXAlignment = Enum.TextXAlignment.Left

player_inventory_bold.Parent = playervalues
player_inventory_bold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
player_inventory_bold.BackgroundTransparency = 1.000
player_inventory_bold.Position = UDim2.new(0, 3, 0, 14.5)
player_inventory_bold.Size = UDim2.new(0, 191, 0, 17)
player_inventory_bold.Font = Enum.Font.Code
player_inventory_bold.Text = "[Inventory] :"
player_inventory_bold.TextColor3 = Color3.fromRGB(245, 245, 245)
player_inventory_bold.TextSize = 14.000
player_inventory_bold.TextXAlignment = Enum.TextXAlignment.Left


player_inventory.Name = "player_inventory"
player_inventory.Parent = playervalues
player_inventory.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
player_inventory.BackgroundTransparency = 1.000
player_inventory.Position = UDim2.new(0, 3, 0, 14.5)
player_inventory.Size = UDim2.new(0, 191, 0, 17)
player_inventory.Font = Enum.Font.Code
player_inventory.Text = "[Inventory] :"
player_inventory.TextColor3 = Color3.fromRGB(245, 245, 245)
player_inventory.TextSize = 14.000
player_inventory.TextXAlignment = Enum.TextXAlignment.Left

Inventory.Name = "Inventory"
Inventory.Parent = innerframe
Inventory.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Inventory.BackgroundTransparency = 1.000
Inventory.Position = UDim2.new(0, 3, 0, 30)
Inventory.Size = UDim2.new(0, 50, 0, 0)

UIListLayout.Parent = Inventory
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.FillDirection = 'Vertical'
UIPadding.Parent = Inventory
UIPadding.PaddingLeft = UDim.new(0.01, 0)
UIPadding.PaddingTop = UDim.new(1,0)

utils.accent.Name = "accent"
utils.accent.Parent = backframe
utils.accent.BackgroundColor3 = Color3.fromRGB(255, 229, 31)
utils.accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
utils.accent.BorderSizePixel = 1
utils.accent.Position = UDim2.new(0, 2.5, 0, 2.5)
utils.accent.Size = UDim2.new(0, 199, 0, 2)
local inner_frame_offset = 38

Inventory.ChildAdded:Connect(function(z)
    if z:IsA('TextLabel')  then
        inner_frame_offset = inner_frame_offset +  17
        innerframe.Size = UDim2.new(0,199,0,inner_frame_offset)
        backframe.Size = UDim2.new(0,203,0,inner_frame_offset + 4)
    end
end)
Inventory.ChildRemoved:Connect(function(z)
    if z:IsA('TextLabel')  then
        inner_frame_offset = inner_frame_offset - 17
        innerframe.Size = UDim2.new(0,199,0,inner_frame_offset)
        backframe.Size = UDim2.new(0,203,0,inner_frame_offset + 4)
    end
end)
return utils 
