if getgenv().PulseAuthLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Notice!",
        Text = "Script has already been executed.",
        Duration = 4
    })
    return
end
getgenv().PulseAuthLoaded = true

local ExecutorName = identifyexecutor() or "Unknown"

if ExecutorName == "Xeno" or ExecutorName == "Solara" then
    game:GetService("Players").LocalPlayer:Kick("Unsupported executor.\n\nXeno and Solara are not supported.\nPlease use a different executor.")
    return
end

local ScreenGui = Instance.new("ScreenGui")
local Blur = Instance.new("BlurEffect")
local Main = Instance.new("Frame")
local Corner = Instance.new("UICorner")
local OuterGlow = Instance.new("Frame")
local GlowCorner = Instance.new("UICorner")
local Content = Instance.new("Frame")
local Brand = Instance.new("TextLabel")
local Divider = Instance.new("Frame")
local StatusDot = Instance.new("Frame")
local DotCorner = Instance.new("UICorner")
local StatusText = Instance.new("TextLabel")
local ProgressTrack = Instance.new("Frame")
local TrackCorner = Instance.new("UICorner")
local ProgressFill = Instance.new("Frame")
local FillCorner = Instance.new("UICorner")
local ExecutorChip = Instance.new("Frame")
local ChipCorner = Instance.new("UICorner")
local ChipText = Instance.new("TextLabel")
local Border = Instance.new("UIStroke")

ScreenGui.Parent = gethui()
ScreenGui.ResetOnSpawn = false

Blur.Parent = game.Lighting
Blur.Size = 10

OuterGlow.Parent = ScreenGui
OuterGlow.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
OuterGlow.Position = UDim2.new(0.5, -153, 0.5, -93)
OuterGlow.Size = UDim2.new(0, 306, 0, 186)
OuterGlow.BorderSizePixel = 0
OuterGlow.BackgroundTransparency = 0.4

GlowCorner.CornerRadius = UDim.new(0, 14)
GlowCorner.Parent = OuterGlow

Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
Main.Position = UDim2.new(0.5, -150, 0.5, -90)
Main.Size = UDim2.new(0, 300, 0, 180)
Main.BorderSizePixel = 0

Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

Border.Parent = Main
Border.Color = Color3.fromRGB(28, 28, 35)
Border.Thickness = 0.8

Content.Parent = Main
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 28, 0, 24)
Content.Size = UDim2.new(1, -56, 1, -48)

Brand.Parent = Content
Brand.BackgroundTransparency = 1
Brand.Size = UDim2.new(1, 0, 0, 24)
Brand.Font = Enum.Font.Code
Brand.Text = "AUTH"
Brand.TextColor3 = Color3.fromRGB(245, 245, 250)
Brand.TextSize = 17
Brand.TextXAlignment = Enum.TextXAlignment.Left

Divider.Parent = Content
Divider.BackgroundColor3 = Color3.fromRGB(65, 135, 255)
Divider.Position = UDim2.new(0, 0, 0, 32)
Divider.Size = UDim2.new(0, 38, 0, 1)
Divider.BorderSizePixel = 0

StatusDot.Parent = Content
StatusDot.BackgroundColor3 = Color3.fromRGB(255, 95, 75)
StatusDot.Position = UDim2.new(0, 0, 0, 52)
StatusDot.Size = UDim2.new(0, 7, 0, 7)
StatusDot.BorderSizePixel = 0

DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

StatusText.Parent = Content
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 16, 0, 49)
StatusText.Size = UDim2.new(1, -16, 0, 13)
StatusText.Font = Enum.Font.Code
StatusText.Text = "Enter Key"
StatusText.TextColor3 = Color3.fromRGB(175, 175, 180)
StatusText.TextSize = 11
StatusText.TextXAlignment = Enum.TextXAlignment.Left

ProgressTrack.Parent = Content
ProgressTrack.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
ProgressTrack.Position = UDim2.new(0, 0, 0, 76)
ProgressTrack.Size = UDim2.new(1, 0, 0, 2)
ProgressTrack.BorderSizePixel = 0

TrackCorner.CornerRadius = UDim.new(0, 1)
TrackCorner.Parent = ProgressTrack

ProgressFill.Parent = ProgressTrack
ProgressFill.BackgroundColor3 = Color3.fromRGB(65, 135, 255)
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BorderSizePixel = 0

FillCorner.CornerRadius = UDim.new(0, 1)
FillCorner.Parent = ProgressFill

ExecutorChip.Parent = Content
ExecutorChip.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
ExecutorChip.Position = UDim2.new(1, -85, 1, -18)
ExecutorChip.Size = UDim2.new(0, 85, 0, 16)
ExecutorChip.BorderSizePixel = 0

ChipCorner.CornerRadius = UDim.new(0, 8)
ChipCorner.Parent = ExecutorChip

ChipText.Parent = ExecutorChip
ChipText.BackgroundTransparency = 1
ChipText.Size = UDim2.new(1, 0, 1, 0)
ChipText.Font = Enum.Font.Code
ChipText.Text = ExecutorName:upper()
ChipText.TextColor3 = Color3.fromRGB(115, 115, 125)
ChipText.TextSize = 8

local originalGetgc = getgc
local originalDebug = debug
local originalGetreg = getreg
local originalGetscripts = getscripts
local originalGetscriptclosure = getscriptclosure
local originalGetnilinstances = getnilinstances
local originalWritefile = writefile
local originalReadfile = readfile
local originalListfiles = listfiles
local originalDelfile = delfile
local originalMakefolder = makefolder
local originalIsfolder = isfolder
local originalIsfile = isfile
local OrigRestore = clonefunction(restorefunction)
local originalSetclipboard = setclipboard

local BS = {
    ["discord.com/api/webhooks"] = "get a job cornball",
    ["github"] = "go do something productive",
    ["githubusercontent"] = "this what u doing with ur time?",
    ["1467048050655625349"] = "embarrassing honestly",
    ["token"] = "ur not getting anything",
    ["bearer"] = "find a hobby bro",
    ["authorization"] = "touch grass",
    ["api_key"] = "do better",
    ["apikey"] = "waste of time",
    ["secret"] = "go outside",
    ["password"] = "get help",
    ["hwid"] = "sad honestly"
}

local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local CacheFolder = "RBXSoundCache"
local ScriptHash = "v1.1.8"

local Method1 = game:GetService("RbxAnalyticsService"):GetClientId()
local Service = game:GetService("RbxAnalyticsService")
local Method2 = Service.GetClientId(Service)
local HWID = Method2

local function updateStatus(text, color, progress)
    StatusText.Text = text
    StatusDot.BackgroundColor3 = color
    if progress then
        TweenService:Create(ProgressFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
            Size = UDim2.new(progress, 0, 1, 0)
        }):Play()
    end
end

local function failAuth(reason)
    updateStatus(reason, Color3.fromRGB(255, 95, 75), 0)
    wait(3)
    LocalPlayer:Kick("Authentication failed: " .. reason)
end

local function GenerateRandomString(Length: number): string
    local Characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local Result = ""
    for Index = 1, Length do
        local RandomIndex = math.random(1, #Characters)
        Result = Result .. Characters:sub(RandomIndex, RandomIndex)
    end
    return Result
end

local function LogDetection(Reason: string)
    if not getgenv().AutoBlacklist then return end
    local Files = originalListfiles(CacheFolder)
    local DetectionCount = 0
    for _, File in pairs(Files) do
        if not File:match("%.hash$") then
            DetectionCount = DetectionCount + 1
        end
    end
    originalWritefile(CacheFolder .. "/." .. GenerateRandomString(24) .. ".tmp", Reason .. " | " .. os.date("%Y-%m-%d %H:%M:%S"))
    
    if DetectionCount + 1 >= 5 then
        pcall(function()
            (syn and syn.request or http_request or request)({
                Url = "https://discord.com/api/webhooks/1467048050655625349/TlCiiteQD8a6n9bxMZ12ltADoSPG_4puUmpwLevQZKvqqli-lROEzjmg7c3JlA3GJsrO",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    content = "Auto-blacklist request - 5+ detections",
                    embeds = {{
                        title = "Auto Blacklist",
                        color = 15158332,
                        fields = {
                            {name = "HWID", value = "`" .. HWID .. "`", inline = false},
                            {name = "Username", value = LocalPlayer.Name, inline = true},
                            {name = "Detections", value = tostring(DetectionCount + 1), inline = true},
                            {name = "Action", value = "Blacklist until next update", inline = false}
                        },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                    }}
                })
            })
        end)
    end
end

local function CrashClient(DetectionReason: string)
    LogDetection(DetectionReason)
    local Executor = identifyexecutor() or "Unknown"
    
    local WebhookTitle = "HTTP SPY DETECTED"
    if DetectionReason:match("HWID") then
        WebhookTitle = "HWID SPOOFING DETECTED"
    end
    
    pcall(function()
        (syn and syn.request or http_request or request)({
            Url = "https://discord.com/api/webhooks/1467048050655625349/TlCiiteQD8a6n9bxMZ12ltADoSPG_4puUmpwLevQZKvqqli-lROEzjmg7c3JlA3GJsrO",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                embeds = {{
                    title = WebhookTitle,
                    color = 15158332,
                    fields = {
                        {name = "Detection", value = DetectionReason, inline = false},
                        {name = "Username", value = LocalPlayer.Name, inline = true},
                        {name = "HWID", value = "`" .. HWID .. "`", inline = false},
                        {name = "Executor", value = Executor, inline = true}
                    },
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                }}
            })
        })
    end)
    
    while true do
        for i = 1, 9999 do
            Instance.new("Part", workspace)
        end
    end
end

local spyPatterns = {
    "discord%.com/api/webhooks",
    "webhook",
    "HttpSpy",
    "RequestLogger", 
    "ToopSpy",
    "HTTP SPY",
    "REQUEST SPY",
    "WEBHOOK SPY",
    "Method:",
    "URL:",
    "Body:",
    "Headers:",
    "Response:",
    "Status Code:"
}

local mt = getrawmetatable(game)
setreadonly(mt, false)

local originalIndex = mt.__index
mt.__index = newcclosure(function(self, key)
    local result = originalIndex(self, key)
    
    if key == "Text" and type(result) == "string" then
        for _, pattern in pairs(spyPatterns) do
            if result:match(pattern) then
                CrashClient("Spy text detected in GUI: " .. pattern)
            end
        end
    end
    
    return result
end)

local originalNewindex = mt.__newindex
mt.__newindex = newcclosure(function(self, key, value)
    if key == "Text" and type(value) == "string" then
        for _, pattern in pairs(spyPatterns) do
            if value:match(pattern) then
                CrashClient("Spy text being set in GUI: " .. pattern)
            end
        end
    end
    
    return originalNewindex(self, key, value)
end)

setreadonly(mt, true)

if Method1 ~= Method2 then
    CrashClient("HWID spoofing detected")
end

local HwidFunctions = {"gethwid", "getexecutorhwid", "get_hwid", "GetHWID"}
local OriginalHwidInfo = {}
local OriginalIdentify = identifyexecutor
local OriginalIdentifyInfo = pcall(originalDebug.getinfo, OriginalIdentify) and originalDebug.getinfo(OriginalIdentify) or {}

for _, funcName in pairs(HwidFunctions) do
    local func = getgenv()[funcName] or _G[funcName]
    if func then
        local success, info = pcall(originalDebug.getinfo, func)
        OriginalHwidInfo[funcName] = {
            func = func,
            info = success and info or {}
        }
    end
end

task.spawn(function()
    while task.wait(5) do
        local TestMethod1 = game:GetService("RbxAnalyticsService"):GetClientId()
        local TestService = game:GetService("RbxAnalyticsService")
        local TestMethod2 = TestService.GetClientId(TestService)
        
        if TestMethod1 ~= TestMethod2 then
            CrashClient("HWID spoofing detected")
        end
        
        if identifyexecutor ~= OriginalIdentify then
            CrashClient("identifyexecutor function replaced")
        end
        
        if getgenv().EmplicsWebhookSpy or getgenv().StringDumper or getgenv().discordwebhookdetector then
            CrashClient("String dumper or webhook spy detected")
        end
    end
end)

game:GetService("LogService").MessageOut:Connect(function(Message)
    for _, pattern in pairs(spyPatterns) do
        if Message:match(pattern) then
            CrashClient("Spy console output: " .. pattern)
        end
    end
end)

local function createSecureBlock(funcName: string)
    return function() 
        error(funcName .. " has been disabled by LOOEJ for security reasons.")
    end
end

local blockedWritefile = createSecureBlock("writefile")

local genv = getgenv()
local allowedLink = "https://work.ink/2lzw/get-access-key"

for name, value in pairs(genv) do
    if name:lower():find("clip") and type(value) == "function" then
        local original = value
        genv[name] = function(text: string)
            if text ~= allowedLink then
                error("Clipboard has been disabled by LOOEJ for security reasons.")
            end
            return original(text)
        end
    end
end

writefile = blockedWritefile
readfile = createSecureBlock("readfile")
listfiles = createSecureBlock("listfiles")
delfile = createSecureBlock("delfile")
makefolder = createSecureBlock("makefolder")
isfolder = createSecureBlock("isfolder")
isfile = createSecureBlock("isfile")

task.spawn(function()
    while task.wait(1) do
        if writefile ~= blockedWritefile then
            CrashClient("Attempted to restore blocked functions")
        end
    end
end)

if not originalIsfolder(CacheFolder) then
    originalMakefolder(CacheFolder)
end

local HashFile = CacheFolder .. "/.hash"
if originalIsfile(HashFile) then
    local StoredHash = originalReadfile(HashFile)
    if StoredHash ~= ScriptHash then
        for _, File in pairs(originalListfiles(CacheFolder)) do
            originalDelfile(File)
        end
        originalWritefile(HashFile, ScriptHash)
    end
else
    originalWritefile(HashFile, ScriptHash)
end

getgenv().AutoBlacklist = getgenv().AutoBlacklist == nil and false or getgenv().AutoBlacklist

if getgenv().AutoBlacklist then
    if originalIsfolder(CacheFolder) then
        local Files = originalListfiles(CacheFolder)
        local DetectionCount = 0
        for _, File in pairs(Files) do
            if not File:match("%.hash$") then
                DetectionCount = DetectionCount + 1
            end
        end
        
        if DetectionCount >= 5 then
            pcall(function()
                (syn and syn.request or http_request or request)({
                    Url = "https://discord.com/api/webhooks/1467048050655625349/TlCiiteQD8a6n9bxMZ12ltADoSPG_4puUmpwLevQZKvqqli-lROEzjmg7c3JlA3GJsrO",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({
                        content = "Auto-blacklist - 5+ detections on startup",
                        embeds = {{
                            title = "Auto Blacklist",
                            color = 15158332,
                            fields = {
                                {name = "HWID", value = "`" .. HWID .. "`", inline = false},
                                {name = "Username", value = LocalPlayer.Name, inline = true},
                                {name = "Detections", value = tostring(DetectionCount), inline = true}
                            },
                            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                        }}
                    })
                })
            end)
            LocalPlayer:Kick("You have been blacklisted until next update.\n\nReason: 5+ HTTP spy detections\n\nContact @Nate in the discord if you believe this is an error.")
            return
        end
    end
end

local RanTimes = 0
local Connection = game:GetService("RunService").Heartbeat:Connect(function()
    RanTimes += 1
end)

repeat
    task.wait()
until RanTimes >= 2

Connection:Disconnect()

local RealEnv = getfenv()

local SavedFunctions = {
    getfenv = getfenv,
    setfenv = setfenv,
    rawget = rawget,
    rawset = rawset,
    getmetatable = getmetatable,
    setmetatable = setmetatable,
    newproxy = newproxy,
    type = type,
    next = next,
    pairs = pairs,
    pcall = pcall,
    tostring = tostring
}

local function GenerateTrapKey(): string
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local key = ""
    for i = 1, math.random(30, 50) do
        key = key .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
    end
    return key
end

local function CorruptAndCrash()
    while true do
        for i = 1, 9999 do
            Instance.new("Part", workspace)
        end
    end
end

local HoneypotTraps = {}
for i = 1, 25 do
    local trapName = "_secure_" .. GenerateTrapKey() .. "_" .. i
    HoneypotTraps[trapName] = CorruptAndCrash
end

local FakeEnvironment = {}
local EnvironmentMeta = {
    __index = function(self, key)
        if HoneypotTraps[key] then
            HoneypotTraps[key]()
            return nil
        end
        
        local caller = SavedFunctions.getfenv(2)
        if caller ~= RealEnv then
            CorruptAndCrash()
        end
        
        return RealEnv[key]
    end,
    
    __newindex = function(self, key, value)
        local blockedKeys = {
            "getfenv", "setfenv", "require", "game", "script",
            "getmetatable", "setmetatable", "rawget", "rawset",
            "checkcaller", "getgenv", "getrenv"
        }
        
        for _, blocked in ipairs(blockedKeys) do
            if key == blocked then
                CorruptAndCrash()
                return
            end
        end
        
        local caller = SavedFunctions.getfenv(2)
        if caller ~= RealEnv then
            CorruptAndCrash()
        end
        
        RealEnv[key] = value
    end,
    
    __metatable = "Locked",
    
    __tostring = function()
        local caller = SavedFunctions.getfenv(2)
        if caller ~= RealEnv then
            CorruptAndCrash()
        end
        return "Environment"
    end,
    
    __call = CorruptAndCrash,
    __concat = CorruptAndCrash
}

SavedFunctions.setmetatable(FakeEnvironment, EnvironmentMeta)

local OriginalGetfenv = getfenv
getfenv = function(level)
    local caller = SavedFunctions.getfenv(2)
    if caller ~= RealEnv then
        CorruptAndCrash()
        return FakeEnvironment
    end
    return OriginalGetfenv(level)
end

local OriginalSetfenv = setfenv
setfenv = function(...)
    local caller = SavedFunctions.getfenv(2)
    if caller ~= RealEnv then
        CorruptAndCrash()
    end
    return OriginalSetfenv(...)
end

local OriginalGetmetatable = getmetatable
getmetatable = function(obj)
    if obj == FakeEnvironment or SavedFunctions.type(obj) == "table" then
        local caller = SavedFunctions.getfenv(2)
        if caller ~= RealEnv then
            CorruptAndCrash()
        end
    end
    return OriginalGetmetatable(obj)
end

local OriginalPairs = pairs
pairs = function(t)
    if t == RealEnv or t == FakeEnvironment then
        local caller = SavedFunctions.getfenv(2)
        if caller ~= RealEnv then
            CorruptAndCrash()
        end
    end
    return OriginalPairs(t)
end

local OriginalNext = next
next = function(t, k)
    if t == RealEnv or t == FakeEnvironment then
        local caller = SavedFunctions.getfenv(2)
        if caller ~= RealEnv then
            CorruptAndCrash()
        end
    end
    return OriginalNext(t, k)
end

getgc = CorruptAndCrash

debug = setmetatable({}, {
    __index = CorruptAndCrash,
    __newindex = CorruptAndCrash
})

getreg = CorruptAndCrash
getscripts = CorruptAndCrash
getscriptclosure = CorruptAndCrash
getnilinstances = CorruptAndCrash

local ScriptFingerprint = {}
local HandshakeKey = "HANDSHAKE_" .. math.random(100000, 999999)

local ValidationData = {
    expectedFunctions = {"getgc", "debug", "getreg"},
    protectionCount = 6,
    scriptLines = originalDebug.getinfo(1, "l").currentline,
    memorySignature = tostring(getfenv()):sub(-8)
}

local function generateHandshake(): string
    local state = ""
    for _, name in pairs(ValidationData.expectedFunctions) do
        state = state .. tostring(_G[name] ~= nil)
    end
    return state .. ValidationData.memorySignature
end

ScriptFingerprint[HandshakeKey] = generateHandshake()

task.spawn(function()
    while task.wait(30) do
        local currentHandshake = generateHandshake()
        if ScriptFingerprint[HandshakeKey] ~= currentHandshake then
            CorruptAndCrash()
        end
        
        if not RealEnv or not SavedFunctions.getfenv then
            CorruptAndCrash()
        end
        
        if getgc == originalGetgc or debug == originalDebug then
            CorruptAndCrash()
        end
        
        local env = getgenv()
        if env.StringDumper then
            CorruptAndCrash()
        end
    end
end)

if (syn and syn.request or http_request or request) and pcall(function() return isexecutorclosure end) and not isexecutorclosure((syn and syn.request or http_request or request)) then
    CrashClient("Request function already hooked")
end

task.spawn(function()
    if not pcall(function() return isexecutorclosure end) then return end
    
    local RequestFunction = (syn or http).request
    local OriginalFunction = RequestFunction
    local OriginalRequest = request
    local Metatable = getrawmetatable(game)
    setreadonly(Metatable, false)
    local OriginalNamecall = Metatable.__namecall
    setreadonly(Metatable, true)
    
    task.wait(2)

    while task.wait(0.5) do
        if getgenv().EmplicsWebhookSpy or getgenv().discordwebhookdetector or getgenv().pastebindetector or getgenv().githubdetector or getgenv().anylink or getgenv().kickbypass or getgenv().StringDumper then
            CrashClient("String dumper or webhook spy detected")
        end

        local CurrentFunction = (syn or http).request
        if CurrentFunction ~= OriginalFunction or not isexecutorclosure(CurrentFunction) then
            CrashClient("HTTP request function hooked")
        end
        
        if request and (request ~= OriginalRequest or not isexecutorclosure(request)) then
            CrashClient("Global request function hooked")
        end

        local CurrentMetatable = getrawmetatable(game)
        if CurrentMetatable.__namecall ~= OriginalNamecall and not isexecutorclosure(CurrentMetatable.__namecall) then
            CrashClient("Namecall metamethod hooked")
        end
        
        local TestMethod1 = game:GetService("RbxAnalyticsService"):GetClientId()
        local TestService = game:GetService("RbxAnalyticsService")
        local TestMethod2 = TestService.GetClientId(TestService)
        if TestMethod1 ~= TestMethod2 then
            CrashClient("HWID spoofing detected")
        end
    end
end)

local CHECKPOINT_LINK = "https://work.ink/2lzw/get-access-key"
local VALIDATE_URL = "https://work.ink/_api/v2/token/isValid/"

local function getIp()
    return request({Url = "https://api.ipify.org", Method = "GET"}).Body
end

local function validateKey(token, ip)
    local response = request({
        Url = VALIDATE_URL .. token,
        Method = "GET"
    })
    
    if response.StatusCode ~= 200 then return false end
    
    local data = HttpService:JSONDecode(response.Body)
    return data.valid and data.info and data.info.byIp == ip
end

local KeyBox = Instance.new("TextBox")
KeyBox.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
KeyBox.Position = UDim2.new(0, 0, 0, 88)
KeyBox.Size = UDim2.new(1, 0, 0, 24)
KeyBox.Font = Enum.Font.Code
KeyBox.PlaceholderText = "Enter Key"
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(175, 175, 180)
KeyBox.TextSize = 10
KeyBox.BorderSizePixel = 0
KeyBox.Parent = Content

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 4)
KeyCorner.Parent = KeyBox

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(65, 135, 255)
GetKeyBtn.Position = UDim2.new(0, 0, 1, -14)
GetKeyBtn.Size = UDim2.new(0.48, 0, 0, 18)
GetKeyBtn.Font = Enum.Font.Code
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
GetKeyBtn.TextSize = 9
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.Parent = Content

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 4)
BtnCorner1.Parent = GetKeyBtn

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.BackgroundColor3 = Color3.fromRGB(85, 205, 125)
SubmitBtn.Position = UDim2.new(0.52, 0, 1, -14)
SubmitBtn.Size = UDim2.new(0.48, 0, 0, 18)
SubmitBtn.Font = Enum.Font.Code
SubmitBtn.Text = "SUBMIT"
SubmitBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
SubmitBtn.TextSize = 9
SubmitBtn.BorderSizePixel = 0
SubmitBtn.Parent = Content

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 4)
BtnCorner2.Parent = SubmitBtn

GetKeyBtn.MouseButton1Click:Connect(function()
setclipboard(CHECKPOINT_LINK)
GetKeyBtn.Text = "COPIED!"
wait(1)
GetKeyBtn.Text = "GET KEY"
end)

local SavedKeyFile = ".rbxsettings"
if originalIsfile(SavedKeyFile) then
    KeyBox.Text = originalReadfile(SavedKeyFile)
end

local AuthAPI = "https://gist.githubusercontent.com/8931247412412421245524343255485937065/313c8ba8bc6abeeed8e8f6a444065d5f/raw/d7b76b5ca8b512f4dd05423aa16abc67c561c770/HappyHawkTuah.json"
local BlacklistURL = "https://gist.githubusercontent.com/8931247412412421245524343255485937065/bd881f722b597ba470a6b6067571f7a3/raw/85832531f29484681c316db7eeea3038bcf50236/LockEmUp.json"
local WhitelistURL = "https://gist.githubusercontent.com/8931247412412421245524343255485937065/81d3d7e7af49081dcbde2c9eaea2f137/raw/1b48f36d6ef614e370b70424639c69822b4057d7/Whitelist.json"
local Config = {EnableWhitelist=false,EnableHWID=false,EnableExpire=true,EnableErrorWebhook=true}

local function SendWebhook(Status: string, Reason: string?)
    if not Config.EnableErrorWebhook then return end
    local Success, Data = pcall(function() return HttpService:JSONDecode(game:HttpGet(AuthAPI)) end)
    if not Success then
        LocalPlayer:Kick("Failed to fetch authentication data. Please try again later.")
        return
    end
    local Executor = identifyexecutor() or "Unknown"
    local Emoji = Status == "Authenticated" and "✅" or (Status == "Expired" and "⚠️" or "⛔")
    local Color = Status == "Authenticated" and 5763719 or (Status == "Expired" and 16776960 or 15158332)
    local Fields = {
        {name="Status",value=Emoji.." "..Status,inline=false},
        {name="Username",value=LocalPlayer.Name,inline=true},
        {name="User ID",value=tostring(LocalPlayer.UserId),inline=true},
        {name="Game",value=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,inline=false},
        {name="HWID",value="`"..HWID.."`",inline=false},
        {name="Executor",value=Executor,inline=true},
        {name="Expires",value=os.date("%Y-%m-%d %H:%M:%S", Data.expire),inline=true}
    }
    if Reason then table.insert(Fields,3,{name="Reason",value=Reason,inline=false}) end
    pcall(function()
        (syn and syn.request or http_request or request)({
            Url="https://discord.com/api/webhooks/1467048050655625349/TlCiiteQD8a6n9bxMZ12ltADoSPG_4puUmpwLevQZKvqqli-lROEzjmg7c3JlA3GJsrO",
            Method="POST",
            Headers={["Content-Type"]="application/json"},
            Body=HttpService:JSONEncode({embeds={{title="Authentication",color=Color,thumbnail={url="https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid="..LocalPlayer.UserId.."&size=150x150&format=Png&isCircular=false"},fields=Fields,timestamp=os.date("!%Y-%m-%dT%H:%M:%S"),footer={text="PSS"}}}})
        })
    end)
end

SubmitBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if key == "" then return end
    
    updateStatus("Validating Key", Color3.fromRGB(255, 185, 65), 0.05)
    local ip = getIp()
    
    if not validateKey(key, ip) then
        updateStatus("Invalid Key", Color3.fromRGB(255, 95, 75), 0.05)
        wait(2)
        updateStatus("Enter Key", Color3.fromRGB(255, 95, 75), 0)
        return
    end
    
    originalWritefile(SavedKeyFile, key)
    
    KeyBox:Destroy()
    GetKeyBtn:Destroy()
    SubmitBtn:Destroy()
    
    updateStatus("Checking Executor", Color3.fromRGB(255, 185, 65), 0.1)
    wait(0.8)
    
    updateStatus("Verifying HWID", Color3.fromRGB(255, 185, 65), 0.15)
    if Method1 ~= Method2 then
        failAuth("HWID Spoofing Detected")
        return
    end
    wait(0.8)
    
    updateStatus("Validating Game", Color3.fromRGB(255, 185, 65), 0.25)
    local GameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    local CreatorType = GameInfo.Creator.CreatorType
    local CreatorName = GameInfo.Creator.Name
    
    if CreatorType ~= "Group" or CreatorName ~= "The Builder's Legion" then
        failAuth("Invalid Game")
        return
    end
    wait(0.8)
    
    updateStatus("Fetching Blacklist", Color3.fromRGB(255, 185, 65), 0.4)
    local BlacklistSuccess, BlacklistData = pcall(function() return HttpService:JSONDecode(game:HttpGet(BlacklistURL)) end)
    
    if not BlacklistSuccess then
        failAuth("Connection Failed")
        return
    end
    
    local Blacklist = BlacklistData.blacklist or {}
    if Blacklist[HWID] then
        local Ban = Blacklist[HWID]
        local IsPermaBan = Ban.ExpiresAt == 0
        local IsBanned = IsPermaBan or os.time() < Ban.ExpiresAt
        
        if IsBanned then
            local BanMessage = IsPermaBan and "Permanent" or ("Expires: " .. os.date("%Y-%m-%d %H:%M:%S", Ban.ExpiresAt))
            SendWebhook("Blacklisted", Ban.Reason .. " | " .. BanMessage)
            failAuth("Blacklisted")
            return
        end
    end
    wait(0.8)
    
    updateStatus("Checking Whitelist", Color3.fromRGB(255, 185, 65), 0.6)
    if Config.EnableWhitelist then
        local WhitelistSuccess, WhitelistData = pcall(function() return HttpService:JSONDecode(game:HttpGet(WhitelistURL)) end)
        if not WhitelistSuccess then
            failAuth("Connection Failed")
            return
        end
        
        local Whitelist = WhitelistData.whitelist or {}
        if not Whitelist[HWID] then
            SendWebhook("Not Whitelisted", "HWID not found in whitelist")
            failAuth("Not Whitelisted")
            return
        end
    end
    wait(0.8)
    
    updateStatus("Checking Expiry", Color3.fromRGB(255, 185, 65), 0.75)
    if Config.EnableExpire then
        local ExpireSuccess, ExpireData = pcall(function() return HttpService:JSONDecode(game:HttpGet(AuthAPI)) end)
        if not ExpireSuccess then
            failAuth("Connection Failed")
            return
        end
        if os.time() > ExpireData.expire then
            SendWebhook("Expired", "Script key has expired")
            failAuth("Script Expired")
            return
        end
    end
    wait(0.8)
    
    updateStatus("Loading Protections", Color3.fromRGB(65, 135, 255), 0.9)
    wait(0.8)
    
    updateStatus("Authorized", Color3.fromRGB(85, 205, 125), 1.0)
    SendWebhook("Authenticated")
    wait(1)
    
    local fadeOut = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    })
    
    TweenService:Create(OuterGlow, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Border, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
    
    for _, obj in pairs(Content:GetDescendants()) do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        end
    end
    
    local AuthKey = "Auth_" .. math.random(100000, 999999) .. "_" .. math.random(100000, 999999)
    getgenv().AuthKeyName = AuthKey

    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        Blur:Destroy()
        ScreenGui:Destroy()
        
        if not game:GetService("ReplicatedStorage"):FindFirstChild("ReplayModule7v7old") then
            game:GetService("Players").LocalPlayer:Kick("Unsupported server type. Please make sure you are in a 7v7 server, not a 4v4 server.")
            return
        end
        
        getgenv()[getgenv().AuthKeyName] = true
    end)
end)

repeat task.wait() until getgenv()[getgenv().AuthKeyName]
