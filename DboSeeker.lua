setDefaultTab("Main")
UI.Separator()

local PlayerStorage = {}
local Toogle = false
local ScreenshotPath = "screenshot.png"

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

local function sendEvent(screenshotLink, location, playerName)
    print("Sending event...")
    print("Screenshot: "..screenshotLink)

    HTTP.postJSON(storage.Url..'/discord/send', { 
        userId=storage.Token, 
        playerName=playerName,
        cavebotName=storage._configs.cavebot_configs.selected,
        location=location,
        screenshotLink=screenshotLink
    })
end


local function createScreenshot(location, playerName)
    doScreenshot(ScreenshotPath);
    
    while not g_resources.fileExists(ScreenshotPath) do
        print("Waiting for screenshot to be created...")
    end
    

    HTTP.postJSON(
        storage.Url.."/discord/file",
        g_resources.readFileContents(ScreenshotPath),
        function(response, err)
            if err then screenshot = nil return end
            
            sendEvent(response.data.imageLink, location, playerName)
        end
    ); 


    return screenshotLink
end

onCreaturePositionChange(function (creature)
    if (not Toogle or not creature:isPlayer() or creature:isLocalPlayer() or not creature:getPosition() or not creature:getPosition().z == posz()) then return end

    local location = 'X: '..posx()..' Y: '..posy()..' Z: '..posz()

    local playerName = creature:getName()
    
    if PlayerStorage[playerName] and PlayerStorage[playerName] > os.time() then return end

    PlayerStorage[playerName] = os.time() + 600 -- 10 minutos
    createScreenshot(location, playerName)

end)

