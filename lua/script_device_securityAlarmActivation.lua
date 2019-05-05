-- !!! OBSOLETE !!!
-- !!! PLEASE USE DZVENT SCRIPT INSTEAD !!!

-- Alarm activation from Mini keypad
-- Activates Domoticz internal alarm and sends acknowledgement to the keypad.
-- Arm status will depend on status of absence switch.

keypadSwitch = 'Alarm Level' -- Mini keypad switch device name
-- Scene to trigger to acknowledge alarm arming/disarming
-- This scene should at least activate keypad "General" switch
-- to send feedback from the Z-wave controller to the keypad.
-- See Mini keypad documentation for more information.
-- This scene can also e.g. switch on then off a light.
acknoledgementScene = 'Alarm ack'

commandArray = {}
if (devicechanged[keypadSwitch] == 'On') then
    commandArray['Security panel'] = 'Arm Away'
    commandArray['Scene:' .. acknoledgementScene] = 'On'
elseif (devicechanged[keypadSwitch] == 'Off') then
    commandArray['Security panel'] = 'Disarm'
    commandArray['Scene:' .. acknoledgementScene] = 'On'
end

return commandArray
