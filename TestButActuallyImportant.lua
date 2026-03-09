if getgenv().PulseAuthLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Notice!",
        Text = "Script has already been executed.",
        Duration = 4
    })
    return
end
getgenv().PulseAuthLoaded = true

local ExecutorName: string = identifyexecutor() or "Unknown"

if ExecutorName == "Xeno" or ExecutorName == "Solara" then
    game:GetService("Players").LocalPlayer:Kick("Unsupported executor.\n\nXeno and Solara are not supported.\nPlease use a different executor.")
    return
end

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

local BS: {[string]: string} = {
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

local CacheFolder: string = "RBXSoundCache"
local ScriptHash: string = "v1.1.8"

local Method1: string = game:GetService("RbxAnalyticsService"):GetClientId()
local Service = game:GetService("RbxAnalyticsService")
local Method2: string = Service.GetClientId(Service)
local HWID: string = Method2

local function GenerateRandomString(Length: number): string
    local Characters: string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local Result: string = ""
    for Index = 1, Length do
        local RandomIndex: number = math.random(1, #Characters)
        Result = Result .. Characters:sub(RandomIndex, RandomIndex)
    end
    return Result
end

local function LogDetection(Reason: string)
    if not getgenv().AutoBlacklist then return end
    local Files = originalListfiles(CacheFolder)
    local DetectionCount: number = 0
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
    local Executor: string = identifyexecutor() or "Unknown"
    
    local WebhookTitle: string = "HTTP SPY DETECTED"
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

local spyPatterns: {string} = {
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

local HwidFunctions: {string} = {"gethwid", "getexecutorhwid", "get_hwid", "GetHWID"}
local OriginalHwidInfo: {[string]: any} = {}
local OriginalIdentify = identifyexecutor
local OriginalIdentifyInfo = pcall(originalDebug.getinfo, OriginalIdentify) and originalDebug.getinfo(OriginalIdentify) or {}

for _, funcName in pairs(HwidFunctions) do
    local func = getgenv()[funcName] or _G[funcName]
    if func then
        local success: boolean, info = pcall(originalDebug.getinfo, func)
        OriginalHwidInfo[funcName] = {
            func = func,
            info = success and info or {}
        }
    end
end

task.spawn(function()
    while task.wait(5) do
        local TestMethod1: string = game:GetService("RbxAnalyticsService"):GetClientId()
        local TestService = game:GetService("RbxAnalyticsService")
        local TestMethod2: string = TestService.GetClientId(TestService)
        
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

game:GetService("LogService").MessageOut:Connect(function(Message: string)
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
local allowedLink: string = "https://work.ink/2lzw/get-access-key"

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

local HashFile: string = CacheFolder .. "/.hash"
if originalIsfile(HashFile) then
    local StoredHash: string = originalReadfile(HashFile)
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
        local DetectionCount: number = 0
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

local RanTimes: number = 0
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
    local chars: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local key: string = ""
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

local HoneypotTraps: {[string]: () -> ()} = {}
for i = 1, 25 do
    local trapName: string = "_secure_" .. GenerateTrapKey() .. "_" .. i
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
        local blockedKeys: {string} = {
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

local ScriptFingerprint: {[string]: string} = {}
local HandshakeKey: string = "HANDSHAKE_" .. math.random(100000, 999999)

local ValidationData = {
    expectedFunctions = {"getgc", "debug", "getreg"},
    protectionCount = 6,
    scriptLines = originalDebug.getinfo(1, "l").currentline,
    memorySignature = tostring(getfenv()):sub(-8)
}

local function generateHandshake(): string
    local state: string = ""
    for _, name in pairs(ValidationData.expectedFunctions) do
        state = state .. tostring(_G[name] ~= nil)
    end
    return state .. ValidationData.memorySignature
end

ScriptFingerprint[HandshakeKey] = generateHandshake()

task.spawn(function()
    while task.wait(30) do
        local currentHandshake: string = generateHandshake()
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
        
        local TestMethod1: string = game:GetService("RbxAnalyticsService"):GetClientId()
        local TestService = game:GetService("RbxAnalyticsService")
        local TestMethod2: string = TestService.GetClientId(TestService)
        if TestMethod1 ~= TestMethod2 then
            CrashClient("HWID spoofing detected")
        end
    end
end)

if not game:GetService("ReplicatedStorage"):FindFirstChild("ReplayModule7v7old") then
    game:GetService("Players").LocalPlayer:Kick("Unsupported server type. Please make sure you are in a 7v7 server, not a 4v4 server.")
    return
end
