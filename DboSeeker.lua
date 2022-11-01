setDefaultTab("Main")
UI.Separator()

local PlayerStorage = {}
local Toogle = false

toogleButton = UI.Button("Toogle Seeker: False", function()
    Toogle = not Toogle
    toogleButton:setText("Toogle Seeker: "..tostring(Toogle))  
    toogleButton:setColor(Toogle and "green" or "red")
end)

addLabel("urltext", "URL: ")
addTextEdit("URL", storage.Url or "", function(widget, text) 
    storage.Url = text
end)

addLabel("tokentext", "Token: ")
addTextEdit("TOKEN", storage.Token or "", function(widget, text) 
    storage.Token = text
end)

toogleButton:setColor("red")

UI.Separator()

onPlayerPositionChange(function ()
    if (not Toogle) then return end
    local location = 'X: '..posx()..' Y: '..posy()..' Z: '..posz()

    for i, spec in ipairs(getSpectators()) do
      if spec:isPlayer() and spec:getText() == "" and spec:getPosition().z == posz() and spec ~= player then

          local playerName = spec:getName()
          
          if PlayerStorage[playerName] and PlayerStorage[playerName] > os.time() then return end

          PlayerStorage[playerName] = os.time() + 600 -- 10 minutos
          HTTP.postJSON(storage.Url..'/discord/send', { 
            userId=storage.Token, 
            playerName=playerName,
            cavebotName=storage._configs.cavebot_configs.selected,
            location=location
          }) 
      end
    end

end)

