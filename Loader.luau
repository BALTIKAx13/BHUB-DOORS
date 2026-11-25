if getgenv().Abysall then
    return
end
getgenv().Abysall = {
    Legit = true
}

local BaseUrl = "https://raw.githubusercontent.com/BALTIKAx13/BHUB-DOORS/main/"

local GameList = {
    [2440500124] = "Doors"
}

local Abysall = getgenv().Abysall
Abysall.Environment = loadstring(game:HttpGet(BaseUrl .. "Components/Environment.luau"))()
Abysall.ESPLibrary = loadstring(game:HttpGet(BaseUrl .. "Components/ESP.luau"))()

local function CloneReference(Object)
    if Abysall and Abysall.Environment.cloneref then
        return Abysall.Environment.cloneref(Object)
    end
    return Object
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

if Abysall.Environment.writefile and Abysall.Environment.readfile then
    if not Abysall.Environment.isfile("BHUB/UserData.json") then
        Abysall.Environment.writefile("BHUB/UserData.json", Services.HttpService:JSONEncode({
            TotalExecutions = 0,
            UILibrary = "BHUB"
        }))
    end

    local ok, Decoded = pcall(function()
        return Services.HttpService:JSONDecode(Abysall.Environment.readfile("BHUB/UserData.json"))
    end)
    if ok and type(Decoded) == "table" then
        Decoded.TotalExecutions = (tonumber(Decoded.TotalExecutions) or 0) + 1
        Decoded.UILibrary = "BHUB"
        Abysall.TotalExecutions = Decoded.TotalExecutions
        Abysall.UILibrary = Decoded.UILibrary
        Abysall.Environment.writefile("BHUB/UserData.json", Services.HttpService:JSONEncode(Decoded))
    end
end

Abysall.Interface = loadstring(game:HttpGet(BaseUrl .. "Components/Interface.luau"))()

local CurrentGame = GameList[game.GameId]
if CurrentGame then
    loadstring(game:HttpGet(BaseUrl .. "Games/" .. CurrentGame .. "/Loader.luau"))()
else
    loadstring(game:HttpGet(BaseUrl .. "Games/Universal/Loader.luau"))()
end
