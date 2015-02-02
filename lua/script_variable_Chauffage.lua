-- Updates thermostat temperature whenever corresponding user variables have changed
-- 2 zones are checked: "Salon" (living room) and "Chambres" (bedrooms). A user variable is assigned for each of them.

commandArray = {}
idxSalon = 9
idxChambres = 14
apiUrl = 'http://192.168.0.5:8080/json.htm?type=setused&idx=%d&setpoint=%s&used=true'

-- Don't update setpoint in away mode.
if otherdevices['Absence'] == 'On' then
    return commandArray
end

if uservariablechanged['TempSalon'] then
    commandArray['OpenURL'] = string.format(apiUrl, idxSalon, uservariablechanged['TempSalon'])
    print('Changing temperature for "Salon": ' ..  uservariablechanged['TempSalon'] .. '°C')
elseif uservariablechanged['TempChambres'] then
    commandArray['OpenURL'] = string.format(apiUrl, idxChambres, uservariablechanged['TempChambres'])
    print('Changing temperature for "Chambres": ' ..  uservariablechanged['TempChambres'] .. '°C')
end

return commandArray
