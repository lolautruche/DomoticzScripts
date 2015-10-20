-- Send notification when security state changes.

commandArray = {}
subject = 'Domoticz - Alarm activation'
body = ''
siren = 'Sirène'

if (globalvariables['Security'] ~= 'Disarmed') then
    body = 'Alarm was correctly armed'
else
    body = 'Alarm was correctly disarmed'
    -- Ensure to deactivate the Siren
    commandArray[siren] = 'Off'
end

commandArray['SendNotification'] = subject .. '#' .. body .. '#0#spacealarm'

return commandArray
