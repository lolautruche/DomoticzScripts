-- !!! OBSOLETE !!!
-- !!! PLEASE USE DZVENT SCRIPT INSTEAD !!!

-- Main alarm script.
-- Checks door/window sensors (perimetric alarm) and/or PIR sensor (volumetric alarm).
-- Volumetric detection is only used when Domoticz alarm status is "Armed Away".
-- See also script_security_notification.lua (alarm activation/deactivation)
-- and script_device_securityAlarmFrontDoor.lua (activation when front door is open).

-- Door/window sensors / PIR
frontDoor = 'Porte entrée' -- Front door sensor name
frontWindow = 'Fenêtre rue' -- front window sensor name
kitchenWindow = 'Fenêtre cuisine' -- Kitchen window sensor name
livingRoomWindow = 'Fenêtre salon' -- Living room sensor name
pir = 'Sauron présence' -- PIR

-- Camera scenes
-- Will move the camera and take pictures.
cameraSceneBackToFront = 'Alarme photos jardin-rue'
cameraSceneFrontToBack = 'Alarme photos rue-jardin'

siren = 'Sirène' -- Siren device name (Fortrezz SSA2)
sirenLevel = 100 -- Siren level (Fortrezz SSA2 acts as a dimmer)

alarmSwitchFrontDoor = 'Alarme porte entrée' -- Virtual switch to activate if intrusion from front door is detected.
alarmSwitchFrontDoorDelay = '30' -- Delay after which alarmSwitchFrontDoor will be activated once the front door is open.

notificationSubject = 'Cambrioleur entré : '

debug = uservariables['Debug'] ~= 0
commandArray = {}

if (debug) then
    -- Make Fortrezz SSA2 only flash when debugging
    sirenLevel = 10
end

if (globalvariables['Security'] ~= 'Disarmed') then
    for i, v in pairs(devicechanged) do changedDevice = i end -- Store name of the device changed to changedDevice variable
    -- Back windows are being open
    if (devicechanged[kitchenWindow] == 'Open' or devicechanged[livingRoomWindow] == 'Open') then
        commandArray[siren] = 'Set Level ' .. tostring(sirenLevel)
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
        commandArray['Scene:' .. cameraSceneBackToFront] = 'On'
        -- Front window is being open
    elseif (devicechanged[frontWindow] == 'Open') then
        commandArray[siren] = 'Set Level ' .. tostring(sirenLevel)
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
        commandArray['Scene:' .. cameraSceneFrontToBack] = 'On'
        -- Front door. Special case as an authorized person can enter through it.
    -- Give some time to disarm the alarm.
    -- When given time is up, activate "alarmSwitchFrontDoor" (see script_device_securityAlarmFrontDoor.lua).
    elseif (devicechanged[frontDoor] == 'Open') then
        commandArray[alarmSwitchFrontDoor] = 'On AFTER ' .. alarmSwitchFrontDoorDelay
    -- PIR change. Only used when alarm is being "armed away".
    elseif (globalvariables['Security'] == 'Armed Away' and devicechanged[pir] == 'On' and otherdevices[frontDoor] == 'Closed') then
        commandArray[siren] = 'Set Level ' .. tostring(sirenLevel)
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
        commandArray['Scene:' .. cameraSceneBackToFront] = 'On'
    end
end

return commandArray
