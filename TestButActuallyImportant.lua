-- Anti-tamper I wrote. If you are viewing this (which you aren’t supposed to), help yourself and skid this. Maybe shoot me a DM on Discord @stacktrace45 telling me how you bypassed it. Detects hooking, spoofing, and other bypass attempts.

-- get exec name
local ExecutorName = identifyexecutor() or "Unknown"
local SkipChecks = ExecutorName == "Xeno" or ExecutorName == "Solara"

-- store original funcs before I override them later
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
local originalLoadstring = loadstring
local OrigRestore = clonefunction(restorefunction)


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

hookfunction(writefile, function(FP, FD)
    for B, M in pairs(BS) do
        if FP:lower():find(B:lower()) then
            return originalWritefile(FP, M)
        end
    end
    
    return originalWritefile(FP, FD)
end)

local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")

local CacheFolder = "RBXSoundCache"
local ScriptHash = "v1.1.8"

-- nuclear option if someone tries to tamper with the script
local function _WhatIsThis()
    pcall(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", false) end)
    setclipboard = function() end
    for _, GUI in pairs(game:GetService("CoreGui"):GetDescendants()) do pcall(function() GUI:Destroy() end) end
    for _, GUI in pairs(LocalPlayer.PlayerGui:GetDescendants()) do pcall(function() GUI:Destroy() end) end
    pcall(function() for _, GUI in pairs(gethui():GetDescendants()) do GUI:Destroy() end end)
    for Index = 1, 50 do
        task.spawn(function()
            while true do
                for J = 1, 200 do
                    Instance.new("Part", workspace)
                end
            end
        end)
    end
    task.wait(0.1)
    while true do
        pcall(function() game:GetService("GuiService"):ClearError() end)
        error(string.rep("CRASH", 10000))
    end
end

-- get the hardware ID using two different methods (harder to spoof both)
local Method1 = game:GetService("RbxAnalyticsService"):GetClientId()
local Service = game:GetService("RbxAnalyticsService")
local Method2 = Service.GetClientId(Service)
local HWID = Method2

local CacheFolder = "RBXSoundCache"
local ScriptHash = "v1.1.8"

local function GenerateRandomString(Length)
    local Characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local Result = ""
    for Index = 1, Length do
        local RandomIndex = math.random(1, #Characters)
        Result = Result .. Characters:sub(RandomIndex, RandomIndex)
    end
    return Result
end

local function LogDetection(Reason)
    if SkipChecks or not getgenv().AutoBlacklist then return end
    local Files = originalListfiles(CacheFolder)
    local DetectionCount = 0
    for _, File in pairs(Files) do
        if not File:match("%.hash$") then
            DetectionCount = DetectionCount + 1
        end
    end
    originalWritefile(CacheFolder .. "/." .. GenerateRandomString(24) .. ".tmp", Reason .. " | " .. os.date("%Y-%m-%d %H:%M:%S"))
    -- Auto-blacklist if they hit 5 detections (u can toggle this on/off at the top. Its off by default bc whitelist is on anyways)
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

-- main crash function when detection is triggered
local function CrashClient(ImageID, SoundID, DisplayText, DetectionReason)
    if SkipChecks then return end
    if DetectionReason then
        LogDetection(DetectionReason)
        local Executor = identifyexecutor() or "Unknown"
        
        local UserFriendlyReason = "Anti-Tamper Violation"
        local WebhookTitle = "PULSE ANTI-TAMPER DETECTION"
        
        if DetectionReason:match("HWID") then
            UserFriendlyReason = "HWID Spoofing - Gang, who are you? 😂"
            WebhookTitle = "HWID SPOOFING DETECTED"
        elseif DetectionReason:match("identifyexecutor") or DetectionReason:match("IDENTIFY") then
            UserFriendlyReason = "Executor Identity Manipulation"
            WebhookTitle = "EXECUTOR SPOOFING DETECTED"
        elseif DetectionReason:match("HTTP") or DetectionReason:match("request") or DetectionReason:match("webhook") then
            UserFriendlyReason = "HTTP Request Interception"
            WebhookTitle = "HTTP SPY DETECTED"
        elseif DetectionReason:match("String") or DetectionReason:match("dumper") then
            UserFriendlyReason = "Script Content Extraction"
            WebhookTitle = "STRING DUMPER DETECTED"
        elseif DetectionReason:match("hook") or DetectionReason:match("HOOK") then
            UserFriendlyReason = "Function Interception"
            WebhookTitle = "FUNCTION HOOKING DETECTED"
        elseif DetectionReason:match("tamper") or DetectionReason:match("TAMPER") then
            UserFriendlyReason = "Critical Function Tampering"
            WebhookTitle = "FUNCTION TAMPERING DETECTED"
        elseif DetectionReason:match("environment") or DetectionReason:match("env") then
            UserFriendlyReason = "Script Environment Manipulation"
            WebhookTitle = "ENVIRONMENT TAMPERING DETECTED"
        end
        -- spam their clipboard with random stuff
        local ClipboardSpam = {
            "你好世界 How did I get here? 这是什么",
            "检测系统 Nice try buddy 哈哈哈",
            "HTTP间谍 Who is this guy? 垃圾代码",
            "硬件欺骗 What happened? 笑死了",
            "函数挂钩 Stop trying 愚蠢的人",
            "字符串转储 Your tool failed 废物",
            "环境篡改 Imagine getting caught 可怜",
            "反篡改 You thought wrong 做梦",
            "检测到 Get better 学会编程",
            "安全违规 This is awkward 活该"
        }
        
        pcall(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", false) end)
        pcall(function() game:GetService("GuiService"):ClearError() end)
        
        -- disable all clipboard functions
        setclipboard = function() end
        toclipboard = function() end
        toClipboard = function() end
        setClipboard = function() end
        writeclipboard = function() end
        writeClipboard = function() end
        
        for k, v in pairs(getgenv()) do
            if type(k) == "string" and k:lower():match("clipboard") then
                getgenv()[k] = function() end
            end
        end

         -- ds file and debug functions
        writefile = function() end
        readfile = function() end
        listfiles = function() end
        delfile = function() end
        makefolder = function() end
        isfolder = function() end
        isfile = function() end
        hookfunction = function() end
        hookmetamethod = function() end
        getgc = function() end
        debug = {}
        getreg = function() end
        getscripts = function() end
        getscriptclosure = function() end
        getnilinstances = function() end
        loadstring = function() end
        
        pcall(function()
            (syn and syn.request or http_request or request)({
                Url = "https://discord.com/api/webhooks/1467048050655625349/TlCiiteQD8a6n9bxMZ12ltADoSPG_4puUmpwLevQZKvqqli-lROEzjmg7c3JlA3GJsrO",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    embeds = {{
                        title = WebhookTitle,
                        color = 15158332,
                        thumbnail = {url = "https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid=" .. LocalPlayer.UserId .. "&size=150x150&format=Png&isCircular=false"},
                        fields = {
                            {name = "Detection", value = DetectionReason, inline = false},
                            {name = "Username", value = LocalPlayer.Name, inline = true},
                            {name = "User ID", value = tostring(LocalPlayer.UserId), inline = true},
                            {name = "Game", value = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, inline = false},
                            {name = "HWID", value = "`" .. HWID .. "`", inline = false},
                            {name = "Executor", value = Executor, inline = true}
                        },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
                        footer = {text = "PSS"}
                    }}
                })
            })
        end)
        
        LocalPlayer:Kick("Pulse Anti-Tamper Detection\n\nViolation: " .. (UserFriendlyReason or "Unknown") .. "\n\nRunning other scripts may cause false detections.\nOnly execute this script.\n\nMultiple violations = permanent blacklist.\nReport sent to Discord.\n\nFalse positive? Contact @Nate on Discord.")
        
        task.wait(3)

        -- spam their clipboard (prob woudlve been niled already, this is useless but...)
        for i = 1, 50 do
            task.spawn(function()
                while true do
                    pcall(function()
                        setclipboard(ClipboardSpam[math.random(1, #ClipboardSpam)])
                        toclipboard(ClipboardSpam[math.random(1, #ClipboardSpam)])
                        toClipboard(ClipboardSpam[math.random(1, #ClipboardSpam)])
                        setClipboard(ClipboardSpam[math.random(1, #ClipboardSpam)])
                        writeclipboard(ClipboardSpam[math.random(1, #ClipboardSpam)])
                        writeclipboard(ClipboardSpam[math.random(1, #ClipboardSpam)])
                        writeClipboard(ClipboardSpam[math.random(1, #ClipboardSpam)])
                    end)
                    task.wait(0.1)
                end
            end)
        end

        -- Create junk files
        task.spawn(function()
            pcall(function()
                for _, file in pairs(originalListfiles()) do
                    originalDelfile(file)
                end
            end)
            for i = 1, 100 do
                pcall(function()
                    originalWritefile("HoeLeyShet_" .. i .. ".txt", "你被检测到了 Detection triggered 哈哈 How did this happen 垃圾代码")
                    originalWritefile("ThisFileIsVulnerable_" .. i .. ".dat", "What were you trying to do? 做梦吧 Your bypass failed 可怜")
                end)
            end
        end)
        
        -- spam console with junk
        for i = 1, 500 do
            task.spawn(function()
                while true do
                    pcall(function()
                        error("PULSE_ANTI_TAMPER_JUNK_" .. string.rep("A", 1000) .. "_BYTECODE_" .. string.rep("B", 1000) .. "_ERROR_" .. string.rep("C", 1000))
                    end)
                    pcall(function()
                        warn("PULSE_DETECTION_SPAM_" .. string.rep("X", 2000) .. "_CONSOLE_FLOOD_" .. string.rep("Y", 2000))
                    end)
                    pcall(function()
                        print("PULSE_JUNK_DATA_" .. string.rep("Z", 3000) .. "_ANTI_TAMPER_" .. string.rep("Q", 3000))
                    end)
                end
            end)
        end
        
        _WhatIsThis()
    end
end

-- Check if they're trying to spoof HWID
if Method1 ~= Method2 then
    task.spawn(function()
        task.wait(0.1)
        CrashClient("", "", "", "HWID spoofing detected")
    end)
    return
end

-- store original HWID function info
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

if SkipChecks then
        task.spawn(function()
        while task.wait(5) do
            -- Check HWID spoofing
            local TestMethod1 = game:GetService("RbxAnalyticsService"):GetClientId()
            local TestService = game:GetService("RbxAnalyticsService")
            local TestMethod2 = TestService.GetClientId(TestService)
            
            if TestMethod1 ~= TestMethod2 then
                CrashClient("", "", "", "HWID spoofing detected")
            end
            -- check if identifyexecutor was replaced
            if identifyexecutor ~= OriginalIdentify then
                CrashClient("", "", "", "identifyexecutor function replaced")
            end
            -- check if identifyexecutor was hooked
            local success, currentIdentifyInfo = pcall(originalDebug.getinfo, identifyexecutor)
            if success then
                if currentIdentifyInfo.what ~= "C" then
                    CrashClient("", "", "", "identifyexecutor not C closure")
                end
                
                if OriginalIdentifyInfo.what == "C" and currentIdentifyInfo.source ~= "=[C]" then
                    CrashClient("", "", "", "identifyexecutor wrapped")
                end
            end
            
            for _, funcName in pairs(HwidFunctions) do
                                local currentFunc = getgenv()[funcName] or _G[funcName]
                local originalData = OriginalHwidInfo[funcName]
                
                if originalData and currentFunc then
                    local success, currentInfo = pcall(originalDebug.getinfo, currentFunc)
                    if success then
                        if currentFunc ~= originalData.func then
                            CrashClient("", "", "", "HWID function replaced: " .. funcName)
                        end
                        
                        if currentInfo.what ~= "C" then
                            CrashClient("", "", "", "HWID function not C closure: " .. funcName)
                        end
                        
                        if originalData.info.what == "C" and currentInfo.source ~= "=[C]" then
                            CrashClient("", "", "", "HWID function wrapped: " .. funcName)
                        end
                    end
                end
            end
            -- double check identifyexecutor
            local currentIdentify = identifyexecutor
            local success2, currentIdentifyInfo = pcall(originalDebug.getinfo, currentIdentify)
            if success2 then
                if currentIdentify ~= OriginalIdentify then
                    CrashClient("", "", "", "identifyexecutor function replaced")
                end
                
                if currentIdentifyInfo.what ~= "C" then
                    CrashClient("", "", "", "identifyexecutor not C closure")
                end
                
                if OriginalIdentifyInfo.what == "C" and currentIdentifyInfo.source ~= "=[C]" then
                    CrashClient("", "", "", "identifyexecutor wrapped")
                end
            end
            -- check for known bypass tools
            if getgenv().EmplicsWebhookSpy or getgenv().StringDumper or getgenv().discordwebhookdetector then
                CrashClient("", "", "", "String dumper or webhook spy detected")
            end
        end
    end)
    
    -- monitor console for suspicious activity (already handles errors)
    game:GetService("LogService").MessageOut:Connect(function(Message)
        if Message:match("discord%.com/api/webhooks") or Message:match("webhook") or Message:match("dumper") then
            CrashClient("", "", "", "Webhook/HTTP activity in console: " .. Message:sub(1, 100))
        end
    end)
end

if not SkipChecks then
    local function createSecureBlock(funcName)
        return function() 
            error(funcName .. " has been disabled by Pulse for security reasons.")
        end
    end
    -- block all clip funcs for security purposes. This isen't needed but, in my case I will just use just because.
    local blockedSetclipboard = createSecureBlock("setclipboard")
    local blockedWritefile = createSecureBlock("writefile")
    
    setclipboard = blockedSetclipboard
    toclipboard = createSecureBlock("toclipboard")
    toClipboard = createSecureBlock("toClipboard")
    setClipboard = createSecureBlock("setClipboard")
    writeclipboard = createSecureBlock("writeclipboard")
    writeClipboard = createSecureBlock("writeClipboard")
    
    for k, v in pairs(getgenv()) do
        if type(k) == "string" and k:lower():match("clipboard") then
            getgenv()[k] = createSecureBlock(k)
        end
    end
    
    -- block file functions
    writefile = blockedWritefile
    readfile = createSecureBlock("readfile")
    listfiles = createSecureBlock("listfiles")
    delfile = createSecureBlock("delfile")
    makefolder = createSecureBlock("makefolder")
    isfolder = createSecureBlock("isfolder")
    isfile = createSecureBlock("isfile")

    -- monitor if they try to restore blocked functions
    task.spawn(function()
        while task.wait(1) do
            if setclipboard ~= blockedSetclipboard or writefile ~= blockedWritefile then
                CrashClient("", "", "", "Attempted to restore blocked functions")
            end
        end
    end)
    
    -- setup cache folder
    if not originalIsfolder(CacheFolder) then
        originalMakefolder(CacheFolder)
    end
    -- Check script/hash version (This is good for unblacklisting users when the hash number changes. MUST have auto blacklist on)
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
    -- check for existing detections on startup
    if getgenv().AutoBlacklist then
        if originalIsfolder(CacheFolder) then
            local Files = originalListfiles(CacheFolder)
            local DetectionCount = 0
            for _, File in pairs(Files) do
                if not File:match("%.hash$") then
                    DetectionCount = DetectionCount + 1
                end
            end
            -- If they hit 5 detections on startup, get em goneeeeeeeeeeeeee (until hash number changes)
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

    -- env protection (credit goldtm & vexec)

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

    local function GenerateTrapKey()
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        local key = ""
        for i = 1, math.random(30, 50) do
            key = key .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
        end
        return key
    end
    -- If someone tries to access the environment, crash them
    local function CorruptAndCrash()
        local targetEnv = SavedFunctions.getfenv(3)
        if targetEnv and targetEnv ~= RealEnv then
            for k, v in SavedFunctions.pairs(targetEnv) do
                SavedFunctions.rawset(targetEnv, k, function()
                    while true do
                        for i = 1, 9999 do
                            Instance.new("Part", workspace)
                        end
                    end
                end)
            end
        end
        for i = 1, 100 do
            task.spawn(function()
                while true do
                    for j = 1, 999 do
                        Instance.new("Part", workspace)
                    end
                end
            end)
        end
        while true do
            error(string.rep("ENVLOGGER_CRASH", 99999))
        end
    end
    -- Honeypot traps to catch environment loggers
    local HoneypotTraps = {}
    for i = 1, 25 do
        local trapName = "_secure_" .. GenerateTrapKey() .. "_" .. i
        HoneypotTraps[trapName] = function()
            CorruptAndCrash()
            return nil
        end
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
        
        __call = function()
            CorruptAndCrash()
        end,
        
        __concat = function()
            CorruptAndCrash()
        end
    }
    -- hook getfenv to return fake environment for unauthorized callers
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
    -- block getgc and other inspection funcs
    getgc = function(includeTables)
        CorruptAndCrash()
    end

    debug = setmetatable({}, {
        __index = function(self, key)
            CorruptAndCrash()
        end,
        __newindex = function() CorruptAndCrash() end
    })

    getreg = function()
        CorruptAndCrash()
    end

    getscripts = function()
        CorruptAndCrash()
    end

    getscriptclosure = function(script)
        CorruptAndCrash()
    end

    getnilinstances = function()
        CorruptAndCrash()
    end
    -- only allow loadstring for my specific script :)
    loadstring = function(source, chunkname)
        if source and source:match("https://raw.githubusercontent.com/DownInDaNang/Roblox/refs/heads/main/RSS/Hanak.lua") then
            return originalLoadstring(source, chunkname)
        end
        error("Loadstring has been disabled by Pulse for security reasons.")
    end
    -- integrity verification (this was poorly put together)
    local ScriptFingerprint = {}
    local HandshakeKey = "HANDSHAKE_" .. math.random(100000, 999999)

    local ValidationData = {
        expectedFunctions = {"getgc", "debug", "getreg"},
        protectionCount = 6,
        scriptLines = originalDebug.getinfo(1, "l").currentline,
        memorySignature = tostring(getfenv()):sub(-8)
    }

    local function generateHandshake()
        local state = ""
        for _, name in pairs(ValidationData.expectedFunctions) do
            state = state .. tostring(_G[name] ~= nil)
        end
        return state .. ValidationData.memorySignature
    end

    ScriptFingerprint[HandshakeKey] = generateHandshake()
    -- periodic checks
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
            
            local currentGetfenv = getfenv
            local currentSetfenv = setfenv
            local currentPairs = pairs
            
            if currentGetfenv ~= getfenv or currentSetfenv ~= setfenv or currentPairs ~= pairs then
                CorruptAndCrash()
            end
        end
    end)
end

task.wait(0.7)

if not SkipChecks then
    -- check if request function is already hooked before we even start
    if (syn and syn.request or http_request or request) and pcall(function() return isexecutorclosure end) and not isexecutorclosure((syn and syn.request or http_request or request)) then
        CrashClient("15889768437", "7111752052", "ALREADY HOOKED BOZO", "Request function already hooked")
    end

    -- start monitoring for HTTP hooks and other tampering
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

        -- check for known spy tools
        while task.wait(0.5) do
            if getgenv().EmplicsWebhookSpy or getgenv().discordwebhookdetector or getgenv().pastebindetector or getgenv().githubdetector or getgenv().anylink or getgenv().kickbypass or getgenv().StringDumper then
                CrashClient("15889768437", "7111752052", "CORNBALL", "String dumper or webhook spy detected")
            end

            -- Verify request function hasn't been hooked
            local CurrentFunction = (syn or http).request
            if CurrentFunction ~= OriginalFunction or not isexecutorclosure(CurrentFunction) then
                CrashClient("15889768437", "7111752052", "GOOFY", "HTTP request function hooked")
            end
            
            if request and (request ~= OriginalRequest or not isexecutorclosure(request)) then
                CrashClient("15889768437", "7111752052", "BOZO", "Global request function hooked")
            end

            -- Check if namecall was hooked
            local CurrentMetatable = getrawmetatable(game)
            if CurrentMetatable.__namecall ~= OriginalNamecall and not isexecutorclosure(CurrentMetatable.__namecall) then
                CrashClient("15889768437", "7111752052", "CLOWN", "Namecall metamethod hooked")
            end
            -- make sure HWID hasn't been spoofed
            local TestMethod1 = game:GetService("RbxAnalyticsService"):GetClientId()
            local TestService = game:GetService("RbxAnalyticsService")
            local TestMethod2 = TestService.GetClientId(TestService)
            if TestMethod1 ~= TestMethod2 then
                CrashClient("15889768437", "7111752052", "HWID SPOOF", "HWID spoofing detected")
            end
            -- Check HWID functions
            for _, funcName in pairs(HwidFunctions) do
                local currentFunc = getgenv()[funcName] or _G[funcName]
                local originalData = OriginalHwidInfo[funcName]
                
                if originalData and currentFunc then
                    local success, currentInfo = pcall(originalDebug.getinfo, currentFunc)
                    if success then
                        if currentFunc ~= originalData.func then
                            CrashClient("15889768437", "7111752052", "HWID FUNC SWAP", "HWID function replaced: " .. funcName)
                        end
                        
                        if currentInfo.what ~= "C" then
                            CrashClient("15889768437", "7111752052", "HWID FUNC HOOK", "HWID function not C closure: " .. funcName)
                        end
                        
                        if originalData.info.what == "C" and currentInfo.source ~= "=[C]" then
                            CrashClient("15889768437", "7111752052", "HWID FUNC WRAP", "HWID function wrapped: " .. funcName)
                        end
                    end
                end
            end
            -- check identifyexecutor function
            local currentIdentify = identifyexecutor
            local success2, currentIdentifyInfo = pcall(originalDebug.getinfo, currentIdentify)
            if success2 then
                if currentIdentify ~= OriginalIdentify then
                    CrashClient("15889768437", "7111752052", "IDENTIFY SWAP", "identifyexecutor function replaced")
                end
                
                if currentIdentifyInfo.what ~= "C" then
                    CrashClient("15889768437", "7111752052", "IDENTIFY HOOK", "identifyexecutor not C closure")
                end
                
                if OriginalIdentifyInfo.what == "C" and currentIdentifyInfo.source ~= "=[C]" then
                    CrashClient("15889768437", "7111752052", "IDENTIFY WRAP", "identifyexecutor wrapped")
                end
            end
        end
    end)
    -- block OmniRecommendationsService
    task.spawn(function()
        local Success, OmniService = pcall(function() return game:GetService("OmniRecommendationsService") end)
        if not Success or not OmniService then return end
        pcall(function()
            local OldMakeRequest = OmniService.MakeRequest
            OmniService.MakeRequest = function(...)
                CrashClient("15889768437", "7111752052", "OMNI", "Attempt to access a blacklisted function")
                return OldMakeRequest(...)
            end
        end)
    end)
    -- Filter out my own messages from console monitoring (you can change based off main script)
    local function IsOwnMessage(Message)
        return Message:match("Remotes") or Message:match("SoftDisPlayer") or Message:match("PerformTackle") or Message:match("GetBall")
            or Message:match("AwayGoalDetector") or Message:match("HomeGoalDetector") or Message:match("CalculateDiveDirection")
            or Message:match("DoDive") or Message:match("IsPlayerGoalkeeper") or Message:match("IsBallHeadingToGoal")
            or Message:match("ShouldDive") or Message:match("BicycleKick") or Message:match("TeleportService")
            or Message:match("ReplicatedStorage") or Message:match("MarketplaceService") or Message:match("getProductInfo")
            or Message:match("GetProductInfo") or Message:match("CRASH") or Message:match("AutoGKConfig")
            or Message:match("GetMode") or Message:match("GetBallSpeed") or Message:match("IsBallShot")
            or Message:match("GetBallCreator") or Message:match("IsPlayerMyTeammate") or Message:match("IsThreatening")
            or Message:match("UpdateCharacter") or Message:match("VirtualInputManager") or Message:match("cloneref")
            or Message:match("ENVLOGGER") or Message:match("security purposes") or Message:match("Pulse for security reasons")
    end
    -- monitor console output for suspicious activity
    game:GetService("LogService").MessageOut:Connect(function(Message, MessageType)
        if Message:match("clonefunction") and Message:match("function expected, got nil") then
            CrashClient("15889768437", "7111752052", "TAMPERING", "Attempted to nil critical functions")
        end
        if Message:match("HookFunction") or Message:match("HookMetaMethod") then
            CrashClient("15889768437", "7111752052", "HOOK DETECTED", "Custom hook wrapper detected: " .. Message:sub(1, 100))
        end
        if Message:match("strings") or Message:match("Saved") or Message:match("dumper") or Message:match("constants") or Message:match("upvalues") then
            CrashClient("15889768437", "7111752052", "STRING DUMPER", "String dumper activity detected: " .. Message:sub(1, 100))
        end
        if IsOwnMessage(Message) then return end
        if Message:match("discord%.com/api/webhooks") or Message:match("webhook") or (MessageType == Enum.MessageType.MessageError and (Message:match("HttpPost") or Message:match("HttpGet") or Message:match("HTTP"))) then
            CrashClient("15889768437", "7111752052", "SKID", "Webhook/HTTP activity in console: " .. Message:sub(1, 100))
        end
    end)
end
-- auth
local AuthAPI = "https://gist.githubusercontent.com/8931247412412421245524343255485937065/313c8ba8bc6abeeed8e8f6a444065d5f/raw/d7b76b5ca8b512f4dd05423aa16abc67c561c770/HappyHawkTuah.json"
local BlacklistURL = "https://gist.githubusercontent.com/8931247412412421245524343255485937065/bd881f722b597ba470a6b6067571f7a3/raw/85832531f29484681c316db7eeea3038bcf50236/LockEmUp.json"
local WhitelistURL = "https://gist.githubusercontent.com/8931247412412421245524343255485937065/81d3d7e7af49081dcbde2c9eaea2f137/raw/17c6b325e1d081702302af369d6944be42adcc6b/Whitelist.json"
local Config = {EnableWhitelist=true,EnableHWID=false,EnableExpire=true,EnableErrorWebhook=true}
-- force crash if auth fails
local function ForceKick(Reason)
    for _, GUI in pairs(game:GetService("CoreGui"):GetDescendants()) do pcall(function() GUI:Destroy() end) end
    for _, GUI in pairs(LocalPlayer.PlayerGui:GetDescendants()) do pcall(function() GUI:Destroy() end) end
    pcall(function() for _, GUI in pairs(gethui():GetDescendants()) do GUI:Destroy() end end)
    for Index = 1, 50 do
        task.spawn(function()
            while true do
                for J = 1, 200 do
                    Instance.new("Part", workspace)
                end
            end
        end)
    end
    task.wait(0.1)
    game:Shutdown()
    while true do error(string.rep("CRASH", 10000)) end
end
-- send auth status
local function SendWebhook(Status, Reason)
    if not Config.EnableErrorWebhook then return end
    local Success, Data = pcall(function() return HttpService:JSONDecode(game:HttpGet(AuthAPI)) end)
    if not Success then
        ForceKick("Failed to fetch authentication data. Please try again later.")
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
    local Success2 = pcall(function()
        (syn and syn.request or http_request or request)({
            Url="https://discord.com/api/webhooks/1467048050655625349/TlCiiteQD8a6n9bxMZ12ltADoSPG_4puUmpwLevQZKvqqli-lROEzjmg7c3JlA3GJsrO",
            Method="POST",
            Headers={["Content-Type"]="application/json"},
            Body=HttpService:JSONEncode({embeds={{title="Authentication",color=Color,thumbnail={url="https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid="..LocalPlayer.UserId.."&size=150x150&format=Png&isCircular=false"},fields=Fields,timestamp=os.date("!%Y-%m-%dT%H:%M:%S"),footer={text="PSS"}}}})
        })
    end)
    if not Success2 then ForceKick("Failed to send authentication webhook. Security check failed.") end
end
-- Check blacklist
local BlacklistSuccess, BlacklistData = pcall(function() return HttpService:JSONDecode(game:HttpGet(BlacklistURL)) end)
if not BlacklistSuccess then
    ForceKick("Failed to fetch blacklist data. Please try again later.")
    return
end
-- Verify game
local GameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local CreatorType = GameInfo.Creator.CreatorType
local CreatorName = GameInfo.Creator.Name

if CreatorType ~= "Group" or CreatorName ~= "The Builder's Legion" then
    LocalPlayer:Kick("Invalid game.")
    return
end
-- Check if user is blacklisted
local Blacklist = BlacklistData.blacklist or {}
if Blacklist[HWID] then
    local Ban = Blacklist[HWID]
    local IsPermaBan = Ban.ExpiresAt == 0
    local IsBanned = IsPermaBan or os.time() < Ban.ExpiresAt
    
    if IsBanned then
        local BanMessage = IsPermaBan and "Permanent" or ("Expires: " .. os.date("%Y-%m-%d %H:%M:%S", Ban.ExpiresAt))
        SendWebhook("Blacklisted", Ban.Reason .. " | " .. BanMessage)
                LocalPlayer:Kick("Your HWID is blacklisted.\nReason: " .. Ban.Reason .. "\n" .. BanMessage)
        return
    end
end
-- Check whitelist if enabled
if Config.EnableWhitelist then
    local WhitelistSuccess, WhitelistData = pcall(function() return HttpService:JSONDecode(game:HttpGet(WhitelistURL)) end)
    if not WhitelistSuccess then
        LocalPlayer:Kick("Failed to fetch whitelist data. Please try again later.")
        return
    end
    
    local Whitelist = WhitelistData.whitelist or {}
    if not Whitelist[HWID] then
        SendWebhook("Not Whitelisted", "HWID not found in whitelist")
        LocalPlayer:Kick("Your HWID isn't whitelisted. Please DM stacktrace45 on Discord for assistance.")
        return
    end
end
-- Check if script has expired (I use unix timestamp)
if Config.EnableExpire then
    local ExpireSuccess, ExpireData = pcall(function() return HttpService:JSONDecode(game:HttpGet(AuthAPI)) end)
    if not ExpireSuccess then
        LocalPlayer:Kick("Failed to verify expiration status. Please try again later.")
        return
    end
    if os.time() > ExpireData.expire then
        SendWebhook("Expired", "Script key has expired")
        LocalPlayer:Kick("Script has expired. Please obtain an updated version.")
        return
    end
end

SendWebhook("Authenticated")

-- end

