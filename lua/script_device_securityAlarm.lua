-- Alarm

-- Door/window sensors / PIR
frontDoor = 'Porte entrée' -- Front door sensor name
frontWindow = 'Fenêtre rue' -- front window sensor name
kitchenWindow = 'Fenêtre cuisine' -- Kitchen window sensor name
livingRoomWindow = 'Fenêtre salon' -- Living room sensor name
pir = 'Sauron présence' -- PIR

-- Camera scenes
-- Will move the camera and take pictures.
cameraSceneBackToFront = 'Alarme photos jardin-rue' -- Camera scene name (back to front). This scene
cameraSceneFrontToBack = 'Alarme photos rue-jardin'

siren = 'Sirène' -- Siren device name (Fortrezz SSA2)
sirenLevel = 100 -- Siren level (Fortrezz SSA2 acts as a dimmer)

alarmSwitchFrontDoor = "Alarme porte d'entrée" -- Virtual switch to activate if intrusion from front door is detected.
alarmSwitchFrontDoorDelay = '15' -- Delay after which alarmSwitchFrontDoor will be activated once the front door is open.

notificationSubject = 'Cambrioleur entré : '

debug = true
commandArray = {}

if (debug) then
    -- Make Fortrezz SSA2 only flash when debugging
    sirenLevel = 10
end

if (globalvariables['Security'] ~= 'Disarmed') then
    for i, v in pairs(devicechanged) do changedDevice = i end -- Store name of the device changed to changedDevice variable
    -- Back windows are being open
    if (devicechanged[kitchenWindow] == 'Open' or devicechanged[livingRoomWindow] == 'Open') then
        commandArray['Scene:' .. cameraSceneBackToFront] = 'On'
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
        commandArray[siren] = 'Set Level ' .. tostring(sirenLevel) .. ' AFTER 5'
    -- Front window is being open
    elseif (devicechanged[frontWindow] == 'Open') then
        commandArray['Scene:' .. cameraSceneFrontToBack] = 'On'
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
        commandArray[siren] = 'Set Level ' .. tostring(sirenLevel) .. ' AFTER 5'
    -- Front door. Special case since we need to be able to disarm the alarm as this can be triggered by a granted person.
    elseif (devicechanged[frontDoor] == 'Open') then
        commandArray[alarmSwitchFrontDoor] = 'On AFTER ' .. alarmSwitchFrontDoorDelay
    -- PIR change. Only used when alarm is being "armed away".
    elseif (globalvariables['Armed Away'] and devicechanged[pir] == 'On' and devicechanged[frontDoor] == 'Closed') then
        commandArray['Scene:' .. cameraSceneBackToFront] = 'On'
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
    end
end

return commandArray
