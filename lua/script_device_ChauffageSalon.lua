-- Thermostat "SetPoint" management for "Salon" (living room)
-- Updates thermostat temperature when needed.
-- Needs following user variables to be defined:
-- * TempSalon: Temperature to set
-- * TempSalonConfort: Comfort temperature (e.g. 19.0)
-- * TempSalonEco: Eco temperature (e.g. 17.0)
--
-- Also depends on "HomeOffice" virtual switch, which will be on if someone is working from home.
-- Having it on will avoid eco temperature to be used (e.g. during a working day).
--
-- Note that normal "UpdateDevice" command doesn't seem to work:
-- commandArray['UpdateDevice'] = idxThermostat .. '|0|' .. uservariables['TempSalonConfort']
-- So calling internal Json API instead

-- Thermostat IDX for "Salon"
idxThermostat = 9
apiUrl = 'http://192.168.0.5:8080/json.htm?type=setused&idx=%d&setpoint=%s&used=true'
commandArray = {}

-- "Comfort" mode on, and registered temperature different than "comfort" programmed temperature.
-- TODO: Check device actual temp instead of using a user variable.
if devicechanged['ChauffageSalonConfort'] == 'On'
    and uservariables['TempSalon'] ~= uservariables['TempSalonConfort']
then
    apiUrl = string.format(apiUrl, idxThermostat, uservariables['TempSalonConfort'])
    commandArray['OpenURL'] = apiUrl
    commandArray['Variable:TempSalon'] = tostring(uservariables['TempSalonConfort'])
    print('Calling API: ' .. apiUrl)
    print('Changing temperature for "Salon": ' .. uservariables['TempSalonConfort'] .. '°C')

-- "Eco" mode on, and registered temperature different than "eco" programmed temperature.
-- Also check if "HomeOffice" switch is off.
elseif devicechanged['ChauffageSalonConfort'] == 'Off'
    and uservariables['TempSalon'] ~= uservariables['TempSalonEco']
    and otherdevices['HomeOffice'] == 'Off'
then
    apiUrl = string.format(apiUrl, idxThermostat, uservariables['TempSalonEco'])
    commandArray['OpenURL'] = apiUrl
    commandArray['Variable:TempSalon'] = tostring(uservariables['TempSalonEco'])
    print('Calling API: ' .. apiUrl)
    print('Changing temperature for "Salon": ' .. uservariables['TempSalonEco'] .. '°C')
end

return commandArray
