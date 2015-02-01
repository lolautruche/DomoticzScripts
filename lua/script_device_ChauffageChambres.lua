-- Thermostat "SetPoint" management for "Chambres" (bedrooms)
-- Updates thermostat temperature when needed.
-- Needs following user variables to be defined:
-- * TempChambres: Temperature to set
-- * TempChambresConfort: Comfort temperature (e.g. 19.0)
-- * TempChambresEco: Eco temperature (e.g. 17.0)
--
-- Also depends on "HomeOffice" virtual switch, which will be on if someone is working from home.
-- Having it on will avoid eco temperature to be used (e.g. during a working day).
--
-- Note that normal "UpdateDevice" command doesn't seem to work:
-- commandArray['UpdateDevice'] = idxThermostat .. '|0|' .. uservariables['TempChambresConfort']
-- So calling internal Json API instead

-- Thermostat IDX for "Chambres"
idxThermostat = 14
apiUrl = 'http://192.168.0.5:8080/json.htm?type=setused&idx=%d&setpoint=%s&used=true'
commandArray = {}

-- "Comfort" mode on, and registered temperature different than "comfort" programmed temperature.
-- TODO: Check device actual temp instead of using a user variable.
if (devicechanged['ChauffageChambresConfort'] == 'On' or devicechanged['HomeOffice'] == 'On')
    and uservariables['TempChambres'] ~= uservariables['TempChambresConfort']
then
    apiUrl = string.format(apiUrl, idxThermostat, uservariables['TempChambresConfort'])
    commandArray['OpenURL'] = apiUrl
    commandArray['Variable:TempChambres'] = tostring(uservariables['TempChambresConfort'])
    print('Calling API: ' .. apiUrl)
    print('Changing temperature for "Chambres": ' .. uservariables['TempChambresConfort'] .. '°C')

-- "Eco" mode on, and registered temperature different than "eco" programmed temperature.
-- Also check if "HomeOffice" switch is off.
elseif (devicechanged['ChauffageChambresConfort'] == 'Off' or devicechanged['HomeOffice'] == 'Off')
    and uservariables['TempChambres'] ~= uservariables['TempChambresEco']
then
    apiUrl = string.format(apiUrl, idxThermostat, uservariables['TempChambresEco'])
    commandArray['OpenURL'] = apiUrl
    commandArray['Variable:TempChambres'] = tostring(uservariables['TempChambresEco'])
    print('Calling API: ' .. apiUrl)
    print('Changing temperature for "Salon": ' .. uservariables['TempChambresEco'] .. '°C')

end

return commandArray
