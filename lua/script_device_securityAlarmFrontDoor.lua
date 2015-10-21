-- Alarm scenario when an intrusion is detected through front door.
-- See script_device_securityAlarm.lua

alarmSwitchFrontDoor = 'Alarme porte entrée'
siren = 'Sirène'
sirenLevel = 100
cameraSceneBackToFront = 'Alarme photos jardin-rue'

notificationSubject = 'Cambrioleur entré : '

debug = true
commandArray = {}

if (debug) then
    -- Make Fortrezz SSA1 only flash when debugging
    sirenLevel = 10
end

if (devicechanged[alarmSwitchFrontDoor] == 'On') then
    commandArray['Scene:' .. cameraSceneBackToFront] = 'On'
    commandArray['SendNotification'] = notificationSubject .. alarmSwitchFrontDoor .. '#' .. notificationSubject .. 'Front door#2'
    commandArray[siren] = 'Set Level ' .. tostring(sirenLevel)

    return commandArray
end
