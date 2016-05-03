function waitForTrigger(kbIdx, trigger, escape)
%waitForTrigger
%   waits for trigger from scanner before startgin experiment

    while true
        %Check which buttons are pressed
        [~, ~, keyCode] = KbCheck(kbIdx);
        
        %Continue if trigger
        if ismember(find(keyCode==1), trigger)
            break;
        end;
        
        %Exit if escape key is pressed
        if ismember(find(keyCode==1), escape)
            Screen('CloseAll');
            ShowCursor;
            error('escape!');
        end
    end
end
