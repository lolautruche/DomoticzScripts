-- Dealing with "Away" mode ("Absence" in french) for heating zones.
-- When on, all heating zones are switched to eco temperature.
-- When off, heating zones are switched back to their appropriate temperature, stored in user variables.
-- User variables will continue to be updated by "normal" mode switches (see other heating scripts).

idxThermostatSalon = 9
idxThermostatChambres = 14
apiUrl = 'http://192.168.0.5:8080/json.htm?type=setused&idx=%d&setpoint=%s&used=true'
commandArray = {}

if devicechanged['Absence'] == 'On' then
    print('Away mode on. Switching all heating zones to "eco"')
    commandArray[1] = {['OpenURL'] = string.format(apiUrl, idxThermostatSalon, uservariables['TempAbsence']) }
    commandArray[2] = {['OpenURL'] = string.format(apiUrl, idxThermostatChambres, uservariables['TempAbsence'])}

elseif devicechanged['Absence'] == 'Off' then
    -- Change back thermostats setpoints to appropriate temperature
    print('Away mode off. Switching back heating zones to their appropriate mode.')

    commandArray[1] = {['OpenURL'] = string.format(apiUrl, idxThermostatSalon, uservariables['TempSalon'])}
    print('Changing temperature for "Salon": ' .. uservariables['TempSalon'] .. '°C')

    commandArray[2] = {['OpenURL'] = string.format(apiUrl, idxThermostatChambres, uservariables['TempChambres'])}
    print('Changing temperature for "Chambres": ' .. uservariables['TempChambres'] .. '°C')
end

return commandArray
