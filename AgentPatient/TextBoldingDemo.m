function TextBoldingDemo

    agent = 'Kyle Square';
    bold_agent = agent;
    %bold_agent.FontWeight = 'bold';
    verb = 'is bouncing';
    patient = 'Melissa Oval';
    bold_patient = patient;
    %bold_patient.FontWeight = 'bold';
    
    %% Set up screen and keyboard for Psychtoolbox
    %Screen
    screenNum = max(Screen('Screens'));  %Highest screen number is most likely correct display
    windowInfo = PTBhelper('initialize',screenNum);
	wPtr = windowInfo{1}; %pointer to window on screen that's being referenced
%     rect = windowInfo{2}; %dimensions of the window
%         winWidth = rect(3);
%         winHeight = rect(4);
    oldEnableFlag = windowInfo{4};
    HideCursor;
    PTBhelper('stimImage',wPtr,'WHITE');
    PTBhelper('stimText',wPtr,'Loading experiment\n\n(Don''t start yet!)',30);
    
    %Keyboard
    keyboardInfo = PTBhelper('getKeyboardIndex');
    kbIdx = keyboardInfo{1};
    escapeKey = keyboardInfo{2};
    
    
    %% Set display options
    %Font sizes
    sentFontSize = 40;      %stimuli sentences
    fixFontSize = 40;       %fixation cross

    
    %% Present the experiment
	% Wait indefinitely until trigger
    PTBhelper('stimText',wPtr,'Waiting for trigger...',sentFontSize);
    PTBhelper('waitFor','TRIGGER',kbIdx,escapeKey);
    
    runOnset = GetSecs; %remains the same
    onset = runOnset;   %updates for each trial
    item_index = 1;
    
    SENT_DUR = 100.0;
    
    %Present each block
    try
                
        %Sentence
        
        sentence = [agent ' ' verb ' ' patient '.'];
        PTBhelper('stimText', wPtr, sentence, sentFontSize);
        sentEndTime = onset + SENT_DUR;
        PTBhelper('waitFor',sentEndTime,kbIdx,escapeKey);
         

        ran_completely = true;
        
    catch errorInfo
        ran_completely = false;
        
        fprintf('%s%s\n\n', 'error message: ', errorInfo.message)
        for k=1:length(errorInfo.stack)
            disp(errorInfo.stack(k))
        end
    end
    
    
     %Close the PTB screen
	Screen('CloseAll');
	ShowCursor;
    
    %Restore the old level.
    Screen('Preference','SuppressAllWarnings',oldEnableFlag);
    

end