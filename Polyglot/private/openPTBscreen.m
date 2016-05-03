function [screenNum, wPtr, oldEnableFlag] = openPTBscreen(screenColor)
%openPTBscreen
    
    %% Perform some PTB checks
    java; %clear java cache
	warning('off','MATLAB:dispatcher:InexactMatch');
    AssertOpenGL;
    
    %% Set up screen
    %Set screen preferences
    Screen('Preference','VisualDebugLevel', 0);
    suppressWarnings = 1;
    oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', suppressWarnings);
    Screen('Preference', 'TextRenderer', 0);
    Screen('Preference', 'SkipSyncTests', 1);
    
    %Open a window
    screenNum = max(Screen('Screens'));  %Highest screen number is most likely correct display
    wPtr = Screen('OpenWindow', screenNum, screenColor);
    
	HideCursor;
end

