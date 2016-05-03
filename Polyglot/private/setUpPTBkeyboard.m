function [keyNames, Button, kbIdx] = setUpPTBkeyboard()
%setUpPTBkeyboard

	KbName('UnifyKeyNames');
    keyNames = KbName('KeyNames');
    
    %Possible triggers
    Button.trigger = [KbName('=+') KbName('+')];
    
    %Escape key
    Button.escape = KbName('Escape');
    
    %kbIdx (index of keyboard for capturing button box input)
	if IsWin || IsLinux
        kbIdx = 0;
    else
        devices = PsychHID('devices');
        kbIdx = [];
        for dev = 1:length(devices)
            if strcmp(devices(dev).usageName, 'Keyboard')
                kbIdx = [kbIdx dev];
            end
        end
    end
    
end

