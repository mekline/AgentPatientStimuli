function AgentPatientStimuliScratch(subjID, order, run)
    %% Make sure inputs are valid
    %Raise an error if subjID is not a string
    assert(ischar(subjID), 'subjID must be a string');

    %AE is whatever it's supposed to be
    assert(ismember(order, ['A','B','C','D','E']), 'order must be a letter A-E');

    %run is 1 or 2
    assert(ismember(run, 1:2), 'run must be 1 for the first run and 2 for the second');
    
    %% Make sure we don't accidentally overwrite a data file
    %This is where the data file will go
    DATA_DIR = fullfile(pwd, 'data');
    %This is what we'll call the data file we're making
    fileToSave = ['AgentPatientStimuli' subjID '_' order num2str(run) '_data.csv'];
    %The file should be in the DATA_DIR folder
    fileToSave = fullfile(DATA_DIR, fileToSave);
    
    % Error message if data file already exists.
    if exist(fileToSave,'file') && ~strcmpi(subjID, 'debug')
        str = input('The data file already exists for this subject! Overwrite? (y/n)','s');
        if ~isequal(str,'y')
            error('The data file already exists for this subject!');
        end
	end
    
        
    %% Set experiment constants

    %Timing (in seconds)              
    FIX_DUR     = 0.3; %Length of trial-initial fixation
    SENT_DUR   = 2.0; %Amount of time sentence is shown for
    ITI         = 0.2; %Inter-trial interval

    %% Set up orders
    
    %Each csv in ORDER_DIR was generated by optseq2 using these arguments
    %--ntp 720  (number of time points)
    %--tr 2 (time rate - smallest time unit)
    %--tprescan 0 (no idea)
    %--psdwin 0 12 (this is a response thing, don't think we need it)
    %--ev Active 6 60 (event condition, max time (multiple of tr) we can
    %show it for, number of times it should come up)
    %--ev Passive 6 60 (see above)
    %--nkeep 10 (how many orderings to keep)
    %--o ORDER (what to name output files; doesn't matter because we
    %renamed them anyway)
    %--nsearch 10000 (how many orderings to try)
    
    %This has all the info
    ORDER_DIR = fullfile(pwd, 'orders');
    
    order_filename = ['AgentPatientStimuli_Order' order num2str(run) '.csv'];
    order_filename = fullfile(ORDER_DIR, order_filename);
    all_materials = readtable(order_filename); %the order for this run
    
    numEvents = height(all_materials); %the number of trials and fixations
    
    %% Make the experiment run faster if subjID is 'debug'
    if strcmpi(subjID, 'debug')
        scale = 0.1;
        FIX_DUR = FIX_DUR * scale;
        SENT_DUR = SENT_DUR * scale;
        ITI = ITI * scale;
        
        all_materials.Onset = all_materials.Onset * 0.1;
        all_materials.Duration = all_materials.Duration * 0.1;
    end
    
    %% Read in the stimuli materials
    MATERIALS_DIR = fullfile(pwd, 'materials'); %where to put the saved materials
    mat_filename = ['AgentPatientStimuli_' subjID '_' order '_materials.mat']; %materials to save
    mat_filename = fullfile(MATERIALS_DIR, mat_filename);
    
    %If this is the first run for this subjectID, read in the raw materials
    %from the order materials file as a table and save them to a .mat file
    if run==1
        %Read in all materials from a csv
        materials_filename = ['AgentPatientStimuli_Order' order num2str(run) '.csv'];
        materials_filename = fullfile(ORDER_DIR, materials_filename);
        all_materials = readtable(materials_filename); %the materials are now a table
        
        %Save the materials to a matfile
        save(mat_filename, 'all_materials');
        
    end
    
    %Load the all_materials table from the mat file
    %If the mat file doesn't exist, make sure the user entered the correct
    %inputs
    try
         load(mat_filename);
         
    catch errorInfo
         fprintf('%s%s\n\n', 'error message: ', errorInfo.message)
         
         error('\n%s\n\t%s\n\t%s\n', ...
               'Please make sure the following conditions are met:', ...
               '1) subjID is the same for run 1 and run 2', ...
               '2) run is 1 for the first run and 2 for the second');
    end
     
    %Set up the data that we want to save
     resultsHdr = {'SubjID',        'Run',       'Order',   'Onset', ...
                   'Duration',      'Condition', 'Flip',    'Sentence'};
 	
     %results is the table that will hold all of the data we want to save
     %results = cell(numEvents, length(resultsHdr));
     %results = cell2table(results, 'VariableNames', resultsHdr);
    
    %Fill in the user input information
    results.SubjID(:) = {subjID};
	results.Run   = ones(numEvents,1)*run;
    results.Order = ones(numEvents,1)*order;
    
    for eventNum=1:numEvents
        results.Condition{eventNum} = all_materials.Condition(eventNum)
        results.Flip{eventNum} = all_materials.Flip(eventNum)
    end
    
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
    
%       if strcmpi(subjID, 'debug')
%           [wPtr, rect] = openDebugWindow(screenNum, rect);
%           winWidth = rect(3);
%           winHeight = rect(4);
%       end
    
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
    
    %Present each block
    try
        for eventNum = 1:numEvents
            condition = all_materials.Condition(eventNum);
            
            %Fixation
            if strcmp(condition, 'NULL ')
                %Show fixation cross
                duration = all_materials.Duration(eventNum);
                PTBhelper('stimText', wPtr, '+', fixFontSize);
                fixEndTime = onset + duration;
                PTBhelper('waitFor',fixEndTime,kbIdx,escapeKey);
                
                %Save data
                results.Sentence{eventNum} = 'N/A';
                results.Onset{eventNum} = onset - runOnset;
                results.Duration{eventNum} = duration;
                
                %Update loop variables
                onset = fixEndTime;
                
                continue
            end
            
            if char(all_materials.Flip(item_index)) == '0'
                sentence = char([char(all_materials.ProgressiveActive(item_index)) ' (' char(all_materials.Condition(item_index)) ' highlight)']);
            elseif char(all_materials.Flip(item_index)) == '1'
                sentence = char([char(all_materials.ProgressivePassive(item_index)) ' (' char(all_materials.Condition(item_index)) ' highlight)']);
            end
            
            results.Sentence{eventNum} = sentence;
            results.Onset{eventNum} = onset - runOnset;
            results.Duration{eventNum} = all_materials.Duration(eventNum);

            
                  
            %Show trial
            %Trial-initial fixation
            PTBhelper('stimText', wPtr, '+', fixFontSize);
            fixEndTime = onset + FIX_DUR;
            PTBhelper('waitFor',fixEndTime,kbIdx,escapeKey);
            
            %Sentence
            PTBhelper('stimText', wPtr, sentence, sentFontSize);
            sentEndTime = fixEndTime + SENT_DUR;
            PTBhelper('waitFor',sentEndTime,kbIdx,escapeKey);
            
            %Blank ITI
            PTBhelper('stimText', wPtr, ' ', sentFontSize);
            blankEndTime = sentEndTime + ITI;
            PTBhelper('waitFor',blankEndTime,kbIdx,escapeKey);
            
            %Update loop variables
            item_index = item_index + 1;
            onset = sentEndTime;
        
        end

        ran_completely = true;
        
    catch errorInfo
        ran_completely = false;
        
        fprintf('%s%s\n\n', 'error message: ', errorInfo.message)
        for k=1:length(errorInfo.stack)
            disp(errorInfo.stack(k))
        end
    end
    
    %Save all data
	writetable(results, fileToSave);
    
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

