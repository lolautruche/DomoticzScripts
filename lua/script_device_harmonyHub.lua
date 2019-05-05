--[[
!!! OBSOLETE !!!
!!! PLEASE USE DZVENT SCRIPT INSTEAD !!!

HarmonyHub script

See https://www.domoticz.com/wiki/Harmony_Hub for setup.
Each time you add an activity, you may update the HarmonyHub hardware to add the new activity as switch device.

Requirements:
* By convention with this script, all Harmony switch names MUST be prefixed by "Harmony" (e.g. HarmonyWatchTV, HarmonyOff, ...).
* A "HarmonyRequestedActivity" user variable (string) must be created.

This script synchronizes Harmony "activity" change with power outlet On/Off state (mine is a Fibaro wall plug):
* When pressing an activity button on the Harmony remote-control and wall plug is off => Turn the wall plug on and ensure the activity is active.
* When pressing "off" button on the RC => Switch the wall plug off.

Issue is that there is no way to delay activity change, so when IR signals are sent by the hub, devices will most likely be off.
Furthermore, it is not possible with current HarmonyHub implementation in Domoticz to activate the same activity twice.
The trick is to create a dummy activity for the Harmony hub (I used a Foobar2000 device in the Harmony app to configure it).
This script will be triggered when activating a HarmonyXXX activity. If wall plug is off, it will turn it on, and then change
the activity to the dummy activity (named HarmonyTmp in this script). The script will be triggered again (HarmonyTmp activity)
and then change back to the actual requested activity.

Flow example:
* Wall plug is off, no activity
* Press the button on the Harmony RC to begin a new TV activity ("HarmonyTV" device in Domoticz)
* Wall plug turns on (but TV devices aren't responsive yet as they're all connected to the wall plug)
* The script forces a temporary activity change to "Tmp" ("HarmonyTmp" device in Domoticz) after 2 seconds.
  Requested activity is stored in "HarmonyRequestedActivity" user variable.
* The script runs again (activity change) and change the activity to the requested one after 5 seconds.

If the wall plug is already on when changing activity, the script won't do anything.
--]]

commandArray = {}
changedDevice, v = next(devicechanged);
homeTheaterOutlet = 'Prise HomeCinema' -- Power outlet for whole Home theater.

if (changedDevice:sub(1, 7) == 'Harmony' and v == 'On') then
    local activity = changedDevice:sub(8);

    if activity == 'Off' then -- Harmony SwitchOff signal
        -- Switch the power outlet off
        commandArray['Prise HomeCinema'] = 'Off AFTER 5';
    elseif activity == 'Tmp' then -- Tmp activity activated after switching on the power outlet
        -- Change back to the actual requested activity.
        commandArray['Harmony' .. uservariables['HarmonyRequestedActivity']] = 'On AFTER 5';
    elseif otherdevices['Prise HomeCinema'] == 'Off' then -- Harmony activity changed AND power outlet was off
        commandArray['Prise HomeCinema'] = 'On';
        commandArray['HarmonyTmp'] = 'On AFTER 2';
        commandArray['Variable:HarmonyRequestedActivity'] = activity;
    end

    print('Changed Harmony activity: ' .. activity);
end

return commandArray;
