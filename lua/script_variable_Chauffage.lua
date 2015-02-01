-- Updates thermostat temperature whenever corresponding user variables have changed
-- 2 zones are checked: "Salon" (living room) and "Chambres" (bedrooms). A user variable is assigned for each of them.

commandArray = {}
idxSalon = 9
idxChambres = 14
apiUrl = 'http://192.168.0.5:8080/json.htm?type=setused&idx=%d&setpoint=%s&used=true'

if uservariablechanged['TempSalon'] then
    apiUrl = string.format(apiUrl, idxSalon, uservariablechanged['TempSalon'])
    commandArray['OpenURL'] = apiUrl
    print('Calling API: ' .. apiUrl)
    print('Changing temperature for "Salon": ' ..  uservariablechanged['TempSalon'] .. '°C')
elseif uservariablechanged['TempChambres'] then
    apiUrl = string.format(apiUrl, idxChambres, uservariablechanged['TempChambres'])
    commandArray['OpenURL'] = apiUrl
    print('Calling API: ' .. apiUrl)
    print('Changing temperature for "Chambres": ' ..  uservariablechanged['TempChambres'] .. '°C')
end

return commandArray
