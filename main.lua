local fake = function() return 'asd' end
if not is_synapse_function(fake) then while true do end end

local StreamSnipe = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextLabel_2 = Instance.new("TextLabel")
local UsernameBox = Instance.new("TextBox")
local TextLabel_3 = Instance.new("TextLabel")
local PlaceIdBox = Instance.new("TextBox")
local StartButton = Instance.new("TextButton")
local HttpService = game:GetService("HttpService")
local EAsy = Instance.new("UICorner")
local EasyV2 = Instance.new("UICorner")
local EasyV3 = Instance.new("UICorner")
EasyV3.Parent = StartButton
EasyV2.Parent = Frame
EAsy.Parent = TextLabel
StreamSnipe.Name = HttpService:GenerateGUID(false)
StreamSnipe.Parent = game:GetService("CoreGui")

Frame.Parent = StreamSnipe
Frame.Active = true
Frame.BackgroundColor3 = Color3.new(0.121569, 0.121569, 0.121569)
Frame.BorderColor3 = Color3.new(0.121569, 0.121569, 0.121569)
Frame.Position = UDim2.new(0, 430, 0, 200)
Frame.Size = UDim2.new(0, 400, 0, 260)
Frame.Draggable = true

TextLabel.Parent = Frame
TextLabel.Active = true
TextLabel.BackgroundColor3 = Color3.new(1, 0, 0)
TextLabel.BorderColor3 = Color3.new(0, 0, 0)
TextLabel.Size = UDim2.new(0, 400, 0, 40)
TextLabel.Font = Enum.Font.SourceSansLight
TextLabel.Text = "Synapse X Stream Sniper"
TextLabel.TextSize = 24

TextLabel_2.Parent = Frame
TextLabel_2.Active = true
TextLabel_2.BackgroundColor3 = Color3.new(0.121569, 0.121569, 0.121569)
TextLabel_2.BorderColor3 = Color3.new(0.121569, 0.121569, 0.121569)
TextLabel_2.Position = UDim2.new(0, 10, 0, 50)
TextLabel_2.Size = UDim2.new(0, 380, 0, 20)
TextLabel_2.Font = Enum.Font.SourceSansLight
TextLabel_2.Text = "Username/UserId:"
TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
TextLabel_2.TextSize = 16

UsernameBox.Name = "UsernameBox"
UsernameBox.Parent = Frame
UsernameBox.BackgroundColor3 = Color3.new(0.239216, 0.239216, 0.239216)
UsernameBox.BorderColor3 = Color3.new(0.121569, 0.121569, 0.121569)
UsernameBox.Position = UDim2.new(0, 10, 0, 80)
UsernameBox.Size = UDim2.new(0, 380, 0, 40)
UsernameBox.Font = Enum.Font.SourceSansLight
UsernameBox.PlaceholderColor3 = Color3.new(1, 1, 1)
UsernameBox.PlaceholderText = "Enter Username Here"
UsernameBox.Text = ""
UsernameBox.TextColor3 = Color3.new(1, 1, 1)
UsernameBox.TextSize = 18

TextLabel_3.Parent = Frame
TextLabel_3.Active = true
TextLabel_3.BackgroundColor3 = Color3.new(0.121569, 0.121569, 0.121569)
TextLabel_3.BorderColor3 = Color3.new(0.121569, 0.121569, 0.121569)
TextLabel_3.Position = UDim2.new(0, 10, 0, 130)
TextLabel_3.Size = UDim2.new(0, 380, 0, 20)
TextLabel_3.Font = Enum.Font.SourceSansLight
TextLabel_3.Text = "Place Id:"
TextLabel_3.TextColor3 = Color3.new(1, 1, 1)
TextLabel_3.TextSize = 16

PlaceIdBox.Name = "PlaceIdBox"
PlaceIdBox.Parent = Frame
PlaceIdBox.BackgroundColor3 = Color3.new(0.239216, 0.239216, 0.239216)
PlaceIdBox.BorderColor3 = Color3.new(0.121569, 0.121569, 0.121569)
PlaceIdBox.Position = UDim2.new(0, 10, 0, 160)
PlaceIdBox.Size = UDim2.new(0, 380, 0, 40)
PlaceIdBox.Font = Enum.Font.SourceSansLight
PlaceIdBox.PlaceholderColor3 = Color3.new(1, 1, 1)
PlaceIdBox.PlaceholderText = "Enter PlaceId Here"
PlaceIdBox.Text = ""
PlaceIdBox.TextColor3 = Color3.new(1, 1, 1)
PlaceIdBox.TextSize = 18

StartButton.Name = "StartButton"
StartButton.Parent = Frame
StartButton.BackgroundColor3 = Color3.new(0.160784, 0.160784, 0.160784)
StartButton.BorderColor3 = Color3.new(0.121569, 0.121569, 0.121569)
StartButton.Position = UDim2.new(0, 10, 0, 210)
StartButton.Size = UDim2.new(0, 380, 0, 40)
StartButton.Font = Enum.Font.SourceSansLight
StartButton.Text = "Start"
StartButton.TextColor3 = Color3.new(1, 1, 1)
StartButton.TextSize = 24

local Debounce = false
local Kill = false

local function HttpGet(url)
    local response = game:HttpGet(url)
    return HttpService:JSONDecode(response)
end

local function Status(text, tout)
    StartButton.Text = text
    if tout then
        spawn(function()
            wait(tout)
            StartButton.Text = "Start"
        end)
    end
end

StartButton.MouseButton1Click:Connect(function()
    if Debounce then
        Kill = true
        Debounce = false
        return
    end

    Debounce = true
    local PlaceId = PlaceIdBox.Text
    Status("Stage 1...")

    local Suc, UserId = pcall(function()
        if tonumber(UsernameBox.Text) then
            return tonumber(UsernameBox.Text)
        end
        return game:GetService("Players"):GetUserIdFromNameAsync(UsernameBox.Text)
    end)

    if not Suc then
        return Status("Username does not exist!", 3)
    end

    Status("Stage 2...")

    local thumbnailResponse = HttpGet("https://thumbnails.roblox.com/v1/headshot?userIds=" .. UserId .. "&size=48x48&format=Png&isCircular=false")
    local thumbnailData = thumbnailResponse.data and thumbnailResponse.data[1]
    local Thumbnail = thumbnailData and thumbnailData.imageUrl or ""

    Status("Stage 3...")

    local Cursor = ""
    while true do
        local url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=10&cursor=%s", PlaceId, Cursor)
        local response = HttpGet(url)

        if not response or not response.data then
            return Status("Failed to get game! (API issue)", 3)
        end

        for _, server in pairs(response.data) do
            for _, player in pairs(server.players) do
                if player.id == UserId then
                    Status("Complete!")
                    game:GetService("TeleportService"):TeleportToPlaceInstance(tonumber(PlaceId), server.id)
                    local FailCounter = 0
                    game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
                        if State == Enum.TeleportState.Failed then
                            FailCounter = FailCounter + 1
                            Status("Failed to teleport. (retry " .. tostring(FailCounter) .. ")")
                            game:GetService("TeleportService"):TeleportToPlaceInstance(tonumber(PlaceId), server.id)
                        end
                    end)
                    return
                end
            end
        end

        Status("Stage 3 (scanning servers)...")

        if not response.nextPageCursor or response.nextPageCursor == "" then
            return Status("Failed to find player!", 3)
        end

        if Kill then
            Kill = false
            Debounce = false
            Status("Cancelled.", 3)
            return
        end

        Cursor = response.nextPageCursor
    end
end)
