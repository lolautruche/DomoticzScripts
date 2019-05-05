--[[
!!! OBSOLETE !!!
!!! PLEASE USE DZVENT SCRIPT INSTEAD !!!

Counter script for electrical radiators.

This script increments a dummy energy counter to calculate electrical power consumption coming from radiators.

Requirements:
* Radiator switches must be named with a common prefix, defined in "heaterPrefix" variable below.
  Rest of the switch name defines radiator's location (heating zone if radiators are grouped).
* 1 user variable per radiator (integer) to store power on time. Name must have "<heaterPrefix>PowerOnTime" prefix.
  Rest of the user variable name defines radiator's location. Example => "RadiateursPowerOnTimeLivingRoom".
* 1 user variable per radiator (integer) defining radiator's power capacity (e.g. 2000 for 2000W).
  Name must have "<heaterPrefix>Power" prefix. Rest of the user variable name defines radiator's location.
  Example => "RadiateursPowerLivingRoom".
* A dummy counter must be created. IDX of this counter must be stored in "counterIdx" variable below.
--]]

commandArray = {};
heaterPrefix = 'Radiateurs';
heaterOnVariableTimePrefix = heaterPrefix .. 'PowerOnTime';
heaterPowerVariablePrefix = heaterPrefix .. 'Power';
counterName = 'ConsoChauffage';
counterIdx = 148;

changedDevice, v = next(devicechanged);

if (changedDevice:sub(1, 10) == heaterPrefix) then
    local heatingZone = changedDevice:sub(11);

    if (v == 'On') then -- Radiator is on, store current timestamp for further calculation.
        commandArray['Variable:' .. heaterOnVariableTimePrefix .. heatingZone] = tostring(os.time());
    elseif (v == 'Off') then -- Radiator is of, calculate power consumption and update the counter.
        local powerOnTime = uservariables[heaterOnVariableTimePrefix .. heatingZone];
        local elapsedTime = os.time() - powerOnTime;
        local powerPerSecond = uservariables[heaterPowerVariablePrefix .. heatingZone] / 3600;
        local powerConsumption = math.ceil(elapsedTime * powerPerSecond);
        local currentPower = tonumber(otherdevices_svalues[counterName]);
        local newTotalPower = currentPower + powerConsumption;

        print('Heating power consumption: ' .. powerConsumption .. 'W');
        print('New total power : ' .. newTotalPower .. 'Wh');
        commandArray['UpdateDevice'] = counterIdx .. '|0|' .. newTotalPower;
    end
end

return commandArray;
