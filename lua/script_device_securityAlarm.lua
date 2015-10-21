-- Alarm

frontDoor = 'Porte entrée'
frontWindow = 'Fenêtre rue'
kitchenWindow = 'Fenêtre cuisine'
livingRoomWindow = 'Fenêtre salon'
cameraSceneBackToFront = 'Alarme photos jardin-rue'
cameraSceneFrontToBack = 'Alarme photos rue-jardin'
pir = 'Sauron présence'
siren = 'Sirène'
sirenLevel = 100
alarmSwitchFrontDoor = "Alarme porte d'entrée" -- Virtual switch to activate if intrusion from front door is detected.
alarmSwitchFrontDoorDelay = '15' -- Delay after which alarmSwitchFrontDoor will be activated once the front door is open.

notificationSubject = 'Cambrioleur entré : '

debug = true
commandArray = {}

if (debug) then
    -- Make Fortrezz SSA1 only flash when debugging
    sirenLevel = 10
end

if (globalvariables['Security'] ~= 'Disarmed') then
    for i, v in pairs(devicechanged) do changedDevice = i end -- Store name of the device changed to changedDevice variable
    if (devicechanged[kitchenWindow] == 'Open' or devicechanged[livingRoomWindow] == 'Open') then
        commandArray['Scene:' .. cameraSceneBackToFront] = 'On'
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
        commandArray[siren] = 'Set Level ' .. tostring(sirenLevel) .. ' AFTER 5'
    elseif (devicechanged[frontWindow] == 'Open') then
        commandArray['Scene:' .. cameraSceneFrontToBack] = 'On'
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
        commandArray[siren] = 'Set Level ' .. tostring(sirenLevel) .. ' AFTER 5'
    elseif (devicechanged[frontDoor] == 'Open') then
        commandArray[alarmSwitchFrontDoor] = 'On AFTER ' .. alarmSwitchFrontDoorDelay
    elseif (globalvariables['Armed Away'] and devicechanged[pir] == 'On') then
        commandArray['Scene:' .. cameraSceneBackToFront] = 'On'
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
    end
end

return commandArray
