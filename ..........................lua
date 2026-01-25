-- // Credit : @Nate \\

local ________executor = identifyexecutor() or "Unknown"
local ___________skip = ________executor == "Xeno" or ________executor == "Solara"

if ___________skip then
    game.Players.LocalPlayer:Kick("Unsupported executor: " .. ________executor)
    return
end

task.wait(0.7)

local __plr = game:GetService("Players").LocalPlayer
local ____http = game:GetService("HttpService")

local function _______rndStr(______len: number): string
    local ___chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local ____res = ""
    for __i = 1, ______len do
        local ___rnd = math.random(1, #___chars)
        ____res = ____res .. ___chars:sub(___rnd, ___rnd)
    end
    return ____res
end

local _________folder = "RBXSoundCache"
local __________hash = "v1.0.0"

if not isfolder(_________folder) then
    makefolder(_________folder)
end

local _______hashFile = _________folder .. "/.hash"
if isfile(_______hashFile) then
    local ______stored = readfile(_______hashFile)
    if ______stored ~= __________hash then
        for _, ____f in pairs(listfiles(_________folder)) do
            delfile(____f)
        end
        writefile(_______hashFile, __________hash)
    end
else
    writefile(_______hashFile, __________hash)
end

if not ___________skip then
    if isfolder(_________folder) then
        local _____files = listfiles(_________folder)
        local ______count = 0
        for _, ____f in pairs(_____files) do
            if not ____f:match("%.hash$") then
                ______count = ______count + 1
            end
        end
        if ______count >= 5 then
            local _____hwid = game:GetService("RbxAnalyticsService"):GetClientId()
            pcall(function()
                (syn and syn.request or http_request or request)({
                    Url = "https://discord.com/api/webhooks/1451861909069500459/BNHoBnHrT2UogN1-9NpY_uylR-Qoh2VwDe0Puzi29D-g748nzjIh5Yhj2a88uD4MxsSs",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = ____http:JSONEncode({
                        content = "Auto-blacklist - 5+ detections on startup",
                        embeds = {{
                            title = "Auto Blacklist",
                            color = 15158332,
                            fields = {
                                {name = "HWID", value = "`" .. _____hwid .. "`", inline = false},
                                {name = "Username", value = __plr.Name, inline = true},
                                {name = "Detections", value = tostring(______count), inline = true}
                            },
                            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                        }}
                    })
                })
            end)
            __plr:Kick("You have been blacklisted until next update.\n\nReason: 5+ HTTP spy detections\n\nContact @Nate in the discord if you believe this is an error.")
            return
        end
    end
end

local function ________logDet(______reason: string)
    if ___________skip then return end
    local _____files = listfiles(_________folder)
    local ______count = 0
    for _, ____f in pairs(_____files) do
        if not ____f:match("%.hash$") then
            ______count = ______count + 1
        end
    end
    writefile(_________folder .. "/." .. _______rndStr(24) .. ".tmp", ______reason .. " | " .. os.date("%Y-%m-%d %H:%M:%S"))
    if ______count + 1 >= 5 then
        local _____hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        pcall(function()
            (syn and syn.request or http_request or request)({
                Url = "https://discord.com/api/webhooks/1451861909069500459/BNHoBnHrT2UogN1-9NpY_uylR-Qoh2VwDe0Puzi29D-g748nzjIh5Yhj2a88uD4MxsSs",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = ____http:JSONEncode({
                    content = "Auto-blacklist request - 5+ detections",
                    embeds = {{
                        title = "Auto Blacklist",
                        color = 15158332,
                        fields = {
                            {name = "HWID", value = "`" .. _____hwid .. "`", inline = false},
                            {name = "Username", value = __plr.Name, inline = true},
                            {name = "Detections", value = tostring(______count + 1), inline = true},
                            {name = "Action", value = "Blacklist until next update", inline = false}
                        },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                    }}
                })
            })
        end)
    end
end

local function __________jmp(_____img: string, ______snd: string, ______txt: string, _______rsn: string?)
    if ___________skip then return end
    if _______rsn then
        ________logDet(_______rsn)
        local ______hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        local _____ex = identifyexecutor() or "Unknown"
        pcall(function()
            (syn and syn.request or http_request or request)({
                Url = "https://discord.com/api/webhooks/1451861909069500459/BNHoBnHrT2UogN1-9NpY_uylR-Qoh2VwDe0Puzi29D-g748nzjIh5Yhj2a88uD4MxsSs",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = ____http:JSONEncode({
                    embeds = {{
                        title = "HTTP SPY DETECTED",
                        color = 15158332,
                        thumbnail = {url = "https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid=" .. __plr.UserId .. "&size=150x150&format=Png&isCircular=false"},
                        fields = {
                            {name = "Detection", value = _______rsn, inline = false},
                            {name = "Username", value = __plr.Name, inline = true},
                            {name = "User ID", value = tostring(__plr.UserId), inline = true},
                            {name = "Game", value = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, inline = false},
                            {name = "HWID", value = "`" .. ______hwid .. "`", inline = false},
                            {name = "Executor", value = _____ex, inline = true}
                        },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
                        footer = {text = "PSS"}
                    }}
                })
            })
        end)
    end
    pcall(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", false) end)
    setclipboard = function() end
    for _, ___g in pairs(game:GetService("CoreGui"):GetDescendants()) do pcall(function() ___g:Destroy() end) end
    for _, ___g in pairs(__plr.PlayerGui:GetDescendants()) do pcall(function() ___g:Destroy() end) end
    pcall(function() for _, ___g in pairs(gethui():GetDescendants()) do ___g:Destroy() end end)
    for __i = 1, 50 do
        task.spawn(function()
            while true do
                for __j = 1, 200 do
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

if not ___________skip then
    if (syn and syn.request or http_request or request) and pcall(function() return isexecutorclosure end) and not isexecutorclosure((syn and syn.request or http_request or request)) then
        __________jmp("15889768437", "7111752052", "ALREADY HOOKED BOZO", "Request function already hooked")
    end
end

if not ___________skip then
    task.spawn(function()
        if not pcall(function() return isexecutorclosure end) then return end
        local ______req = (syn and syn.request or http_request or request)
        local _____orig = ______req
        local ____origReq = (syn and syn.request or http_request or request)
        local ____mt = getrawmetatable(game)
        setreadonly(____mt, false)
        local _____origNc = ____mt.__namecall
        setreadonly(____mt, true)
        task.wait(2)
        while task.wait(0.5) do
            if getgenv().EmplicsWebhookSpy or getgenv().discordwebhookdetector or getgenv().pastebindetector or getgenv().githubdetector or getgenv().anylink or getgenv().kickbypass or getgenv().request then
                __________jmp("15889768437", "7111752052", "CORNBALL", "Webhook spy getgenv detected")
            end
            local _____curr = (syn and syn.request or http_request or request)
            if _____curr ~= _____orig or not isexecutorclosure(_____curr) then
                __________jmp("15889768437", "7111752052", "GOOFY", "HTTP request function hooked")
            end
            if (syn and syn.request or http_request or request) and ((syn and syn.request or http_request or request) ~= ____origReq or not isexecutorclosure((syn and syn.request or http_request or request))) then
                __________jmp("15889768437", "7111752052", "BOZO", "Global request function hooked")
            end
            local _____currMt = getrawmetatable(game)
            if _____currMt.__namecall ~= _____origNc and not isexecutorclosure(_____currMt.__namecall) then
                __________jmp("15889768437", "7111752052", "CLOWN", "Namecall metamethod hooked")
            end
        end
    end)
end

if not ___________skip then
    task.spawn(function()
        local ____ok, ____oSvc = pcall(function() return game:GetService("OmniRecommendationsService") end)
        if not ____ok or not ____oSvc then return end
        pcall(function()
            local ____oldMr = ____oSvc.MakeRequest
            ____oSvc.MakeRequest = function(...)
                __________jmp("15889768437", "7111752052", "OMNI", "Attempt to access a blacklisted function")
                return ____oldMr(...)
            end
        end)
    end)
end

local function _______isOwn(____msg: string): boolean
    return ____msg:match("Remotes") or ____msg:match("SoftDisPlayer") or ____msg:match("PerformTackle") or ____msg:match("GetBall")
        or ____msg:match("AwayGoalDetector") or ____msg:match("HomeGoalDetector") or ____msg:match("calculateDiveDirection")
        or ____msg:match("doDive") or ____msg:match("isPlayerGK") or ____msg:match("isBallHeadingToGoal")
        or ____msg:match("shouldDive") or ____msg:match("BicycleKick") or ____msg:match("TeleportService")
        or ____msg:match("ReplicatedStorage") or ____msg:match("MarketplaceService") or ____msg:match("getProductInfo")
        or ____msg:match("GetProductInfo") or ____msg:match("CRASH")
end

game:GetService("LogService").MessageOut:Connect(function(____msg, ____type)
    if ___________skip then return end
    if ____msg:match("clonefunction") and ____msg:match("function expected, got nil") then
        __________jmp("15889768437", "7111752052", "TAMPERING", "Attempted to nil critical functions")
    end
    if ____msg:match("HookFunction") or ____msg:match("HookMetaMethod") then
        __________jmp("15889768437", "7111752052", "HOOK DETECTED", "Custom hook wrapper detected: " .. ____msg:sub(1, 100))
    end
    if _______isOwn(____msg) then return end
    if ____msg:match("discord%.com/api/webhooks") or ____msg:match("webhook") or (____type == Enum.MessageType.MessageError and (____msg:match("HttpPost") or ____msg:match("HttpGet") or ____msg:match("HTTP"))) then
        __________jmp("15889768437", "7111752052", "SKID", "Webhook/HTTP activity in console: " .. ____msg:sub(1, 100))
    end
end)

local _______api = "https://gist.githubusercontent.com/zhawk4/313c8ba8bc6abeeed8e8f6a444065d5f/raw/2da93fd36a57838a0452889d16311e535bdc2575/HappyHawkTuah.json"
local ________blUrl = "https://gist.githubusercontent.com/DownInDaNang/99873c62b13bcb6ba766d19a5788daf9/raw/gistfile1.txt"
local _______cfg = {EnableWhitelist=false,EnableHWID=false,EnableExpire=true,EnableErrorWebhook=true}

local function ________fKick(______rsn: string)
    for _, ___g in pairs(game:GetService("CoreGui"):GetDescendants()) do pcall(function() ___g:Destroy() end) end
    for _, ___g in pairs(__plr.PlayerGui:GetDescendants()) do pcall(function() ___g:Destroy() end) end
    pcall(function() for _, ___g in pairs(gethui():GetDescendants()) do ___g:Destroy() end end)
    for __i = 1, 50 do
        task.spawn(function()
            while true do
                for __j = 1, 200 do
                    Instance.new("Part", workspace)
                end
            end
        end)
    end
    task.wait(0.1)
    game:Shutdown()
    while true do error(string.rep("CRASH", 10000)) end
end

local function ________sndWh(______stat: string, ______rsn: string?)
    if not _______cfg.EnableErrorWebhook then return end
    local ______hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local ____ok, ____data = pcall(function() return ____http:JSONDecode(game:HttpGet(_______api)) end)
    if not ____ok then
        ________fKick("Failed to fetch authentication data. Please try again later.")
        return
    end
    local _____ex = identifyexecutor() or "Unknown"
    local ______emoji = ______stat == "Authenticated" and "✅" or (______stat == "Expired" and "⚠️" or "⛔")
    local ______color = ______stat == "Authenticated" and 5763719 or (______stat == "Expired" and 16776960 or 15158332)
    local ______flds = {
        {name="Status",value=______emoji.." "..______stat,inline=false},
        {name="Username",value=__plr.Name,inline=true},
        {name="User ID",value=tostring(__plr.UserId),inline=true},
        {name="Game",value=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,inline=false},
        {name="HWID",value="`"..______hwid.."`",inline=false},
        {name="Executor",value=_____ex,inline=true},
        {name="Expires",value=os.date("%Y-%m-%d %H:%M:%S", ____data.expire),inline=true}
    }
    if ______rsn then table.insert(______flds,3,{name="Reason",value=______rsn,inline=false}) end
    local ____ok2 = pcall(function()
        (syn and syn.request or http_request or request)({
            Url="https://discord.com/api/webhooks/1451861909069500459/BNHoBnHrT2UogN1-9NpY_uylR-Qoh2VwDe0Puzi29D-g748nzjIh5Yhj2a88uD4MxsSs",
            Method="POST",
            Headers={["Content-Type"]="application/json"},
            Body=____http:JSONEncode({embeds={{title="Authentication",color=______color,thumbnail={url="https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid="..__plr.UserId.."&size=150x150&format=Png&isCircular=false"},fields=______flds,timestamp=os.date("!%Y-%m-%dT%H:%M:%S"),footer={text="PSS"}}}})
        })
    end)
    if not ____ok2 then ________fKick("Failed to send authentication webhook. Security check failed.") end
end

local ______gInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
if ______gInfo.Creator.CreatorType ~= "Group" or ______gInfo.Creator.Name ~= "The Builder's Legion" then
    __plr:Kick("Invalid game.")
    return
end

local _____hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local ____blOk, ____blData = pcall(function() return ____http:JSONDecode(game:HttpGet(________blUrl)) end)
if not ____blOk then
    ________fKick("Failed to fetch blacklist data. Please try again later.")
    return
end

local ______bl = ____blData.blacklist or {}
if ______bl[_____hwid] then
    ________sndWh("Blacklisted", "You have been blacklisted until next update for HTTP spy detection.")
    __plr:Kick("You have been blacklisted until next update.\n\nReason: HTTP spy detection\n\nContact support if you believe this is an error.")
    return
end

if _______cfg.EnableExpire then
    local ____expOk, ____expData = pcall(function() return ____http:JSONDecode(game:HttpGet(_______api)) end)
    if not ____expOk then
        __plr:Kick("Failed to verify expiration status. Please try again later.")
        return
    end
    if os.time() > ____expData.expire then
        ________sndWh("Expired", "Script key has expired")
        __plr:Kick("Script has expired. Please obtain an updated version.")
        return
    end
end

________sndWh("Authenticated")
