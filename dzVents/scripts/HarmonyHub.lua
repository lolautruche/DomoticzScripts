--[[
HarmonyHub DzVent script

See https://www.domoticz.com/wiki/Harmony_Hub for setup.
Each time you add an activity, you may update the HarmonyHub hardware to add the new activity as switch device.

Requirements:
* By convention with this script, all Harmony switch names MUST be prefixed by "Harmony" (e.g. HarmonyWatchTV, HarmonyOff, ...).

This script synchronizes Harmony "activity" change with power outlet On/Off state (mine is a Fibaro wall plug):
* When pressing an activity button on the Harmony remote-control and wall plug is off => Turns the wall plug on and ensures the activity is active.
* When pressing "off" button on the RC => Switches the wall plug off.


Flow example:
* Wall plug is off, no activity
* Press the button on the Harmony RC to begin a new TV activity ("HarmonyTV" device in Domoticz)
* Wall plug turns on (but TV devices aren't responsive yet as they're all connected to the wall plug)
* The script forces a new activity change to the same
* The script runs again (activity change) and change the activity to the requested one after 5 seconds.

If the wall plug is already on when changing activity, the script won't do anything.
--]]

homeTheaterOutlet = 'Prise HomeCinema'; -- Power outlet for whole Home theater.

return {
    on = {
        devices = { 'Harmony*' }
    },

    data = {
    	currentActivity = { initial = 'Off' }
    },

    execute = function(domoticz, harmonySwitch)
        if not harmonySwitch.active then
            domoticz.log(harmonySwitch.name .. " is OFF", domoticz.LOG_INFO)
            return;
        end

        activity = harmonySwitch.name:sub(8);

		if activity == 'Off' then -- Harmony SwitchOff signal
	        -- Switch the power outlet off
	        domoticz.log("Harmony SwitchOff signal caught! Switching off power outlet.", domoticz.LOG_INFO)
	        domoticz.devices(homeTheaterOutlet).switchOff().afterSec(5);
	    elseif domoticz.data.currentActivity == 'Off' then -- Harmony activity changed AND power outlet was off
	        domoticz.log("Harmony " .. activity .. " launched while power outlet was off. Turning it on.", domoticz.LOG_INFO)
	        domoticz.devices(homeTheaterOutlet).switchOn();
	        harmonySwitch.switchOn().afterSec(10);
	    end

	    domoticz.data.currentActivity = activity;
	    domoticz.log('Changed Harmony activity: ' .. activity, domoticz.LOG_INFO);
    end
}

