function DisplayImageTest(image_type)
    %% Set experiment constants

    %Timing (in seconds)              
    FIX_DUR     = 0.3; %Length of trial-initial fixation
    IMG_DUR   = 2.0; %Amount of time image is shown for
    ITI         = 0.2; %Inter-trial interval
    
    switch image_type
        case 'sentences'
        
        case 'stills'
            
    end
    
	%% Set up screen and keyboard for Psychtoolbox
    %Screen
    screenNum = max(Screen('Screens'));  %Highest screen number is most likely correct display
    windowInfo = PTBhelper('initialize',screenNum);
	wPtr = windowInfo{1}; %pointer to window on screen that's being referenced
    rect = windowInfo{2}; %dimensions of the window
        winWidth = rect(3);
        winHeight = rect(4);
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
    
    %% Load up files into cells
    img_files = fullfile(pwd, 'images');
    img_files = fullfile(img_files, image_type);
    
    
    
    %% Present the experiment
	% Wait indefinitely until trigger
    PTBhelper('stimText',wPtr,'Waiting for trigger...',sentFontSize);
    PTBhelper('waitFor','TRIGGER',kbIdx,escapeKey);
    
    runOnset = GetSecs; %remains the same
    onset = runOnset;   %updates for each trial
    fixEndTime = onset + 10;
    
    %Present each block
    try           
        
        %Image
        IMAGE_DIR = img_files;
        image = 'Agent_passive_1.jpg';
        image = fullfile(IMAGE_DIR, image);
        image = imread(image, 'JPG');
        image = imresize(image, [winHeight, NaN]);
        imgStim = cell(1,1);
        imgStim{1} = Screen('MakeTexture', wPtr, double(image));
        PTBhelper('stimImage', wPtr, 1, imgStim);
        %global foo;
        %foo = Screen('MakeTexture', wPtr, double(imread(image, 'JPG')));
        imgEndTime = fixEndTime + IMG_DUR;
        PTBhelper('waitFor',imgEndTime,kbIdx,escapeKey);

        %Blank ITI
        PTBhelper('stimText', wPtr, ' ', sentFontSize);
        blankEndTime = imgEndTime + ITI;
        PTBhelper('waitFor',blankEndTime,kbIdx,escapeKey);
          


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

%% %% Debugging functions
function [wPtr, rect] = openDebugWindow(screenNum, rect)
    Screen('CloseAll');
    ShowCursor;
    clear Screen
    
    rect = rect / 2;
    rect(1) = 5;
    rect(2) = 5;

    java; %clear java cache
    KbName('UnifyKeyNames');
    warning('off','MATLAB:dispatcher:InexactMatch');
    AssertOpenGL;
    suppress_warnings = 1;
    Screen('Preference', 'SuppressAllWarnings', suppress_warnings);
    Screen('Preference', 'TextRenderer', 0);
    Screen('Preference', 'SkipSyncTests', 1);
    [wPtr,rect] = Screen('OpenWindow',screenNum,1,rect,[],[],[],[],[],kPsychGUIWindow,[]);
end

