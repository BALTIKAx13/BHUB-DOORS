local Services = setmetatable({}, {
    __index = function(self, Name)
        if Abysall.Environment and Abysall.Environment.cloneref then
            return Abysall.Environment.cloneref(game:GetService(Name))
        else
            return game:GetService(Name)
        end
    end
})

local Bindable = Instance.new("BindableFunction")
Bindable.OnInvoke = function()
    pcall(function()
        toclipboard("https://discord.gg/dt5PhHhNX")
    end)
end

Services.StarterGui:SetCore("SendNotification", {
    Title = "BHUB DOORS",
    Text = "Only DOORS is supported right now.",
    Duration = 10,
    Button1 = "Copy Discord Invite",
    Callback = Bindable,
})
