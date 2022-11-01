UI.Separator()
setDefaultTab("Main")

local expPanel = setupUI([[
OutlineLabel < Label
  height: 12
  background-color: #00000044
  opacity: 0.89
  text-auto-resize: true
  font: verdana-11px-rounded
  anchors.left: parent.left
  $first:
    anchors.top: parent.top
  $!first:
    anchors.top: prev.bottom

Panel
  id: skillPanel
  height: 50
  width: 50
  anchors.left: parent.left
  anchors.bottom: parent.bottom
  margin-bottom: 5
  margin-left: 5
]], modules.game_interface.getMapPanel())

local experienceButton = setupUI([[
Panel  
  margin-top:2
  height: 115
  Label
    id: title
    text: Experience
    text-align: center
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
  Button
    id: reset
    anchors.top: title.bottom
    anchors.left: parent.left
    width: 150
    height: 30
    margin-top: 10
    margin-left: 2
    text: Reset Experience
    color: red
    tooltip: Reset Data
]])

local expPerHourLabel = UI.createWidget("OutlineLabel", expPanel)
local expPerMinuteLabel = UI.createWidget("OutlineLabel", expPanel)


expValue = exp();
timeValue = os.time();

function reset()
    expValue = exp()
    timeValue = os.time()
end

experienceButton.reset.onClick = function(widget)
  reset()
end

function refreshExperience()
    newExp = exp()
    newTime = os.time()

    expPerMinute = (newExp - expValue) / ((newTime - timeValue) / 60)
    expPerHour = (newExp - expValue) / ((newTime - timeValue) / 3600)

    expPerHourLabel:setText(string.format("Experience per minute: %dK", expPerMinute/1000))
    expPerHourLabel:setColor("red")

    expPerMinuteLabel:setText(string.format("Experience per hour: %dK", expPerHour/1000))
    expPerMinuteLabel:setColor("blue")

end

refreshExperience()

macro(200, function()
    refreshExperience()
end)