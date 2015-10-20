-- Alarm activation from Mini keypad
-- Activates Domoticz internal alarm and sends acknowledgement to the keypad.
-- Arm status will depend on status of absence switch.

commandArray = {}
if (devicechanged['Alarm Level'] == 'On') then
	if (otherdevices['Absence'] == 'On') then
        commandArray['Security panel'] = 'Arm Away'
    else
        commandArray['Security panel'] = 'Arm Home'
    end
	commandArray['Scene:Alarm ack'] = 'On'
elseif (devicechanged['Alarm Level'] == 'Off') then
	commandArray['Security panel'] = 'Disarm'
	commandArray['Scene:Alarm ack'] = 'On'
end

return commandArray
