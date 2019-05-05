-- !!! OBSOLETE !!!
-- !!! PLEASE USE DZVENT SCRIPT INSTEAD !!!

-- Send notification when security state changes.

commandArray = {}
subject = 'Domoticz - Alarm activation'
body = ''
siren = 'Sirène'
alarmSwitchFrontDoor = 'Alarme porte entrée'

if (globalvariables['Security'] ~= 'Disarmed') then
    body = 'Alarm was correctly armed'
else
    body = 'Alarm was correctly disarmed'
    -- Ensure to deactivate the Siren and related devices
    commandArray[siren] = 'Off'
    commandArray[alarmSwitchFrontDoor] = 'Off'
end

commandArray['SendNotification'] = subject .. '#' .. body .. '#0#spacealarm'

return commandArray
