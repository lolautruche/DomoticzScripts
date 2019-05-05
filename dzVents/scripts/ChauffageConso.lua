--[[
Counter script for electrical radiators.

This script increments a dummy energy counter to calculate electrical power consumption coming from radiators.

Requirements:
* Radiator switches must be named with a common prefix (see devices trigger).
  Rest of the switch name defines radiator's location (heating zone if radiators are grouped).
* Radiators' power capacity are stored in heatingPowerByZone table below (e.g. 2000 for 2000W).
* A dummy counter must be created, with "energy" type. Name must be stored in "generalCounterName" variable below.
--]]

heatingPowerByZone = {
    Chambres = 4000,
    Salon = 3500
};
generalCounterName = 'ConsoChauffage';

return {
	on = {
		devices = {
			'Radiateurs*'
		},
	},

	data = {
		heatingStartTimeByZone = {
		    initial = {
		        Chambres = 0,
		        Salon = 0
	        }
		},
	},

	execute = function(domoticz, triggeredItem, info)
		local heatingZone = triggeredItem.name:sub(11);

		-- If radiator was activated, just store starting time and exit
		if (triggeredItem.active) then
		    domoticz.data.heatingStartTimeByZone[heatingZone] = os.time();
		    domoticz.log('Started heating zone ' .. heatingZone, domoticz.LOG_INFO);

		    return;
	    end

        local elapsedTime = os.time() - domoticz.data.heatingStartTimeByZone[heatingZone];
        local powerPerSecond = heatingPowerByZone[heatingZone] / 3600;
        local powerConsumption = math.ceil(elapsedTime * powerPerSecond);
        local generalCounter = domoticz.devices(generalCounterName);
        local currentPower = generalCounter.counter * 1000; -- Multiply by 1000 since unit is kw/h
        generalCounter.updateCounter(currentPower + powerConsumption);
        domoticz.log('Heating power consumption for ' .. heatingZone .. ': ' .. powerConsumption .. 'W', domoticz.LOG_INFO);
		
	end
}

