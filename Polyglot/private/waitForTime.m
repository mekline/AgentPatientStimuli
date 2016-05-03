function waitForTime(kbIdx, escape, duration)
%waitForTime
%   waits for the given duration in seconds
%   like PTB's built-in WaitSecs, but allows user to abort with escape key

    startTime = GetSecs;
    
    while GetSecs < startTime + duration
        [~, ~, keyCode] = KbCheck(kbIdx);
        
        %Exit if escape key is pressed
        if ismember(find(keyCode==1), escape)
            Screen('CloseAll');
            ShowCursor;
            error('escape!');
        end
    end
end