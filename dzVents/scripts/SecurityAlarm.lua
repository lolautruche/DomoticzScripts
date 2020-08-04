--[[
Alarm script

Alarm is activated from Mini keypad.
Activates Domoticz internal alarm and sends visual acknowledgement + notification.
Arm status will depend on "SecurityArmAway" user variable (integer : 0 or 1).

Checks door/window sensors (perimetric alarm) and/or PIR sensor (volumetric alarm).
Volumetric detection is only used when Domoticz alarm status is "Armed Away".

When intrusion is detected with front door, it gives a delay in order to be able to disarm.

--]]
devicesNames = {
    securityPanel = 'Security panel',
    keypadSwitch = 'Access Control', -- Mini keypad switch device name
    alarmSwitchFrontDoor = 'Alarme porte entrée', -- Virtual switch to activate if intrusion from front door is detected.
    siren = 'Sirène',
    confirmationLight = 'Lustre Salon',
    homeMode = 'SurveillanceStation - HomeMode',
    -- Door/window sensors / PIR
    frontDoor = 'Porte entrée', -- Front door sensor name
    frontWindow = 'Fenêtre rue', -- front window sensor name
    kitchenWindow = 'Fenêtre cuisine', -- Kitchen window sensor name
    livingRoomWindow = 'Fenêtre salon', -- Living room sensor name
    bedroom1 = 'Fenêtre parents',
    bedroom2 = 'Fenêtre Quentin',
    bedroom3 = 'Fenêtre Clémence',
    bedroom4 = 'Fenêtre salle de jeu',
    pir = 'Sauron présence' -- PIR
};
alarmSwitchFrontDoorDelay = 30 -- Delay after which alarmSwitchFrontDoor will be activated once the front door is open.

return {

	on = {

		-- device triggers
		devices = {
			devicesNames.keypadSwitch, -- Keypad switch name
			devicesNames.frontDoor,
			devicesNames.frontWindow,
			devicesNames.kitchenWindow,
			devicesNames.livingRoomWindow,
			devicesNames.alarmSwitchFrontDoor,
			devicesNames.bedroom1,
			devicesNames.bedroom2,
			devicesNames.bedroom3,
			devicesNames.bedroom4,
		},

		-- security triggers
		security = {
			domoticz.SECURITY_ARMEDAWAY,
			domoticz.SECURITY_ARMEDHOME,
			domoticz.SECURITY_DISARMED
		},

        httpResponses = { 'surveillanceStationCallback' }
    },

    execute = function(domoticz, device)
        local debug = domoticz.variables('Debug').value ~= 0;
        local sirenLevel = debug and 10 or 100;
        
        -- Arming/Disarming with keypad switch
        if (device.name == devicesNames.keypadSwitch) then
            local securityPanel = domoticz.devices(devicesNames.securityPanel);
            if (device.active) then
                if (domoticz.variables('SecurityArmAway').value == 1) then
                    securityPanel.armAway()
                else
                    securityPanel.armHome();
                end
            else
                securityPanel.disarm();
            end

        -- Security status change (see "security" triggers)
        elseif (device.isSecurity) then
            local subject = 'Domoticz - Alarm activation'

            if (device.state == domoticz.SECURITY_DISARMED) then
                body = 'Alarm was correctly disarmed';
                surveillanceStationStatus = 'false';
                domoticz.devices(devicesNames.homeMode).switchOff();
                domoticz.devices(devicesNames.siren).switchOff();
                domoticz.devices(devicesNames.alarmSwitchFrontDoor).switchOff();
            else
                body = 'Alarm was correctly armed';
                surveillanceStationStatus = 'true';
                -- Activate SurveillanceStation HomeMode
                domoticz.devices(devicesNames.homeMode).switchOn();
            end

            domoticz.log('Setting SurveillanceStation HomeMode to ' .. surveillanceStationStatus);

            -- Confirm status visually
            local confirmationLight = domoticz.devices(devicesNames.confirmationLight);
            confirmationLight.switchOff();
            confirmationLight.switchOn().afterSec(1).forSec(2).repeatAfterSec(1, 1);
            confirmationLight.switchOff().afterSec(5);

            -- Send notification
            domoticz.notify(subject, body, domoticz.PRIORITY_NORMAL, domoticz.SOUND_SPACEALARM);
            domoticz.log(body, domoticz.LOG_INFO);

        elseif (device.isHTTPResponse) then
            domoticz.log('Response from SurveillanceStation: ' .. tostring(device.json.success));
            domoticz.log(device.data);

        -- Door/Window/Motion sensors
        else
            if (domoticz.security == domoticz.SECURITY_DISARMED or not device.active) then
                return;
            end
            
            local notificationSubject = 'Cambrioleur entré : ' .. device.name;
            if (device.name == devicesNames.frontDoor) then
                domoticz.devices(devicesNames.alarmSwitchFrontDoor).switchOn().afterSec(alarmSwitchFrontDoorDelay);
                domoticz.log('Front door open while security is armed. Triggering alarm in ' .. alarmSwitchFrontDoorDelay .. 'sec');
            else
                domoticz.devices(devicesNames.siren).dimTo(sirenLevel);
                domoticz.notify(notificationSubject, notificationSubject, domoticz.PRIORITY_EMERGENCY);
                domoticz.log(notificationSubject);
            end
            
        end
        
    end
}
