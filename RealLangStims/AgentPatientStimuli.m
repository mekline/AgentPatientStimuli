%AgentPatientStimuli.m
%
%Agent/patient task 
%  
%
%DESCRIPTION
%In this experiment, participants are presented with sentences about agents
%and patients.
%
% Function call: AgentPatientStimuli(subjID, list, order, run)
%                eg. AgentPatientStimuli('test', 1, 1, 1)
%
% RUNTIME: 360 sec (6 min, 180 TRs)
%          runs 10x faster if subID is 'debug'
%
% Inputs:
%   -subjID: string of subject ID (eg. 'subj01') MUST BE THE SAME FOR RUN 1 AND RUN 2
%   -list:   1-4, subset of materials to use     MUST BE THE SAME FOR RUN 1 AND RUN 2
%   -order:  1-8, determines condition block orders
%   -run:    1 for the first run, 2 for the second run
%
% Output: 
%   -csv containing subject and run information
%       (data/AgentPatientStimuli_subjID_list_order_run_data.csv)
%
% Go to DISPLAY OPTIONS section to change things like font size, etc.
%
%
% 2016-02-01: created (Zach Mineroff - zmineroff@gmail.com)
%             With help from PTBhelper, written by
%                * Walid Bendris - wbendris@mit.edu

function AgentPatientStimuli(subjID, list, order, run)
    %% Make sure inputs are valid
    %subjID is a string
	assert(ischar(subjID), 'subjID must be a string');
    
    %list is 1 - 4 (must be the same across the 2 runs; checked later)
    assert(ismember(list, 1:4), 'list must be 1 - 4');
    
    %order is 1 - 8
    assert(ismember(order, 1:8), 'order must be 1 - 8');
    
    %run is 1 or 2
    assert(ismember(run, 1:2), 'run must be 1 for the first run and 2 for the second');
    
    
    %% Make sure we don't accidentally overwrite a data file
	DATA_DIR = fullfile(pwd, 'data');
	fileToSave = ['AgentPatientStimuli' subjID '_list' num2str(list) ...
                  '_order' num2str(order) '_run' num2str(run) '_data.csv'];
    fileToSave = fullfile(DATA_DIR, fileToSave);
    
	% Error message if data file already exists.
	if exist(fileToSave,'file') && ~strcmpi(subjID, 'debug')
        str = input('The data file already exists for this subject! Overwrite? (y/n)','s');
        if ~isequal(str,'y')
            error('The data file already exists for this subject!');
        end
	end
    
    
    %% Set experiment constants
    %Number of events
    NUM_TRIALS     = 60;  %Number of non-fixation trials for 1 run
    NUM_CONDITIONS = 1;
    
	%Timing (in seconds)              
    FIX_DUR     = 0.3; %Length of trial-initial fixation
    SENT1_DUR   = 2.0; %Amount of time sentence 1 is shown for
    ITI         = 0.2; %Inter-trial interval
    SENT2_DUR   = 2.0; %Amount of time sentence 2 is shown for
    RESPOND_DUR = 1.5; %Amound of time respond screen is shown for
    
    %Language stimuli
    SENTENCE = 'Kyle Square bounced Lily Triangle agent highlight.';
    QUESTION = 'Did Kyle Square bounce someone?';
    
    
    %% Set up condition ordering
    ORDER_DIR = fullfile(pwd, 'orders');
    
    %Each csv in ORDER_DIR was generated by optseq2 using these arguments
    %--ntp 180
    %--tr 2
    %--tprescan 0
    %--psdwin 0 12
    %--ev ActPas_SEM_DIFF 6 5
    %--ev ActPas_SEM_SAME 6 5
    %--ev ActPas_SYNT_DIFF 6 5
    %--ev ActPas_SYNT_SAME 6 5
    %--ev DOPP_SEM_DIFF 6 5
    %--ev DOPP_SEM_SAME 6 5
    %--ev DOPP_SYNT_DIFF 6 5
    %--ev DOPP_SYNT_SAME 6 5
    %--nkeep 8
    %--o ORDER
    %--nsearch 1000
    
    %To adapt to AgentPatientStimuli, use these arguments
    %--ntp 180 (items/2 plus a minute (at least, in general) of fixation)
    %--tr 2
    %--tprescan 0
    %--psdwin 0 12
    %--ev ActPas_SEM_DIFF 6 40
    %--nkeep 1
    %--o ORDER
    %--nsearch 1000 (??, but doesn't seem too condition-dependent)
    
    order_filename = ['AgentPatientStimuli_Order' num2str(order) '.csv'];
    order_filename = fullfile(ORDER_DIR, order_filename);
    order_filename
    run_order = readtable(order_filename);  %the order for this run
    
    numEvents = height(run_order); %the number of trials and fixations
    
    
    %% Make the experiment run faster if subjID is 'debug'
    if strcmpi(subjID, 'debug')
        scale = 0.1;
        FIX_DUR = FIX_DUR * scale;
        SENT1_DUR = SENT1_DUR * scale;
        ITI = ITI * scale;
        SENT2_DUR = SENT2_DUR * scale;
        RESPOND_DUR = RESPOND_DUR * scale;
        
        run_order.Onset = run_order.Onset * 0.1;
        run_order.Duration = run_order.Duration * 0.1;
    end
    
    
    %% Read in the stimuli materials
    MATERIALS_DIR = fullfile(pwd, 'materials');
    mat_filename = ['AgentPatientStimuli' subjID '_list' num2str(list)  '_materials.mat'];
    mat_filename = fullfile(MATERIALS_DIR, mat_filename);
    
    %If this is the first run for this subjectID, read in the materials
    %from the materials file and save them to a .mat file
    if run==1
        %Read in all materials from a csv
        materials_filename = 'AgentPatientStimuli_materials.csv';
        all_materials = readtable(materials_filename);
 
        
        %"conditions" is a cell array containing the condition name for
        %each item in the order they appear in all_materials
        conditions = all_materials.COND_markingSameDiff;
        
        conditionNames ={'ActPas_SEM_DIFF'};
                     
	%Separate each condition into different tables and store each table in
	%a struct called "materials"
        for i=1:length(conditionNames)
            %Determine which rows in all_materials are for this condition
            condition_rows = strcmp(conditions, conditionNames{i});
            
            %Extract the materials for this condition from all_materials
            %and save this sub-table to the struct "materials"
            materials.(conditionNames{i}) = all_materials(condition_rows, :);
            
            %Randomize the order of the table
            materials.(conditionNames{i}) = randomizeTable(materials.(conditionNames{i}));
        end
        
        %So now "materials" is a struct containing 8 tables (one for each
        %condition in the cell array "conditionNames"). Each table has been
        %put into a random order using the function randomizeTable. To
        %access a table for a specific condition, you can do (e.g.)
        %materials.ActPas_SEM_DIFF
        
        %Save the materials to a matfile
        save(mat_filename, 'materials');
    end
    
    %Load the materials from the mat file
    %If the mat file doesn't exist, make sure the user entered the correct
    %inputs
    try
        load(mat_filename);
        
    catch errorInfo
        fprintf('%s%s\n\n', 'error message: ', errorInfo.message)
        
        error('\n%s\n\t%s\n\t%s\n\t%s\n', ...
              'Please make sure the following conditions are met:', ...
              '1) subjID is the same for run 1 and run 2', ...
              '2) run is 1 for the first run and 2 for the second', ...
              '3) list is the same for run 1 and run 2');
    end
    
    %Use the first itemsPerCondition (a number) rows of each table for run 1; the second 5 for run 2
    itemsPerCondition = NUM_TRIALS / NUM_CONDITIONS;    %5
    if run==1
        rowsToUse = [1:itemsPerCondition];
    else
        rowsToUse = [itemsPerCondition+1:itemsPerCondition*2];
    end
    
    conditionNames = fieldnames(materials);
    for i=1:length(conditionNames)
        materials.(conditionNames{i}) = materials.(conditionNames{i})(rowsToUse, :);
    end
    
    
    %Fill in the user input information
    results.SubjID(:) = {subjID};
    results.List  = ones(numEvents,1)*list;
	results.Run   = ones(numEvents,1)*run;
    results.Order = ones(numEvents,1)*order;
    
    %Fill in the info we already know
    %trialNum and the indices of each condition start at 1
    trialNum = 1;
    for i=1:length(conditionNames)
        conditionIndex.(conditionNames{i}) = 1;
    end
    
    for eventNum = 1:numEvents
        %onset = run_order.Onset(eventNum);
            %We'll save the onsets as we go so that we get the real onsets
            %rather than the theoretical ones
        
        condition = run_order.Condition(eventNum);
        
        %Fill in info for fixation events
        %I don't know why this little block has to be here but it just does
        if strcmp(condition, 'NULL')
            continue
        end
        
        %Fill in the info for trial events
        curr_materials = materials.(condition{:});
        condIdx = conditionIndex.(condition{:});
        
        item = curr_materials.Item(condIdx);
        
        %Update loop variables
        trialNum = trialNum + 1;
        conditionIndex.(condition{:}) = condIdx + 1;
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
    
    %Respond screen
    respondText = 'RESPOND';
    
    
	%% Set loop variables
    %The indices of each condition start at 1
    for i=1:length(conditionNames)
        conditionIndex.(conditionNames{i}) = 1;
    end
    
    
    %% Present the experiment
	% Wait indefinitely until trigger
    PTBhelper('stimText',wPtr,'Waiting for trigger...',sentFontSize);
    PTBhelper('waitFor','TRIGGER',kbIdx,escapeKey);
    
    runOnset = GetSecs; %remains the same
    onset = runOnset;   %updates for each trial
    
    %Present each block
    try
        for eventNum=1:numEvents
            condition = run_order.Condition(eventNum);
            
            %Fixation
            if strcmp(condition, 'NULL')
                %Show fixation cross
                duration = run_order.Duration(eventNum);
                PTBhelper('stimText', wPtr, '+', fixFontSize);
                fixEndTime = onset + duration;
                PTBhelper('waitFor',fixEndTime,kbIdx,escapeKey);
                
                %Save data
                results.Onset{eventNum} = onset - runOnset;
                
                %Update loop variables
                onset = fixEndTime;
                
                continue
            end
            
            %Determine which table to use for the trial
            curr_materials = materials.(condition{:});
            condIdx = conditionIndex.(condition{:});
            
            sentence1 = curr_materials.ProgressiveSentence{condIdx};
            
            %Show trial
            %Trial-initial fixation
            PTBhelper('stimText', wPtr, '+', fixFontSize);
            fixEndTime = onset + FIX_DUR;
            PTBhelper('waitFor',fixEndTime,kbIdx,escapeKey);
            
            %Sentence 1
            PTBhelper('stimText', wPtr, sentence1, sentFontSize);
            sent1EndTime = fixEndTime + SENT1_DUR;
            PTBhelper('waitFor',sent1EndTime,kbIdx,escapeKey);
            
            %Blank ITI
            PTBhelper('stimText', wPtr, ' ', sentFontSize);
            blankEndTime = sent1EndTime + ITI;
            PTBhelper('waitFor',blankEndTime,kbIdx,escapeKey);
            
            %Respond screen
            respondEndTime = sent1EndTime + RESPOND_DUR;

            
            %Update loop variables
            conditionIndex.(condition{:}) = condIdx + 1;
            onset = respondEndTime;
        end
        
        ran_completely = true;
        
    catch errorInfo
        ran_completely = false;
        
        fprintf('%s%s\n\n', 'error message: ', errorInfo.message)
        for k=1:length(errorInfo.stack)
            disp(errorInfo.stack(k))
        end
    end
    
	%runtime = GetSecs - runOnset;
    
    %Save all data
	%writetable(results, fileToSave);
    
    %Close the PTB screen
	Screen('CloseAll');
	ShowCursor;
    
    %Restore the old level.
    Screen('Preference','SuppressAllWarnings',oldEnableFlag);
    
    %Tell the user what the command should be for the second run
    if run == 1 && ran_completely
        fprintf('\n\n%s%s\n\n', 'Run 1 finished for: ', subjID);
        fprintf('%s\n', 'Run 2 command should be: ');
        fprintf('\t%s%s%s%d%s%d%s\n\n', 'AgentPatientStimuli(''', subjID, ''', ', list, ', <ORDER>, ', 2, ')')
    end
end




%% RandomizeTable
%Randomizes the order of the rows in table table_in
function [randomized_table] = randomizeTable(table_in)
    numItems = height(table_in);
    
    %Shuffle the materials randomly
    randomized_table = table_in(randperm(numItems), :);
end



%% Debugging functions
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
