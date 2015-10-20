-- Alarm

frontDoor = 'Porte entrée'
frontWindow = 'Fenêtre rue'
kitchenWindow = 'Fenêtre cuisine'
livingRoomWindow = 'Fenêtre salon'
cameraSceneBackToFront = 'Alarme photos jardin-rue'
cameraSceneFrontToBack = 'Alarme photos rue-jardin'
pir = 'Sauron présence'
sirenScene = 'Alarme Sirène'

notificationSubject = 'Cambrioleur entré : '

if (globalvariables['Security'] ~= 'Disarmed') then
    for i, v in pairs(devicechanged) do changedDevice = i end -- Store name of the device changed to changedDevice variable
    if (devicechanged[kitchenWindow] == 'Open' or devicechanged[livingRoomWindow] == 'Open') then
        commandArray['Scene:' .. cameraSceneBackToFront] = 'On'
        commandArray['Scene:' .. sirenScene] = 'On'
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
    elseif (devicechanged[frontWindow] == 'Open') then
        commandArray['Scene:' .. cameraSceneBackToFront] = 'On'
        commandArray['Scene:' .. sirenScene] = 'On'
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
    elseif (devicechanged[frontDoor] == 'Open') then

    elseif (globalvariables['Armed Away'] and devicechanged[pir] == 'On') then
        commandArray['Scene:' .. cameraSceneBackToFront] = 'On'
        commandArray['Scene:' .. sirenScene] = 'On'
        commandArray['SendNotification'] = notificationSubject .. changedDevice .. '#' .. notificationSubject .. changedDevice .. '#2'
    end
end

return commandArray
