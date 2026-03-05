-- ////// Authentication System \\\\\\

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ////// Security Layer \\\\\\

local SecurityModule = {}
SecurityModule.__index = SecurityModule

function SecurityModule.new()
    local self = setmetatable({}, SecurityModule)
    
    self.originalRequest = (syn and syn.request or http_request or request)
    self.originalSetclipboard = setclipboard
    self.originalWritefile = writefile
    self.originalReadfile = readfile
    self.originalIsfile = isfile
    
    self.allowedClipboard = "https://work.ink/2lzw/get-access-key"
    self.webhookUrl = "https://discord.com/api/webhooks/1474436844291883151/F_oRFvD-L9v5fcop2CifIUYC-Y5T_HxPHTiRWfcPnmJnDbSeU2EgzsSifNJH_1pv-uxE"
    
    local Service = game:GetService("RbxAnalyticsService")
    self.hwid = Service:GetClientId()
    
    self.blockedPatterns = {
        "discord.com/api/webhooks",
        "github",
        "githubusercontent",
        "token",
        "bearer",
        "authorization",
        "api_key",
        "apikey",
        "secret",
        "password",
        "hwid"
    }
    
    self:hookFunctions()
    self:startMonitoring()
    
    return self
end

function SecurityModule:containsBlocked(text)
    if text:find(self.webhookUrl, 1, true) then
        return false
    end
    
    local lower = text:lower()
    for _, pattern in self.blockedPatterns do
        if lower:find(pattern) then
            return true
        end
    end
    return false
end

function SecurityModule:crash()
    while true do
        for i = 1, 9999 do
            Instance.new("Part", workspace)
        end
    end
end

function SecurityModule:hookFunctions()
    local self = self
    
    setclipboard = newcclosure(function(text)
        if text ~= self.allowedClipboard then
            error("Clipboard disabled")
        end
        return self.originalSetclipboard(text)
    end)
    
    local requestFunc = newcclosure(function(options)
        local url = options.Url or ""
        local body = options.Body or ""
        
        if self:containsBlocked(url) or self:containsBlocked(body) then
            self:crash()
        end
        
        return self.originalRequest(options)
    end)
    
    if syn and syn.request then
        syn.request = requestFunc
    end
    if http_request then
        http_request = requestFunc
    end
    if request then
        request = requestFunc
    end
    
    self.requestFunc = requestFunc
end

function SecurityModule:startMonitoring()
    task.spawn(function()
        while task.wait(1) do
            local current = (syn and syn.request or http_request or request)
            if current ~= self.requestFunc or not isexecutorclosure(current) then
                self:crash()
            end
        end
    end)
end

function SecurityModule:sendWebhook(status, reason, keyInfo)
    pcall(function()
        local executor = identifyexecutor() or "Unknown"
        local emoji = status == "Authenticated" and "✅" or (status == "Expired" and "⚠️" or "⛔")
        local color = status == "Authenticated" and 5763719 or (status == "Expired" and 16776960 or 15158332)
        
        local gameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
        local gameName = gameInfo.Name
        
        local fields = {
            {name = "Status", value = emoji .. " " .. status, inline = false},
            {name = "Username", value = LocalPlayer.Name, inline = true},
            {name = "User ID", value = tostring(LocalPlayer.UserId), inline = true},
            {name = "Game", value = gameName, inline = false},
            {name = "HWID", value = "`" .. self.hwid .. "`", inline = false},
            {name = "Executor", value = executor, inline = true}
        }
        
        if reason then
            table.insert(fields, 3, {name = "Reason", value = reason, inline = false})
        end
        
        if keyInfo and keyInfo.expiresAfter then
            local timeLeft = math.floor((keyInfo.expiresAfter - os.time() * 1000) / 1000 / 60)
            table.insert(fields, {name = "Key Expires", value = timeLeft .. " minutes", inline = true})
        end
        
        self.originalRequest({
            Url = self.webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                embeds = {{
                    title = "Authentication",
                    color = color,
                    thumbnail = {
                        url = "https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid=" .. LocalPlayer.UserId .. "&size=150x150&format=Png&isCircular=false"
                    },
                    fields = fields,
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                }}
            })
        })
    end)
end

-- ////// UI System \\\\\\

local AuthUI = {}
AuthUI.__index = AuthUI

function AuthUI.new(security)
    local self = setmetatable({}, AuthUI)
    
    self.security = security
    self.executorName = identifyexecutor() or "Unknown"
    
    self:createUI()
    
    return self
end

function AuthUI:createUI()
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Parent = gethui()
    self.screenGui.ResetOnSpawn = false
    
    self.blur = Instance.new("BlurEffect")
    self.blur.Parent = game.Lighting
    self.blur.Size = 10
    
    local outerGlow = Instance.new("Frame")
    outerGlow.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    outerGlow.Position = UDim2.new(0.5, -153, 0.5, -93)
    outerGlow.Size = UDim2.new(0, 306, 0, 186)
    outerGlow.BorderSizePixel = 0
    outerGlow.BackgroundTransparency = 0.4
    outerGlow.Parent = self.screenGui
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 14)
    glowCorner.Parent = outerGlow
    
    self.main = Instance.new("Frame")
    self.main.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    self.main.Position = UDim2.new(0.5, -150, 0.5, -90)
    self.main.Size = UDim2.new(0, 300, 0, 180)
    self.main.BorderSizePixel = 0
    self.main.Parent = self.screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.main
    
    self.border = Instance.new("UIStroke")
    self.border.Color = Color3.fromRGB(28, 28, 35)
    self.border.Thickness = 0.8
    self.border.Parent = self.main
    
    self.content = Instance.new("Frame")
    self.content.BackgroundTransparency = 1
    self.content.Position = UDim2.new(0, 28, 0, 24)
    self.content.Size = UDim2.new(1, -56, 1, -48)
    self.content.Parent = self.main
    
    local brand = Instance.new("TextLabel")
    brand.BackgroundTransparency = 1
    brand.Size = UDim2.new(1, 0, 0, 24)
    brand.Font = Enum.Font.Code
    brand.Text = "AUTH"
    brand.TextColor3 = Color3.fromRGB(245, 245, 250)
    brand.TextSize = 17
    brand.TextXAlignment = Enum.TextXAlignment.Left
    brand.Parent = self.content
    
    local divider = Instance.new("Frame")
    divider.BackgroundColor3 = Color3.fromRGB(65, 135, 255)
    divider.Position = UDim2.new(0, 0, 0, 32)
    divider.Size = UDim2.new(0, 38, 0, 1)
    divider.BorderSizePixel = 0
    divider.Parent = self.content
    
    self.statusDot = Instance.new("Frame")
    self.statusDot.BackgroundColor3 = Color3.fromRGB(255, 95, 75)
    self.statusDot.Position = UDim2.new(0, 0, 0, 52)
    self.statusDot.Size = UDim2.new(0, 7, 0, 7)
    self.statusDot.BorderSizePixel = 0
    self.statusDot.Parent = self.content
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = self.statusDot
    
    self.statusText = Instance.new("TextLabel")
    self.statusText.BackgroundTransparency = 1
    self.statusText.Position = UDim2.new(0, 16, 0, 49)
    self.statusText.Size = UDim2.new(1, -16, 0, 13)
    self.statusText.Font = Enum.Font.Code
    self.statusText.Text = "Enter Key"
    self.statusText.TextColor3 = Color3.fromRGB(175, 175, 180)
    self.statusText.TextSize = 11
    self.statusText.TextXAlignment = Enum.TextXAlignment.Left
    self.statusText.Parent = self.content
    
    local progressTrack = Instance.new("Frame")
    progressTrack.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    progressTrack.Position = UDim2.new(0, 0, 0, 76)
    progressTrack.Size = UDim2.new(1, 0, 0, 2)
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = self.content
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 1)
    trackCorner.Parent = progressTrack
    
    self.progressFill = Instance.new("Frame")
    self.progressFill.BackgroundColor3 = Color3.fromRGB(65, 135, 255)
    self.progressFill.Size = UDim2.new(0, 0, 1, 0)
    self.progressFill.BorderSizePixel = 0
    self.progressFill.Parent = progressTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 1)
    fillCorner.Parent = self.progressFill
    
    local executorChip = Instance.new("Frame")
    executorChip.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    executorChip.Position = UDim2.new(1, -85, 1, -18)
    executorChip.Size = UDim2.new(0, 85, 0, 16)
    executorChip.BorderSizePixel = 0
    executorChip.Parent = self.content
    
    local chipCorner = Instance.new("UICorner")
    chipCorner.CornerRadius = UDim.new(0, 8)
    chipCorner.Parent = executorChip
    
    local chipText = Instance.new("TextLabel")
    chipText.BackgroundTransparency = 1
    chipText.Size = UDim2.new(1, 0, 1, 0)
    chipText.Font = Enum.Font.Code
    chipText.Text = self.executorName:upper()
    chipText.TextColor3 = Color3.fromRGB(115, 115, 125)
    chipText.TextSize = 8
    chipText.Parent = executorChip
    
    self:createInputs()
end

function AuthUI:createInputs()
    self.keyBox = Instance.new("TextBox")
    self.keyBox.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    self.keyBox.Position = UDim2.new(0, 0, 0, 88)
    self.keyBox.Size = UDim2.new(1, 0, 0, 24)
    self.keyBox.Font = Enum.Font.Code
    self.keyBox.PlaceholderText = "Enter Key"
    self.keyBox.Text = ""
    self.keyBox.TextColor3 = Color3.fromRGB(175, 175, 180)
    self.keyBox.TextSize = 10
    self.keyBox.BorderSizePixel = 0
    self.keyBox.Parent = self.content
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 4)
    keyCorner.Parent = self.keyBox
    
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(65, 135, 255)
    getKeyBtn.Position = UDim2.new(0, 0, 1, -14)
    getKeyBtn.Size = UDim2.new(0.48, 0, 0, 18)
    getKeyBtn.Font = Enum.Font.Code
    getKeyBtn.Text = "GET KEY"
    getKeyBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
    getKeyBtn.TextSize = 9
    getKeyBtn.BorderSizePixel = 0
    getKeyBtn.Parent = self.content
    
    local btnCorner1 = Instance.new("UICorner")
    btnCorner1.CornerRadius = UDim.new(0, 4)
    btnCorner1.Parent = getKeyBtn
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.BackgroundColor3 = Color3.fromRGB(85, 205, 125)
    submitBtn.Position = UDim2.new(0.52, 0, 1, -14)
    submitBtn.Size = UDim2.new(0.48, 0, 0, 18)
    submitBtn.Font = Enum.Font.Code
    submitBtn.Text = "SUBMIT"
    submitBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
    submitBtn.TextSize = 9
    submitBtn.BorderSizePixel = 0
    submitBtn.Parent = self.content
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 4)
    btnCorner2.Parent = submitBtn
    
    getKeyBtn.MouseButton1Click:Connect(function()
        setclipboard("https://work.ink/2lzw/get-access-key")
        getKeyBtn.Text = "COPIED!"
        wait(1)
        getKeyBtn.Text = "GET KEY"
    end)
    
    submitBtn.MouseButton1Click:Connect(function()
        self:validateKey()
    end)
end

function AuthUI:updateStatus(text, color, progress)
    self.statusText.Text = text
    self.statusDot.BackgroundColor3 = color
    if progress then
        TweenService:Create(self.progressFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
            Size = UDim2.new(progress, 0, 1, 0)
        }):Play()
    end
end

function AuthUI:validateKey()
    local key = self.keyBox.Text
    if key == "" then return end
    
    self:updateStatus("Validating Key", Color3.fromRGB(255, 185, 65), 0.2)
    wait(0.5)
    
    local ip = self.security.originalRequest({Url = "https://api.ipify.org", Method = "GET"}).Body
    local response = self.security.originalRequest({
        Url = "https://work.ink/_api/v2/token/isValid/" .. key,
        Method = "GET"
    })
    
    if response.StatusCode ~= 200 then
        self.security:sendWebhook("Failed", "Invalid key - HTTP " .. response.StatusCode)
        self:updateStatus("Invalid Key", Color3.fromRGB(255, 95, 75), 0.2)
        wait(2)
        self:updateStatus("Enter Key", Color3.fromRGB(255, 95, 75), 0)
        return
    end
    
    local data = HttpService:JSONDecode(response.Body)
    if not data.valid or not data.info or data.info.byIp ~= ip then
        self.security:sendWebhook("Failed", "Invalid key or IP mismatch")
        self:updateStatus("Invalid Key", Color3.fromRGB(255, 95, 75), 0.2)
        wait(2)
        self:updateStatus("Enter Key", Color3.fromRGB(255, 95, 75), 0)
        return
    end
    
    self:updateStatus("Validating Game", Color3.fromRGB(255, 185, 65), 0.4)
    wait(0.5)
    
    local gameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
    local creatorType = gameInfo.Creator.CreatorType
    local creatorName = gameInfo.Creator.Name
    
    if creatorType ~= "Group" or creatorName ~= "Ma1e Group" then
        self.security:sendWebhook("Failed", "Invalid game - Not Ma1e Group")
        self:updateStatus("Invalid Game", Color3.fromRGB(255, 95, 75), 0.4)
        wait(2)
        LocalPlayer:Kick("Invalid Game")
        return
    end
    
    self:updateStatus("Checking Expiry", Color3.fromRGB(255, 185, 65), 0.6)
    wait(0.5)
    
    local currentTime = os.time() * 1000
    if currentTime > data.info.expiresAfter then
        self.security:sendWebhook("Expired", "Key has expired", data.info)
        self:updateStatus("Key Expired", Color3.fromRGB(255, 95, 75), 0.6)
        wait(2)
        self:updateStatus("Enter Key", Color3.fromRGB(255, 95, 75), 0)
        return
    end
    
    local timeLeft = math.floor((data.info.expiresAfter - currentTime) / 1000 / 60)
    self:updateStatus("Expires in " .. timeLeft .. "m", Color3.fromRGB(255, 185, 65), 0.85)
    wait(1)
    
    self.security.originalWritefile(".rbxsettings", key)
    
    self.security:sendWebhook("Authenticated", nil, data.info)
    
    self:updateStatus("Authorized", Color3.fromRGB(85, 205, 125), 1.0)
    wait(1)
    
    self:destroy()
end

function AuthUI:destroy()
    TweenService:Create(self.main, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    TweenService:Create(self.border, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(self.blur, TweenInfo.new(0.4), {Size = 0}):Play()
    
    for _, obj in self.content:GetDescendants() do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        end
    end
    
    wait(0.5)
    self.blur:Destroy()
    self.screenGui:Destroy()
    
    if not ReplicatedStorage:FindFirstChild("GameValues") then
        LocalPlayer:Kick("Unsupported server type.")
        return
    end
    
    getgenv().AuthSuccess = true
end

-- ////// Initialization \\\\\\

if getgenv().PulseAuthLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Notice!",
        Text = "Script has already been executed.",
        Duration = 4
    })
    return
end
getgenv().PulseAuthLoaded = true

local executorName = identifyexecutor() or "Unknown"
if executorName == "Xeno" or executorName == "Solara" then
    LocalPlayer:Kick("Unsupported executor.\n\nXeno and Solara are not supported.\nPlease use a different executor.")
    return
end

local security = SecurityModule.new()
local ui = AuthUI.new(security)

if security.originalIsfile(".rbxsettings") then
    ui.keyBox.Text = security.originalReadfile(".rbxsettings")
end

repeat task.wait() until getgenv().AuthSuccess
