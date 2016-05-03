function waitUntilTime( kbIdx, escape, time )
%waitUntilTime
%   waits until the given system time in seconds
%   allows user to abort with escape key

    while GetSecs < time
        [~, ~, keyCode] = KbCheck(kbIdx);
        
        %Exit if escape key is pressed
        if ismember(find(keyCode==1), escape)
            Screen('CloseAll');
            ShowCursor;
            error('escape!');
        end
        
    end
end

