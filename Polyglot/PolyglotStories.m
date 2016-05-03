%PolyglotStories.m
%
%DESCRIPTION
% Plays normal and quilted versions of spoken Bible verses in various
% languages.
%
%TIMING
% Trial blocks: 16 (16 seconds each)
% Fixation blocks: 3 (12 seconds each)
% Total runtime: 292 seconds (4:52)
% IPS: 146 %same as TR; 1/2 number of seconds
% 
%HOW TO RUN
% 1) Choose which langauges to use for a subject by opening
%    'LanguagesToUse.csv' and adding a line for the subject. If you leave a
%    language slot blank, it will be replaced with music/environment
%    sounds. Type 'viewAvailableLanguages' in the MATLAB command line to
%    see which languages we have audio files for.
%
% 2) Call this function from the MATALAB command line. The input 'subjID'
%    must be the same as the subject ID used in 'LangaugesToUse.csv'. You
%    must also do run 1 first. The randSeed argument is optional.
%
%FUNCTION CALL
% PolyglotStories( subjID, run, conditionOrder, randSeed )
%
%   - subjID
%       string of the subjectID, must be set in LanguagesToUse.csv
%
%   - run
%       run number (1-8), MUST do run 1 first
%
%   - conditionOrder
%       condition block ordering (1-8)
%
%   - randSeed (optional)
%       if left unset, uses system time as random seed
%
%
%CHANGE LOG
% 2016-04-12: created (Zach Mineroff - mineroff@mit.edu)
%
%

function PolyglotStories( subjID, run, conditionOrder, randSeed )
    %% Inputs and output file
    %Seed with system time if randSeed is not given
    oldRandSettings = rng;
    if nargin < 4
        rng('shuffle');
        currRandSettings = rng;
        randSeed = double(currRandSettings.Seed);
    else
        rng(randSeed);
    end
    
    %Store the inputs as a struct and make sure they're valid
    inputs.subjID = subjID;
    inputs.randSeed = randSeed;
    inputs.run = run;
    inputs.conditionOrder = conditionOrder;
    
    validateInputs(inputs);
    %make sure all the inputs are of the right type
    
    %Get a string of the filename we want to save
	dataFileToSave = getDataFilename(inputs);
    
    
    %% Set experiment parameters
    %Timing (in seconds)
    DURATION.fix   = 12; %Length of fixation
    DURATION.audio = 16; %Length of an audio trial
    
    %Display options
    screenColor = [255, 255, 255]; %an rgb array
    fontSize = 40;
    
    
	%% Read in materials
	materialsDir = fullfile(pwd, 'materials');
	matFilename  = fullfile(materialsDir, [subjID '_materials.mat']);
    
    %Set up the materials for all runs on the first run
	if run == 1
        if ~exist(materialsDir, 'dir')
            mkdir(materialsDir);
        end
        createSubjMaterials(subjID, matFilename);
	end
    try
        load(matFilename)
    catch
        error('You must do run 1 first!');
    end
    
	materials = subjMaterials.(['run', num2str(run)]);
    
    
	%% Set up condition order
	conditionBlocks = setBlockOrder(conditionOrder);
	
    numTrials = length(conditionBlocks); %including fixation
    
    
    
    %% Set up the data that we want to save
    results = createResultsTable(inputs, materials, conditionBlocks);
    
    %% Get trial start times
    trialOnsets = trialOnsetTimes(conditionBlocks, DURATION);
    
    
    %% Set up screen and keyboard for Psychtoolbox
    %screen
    [~, wPtr, oldEnableFlag] = openPTBscreen(screenColor);
    Screen('TextSize', wPtr ,fontSize);
    
    loadingText = 'Loading experiment\n\n(Don''t start yet!)';
    displayText(wPtr, loadingText);
    
    
    %keyboard
    [~, Button, kbIdx] = setUpPTBkeyboard();
    
    
    %% Set up audio files
    [pahandle, buffers] = setUpAudioFiles(conditionBlocks, materials);
    
    %time it takes to fill the audio buffer (seconds)
    fillBufferTime = 0.05;
    
    %seconds before starting/stoping audio that you can escape the experiment
    audioQueueTime = 0.5;
    
    %Fill buffer with first audio file
    soundNum = 1;
    PsychPortAudio('FillBuffer', pahandle, buffers(soundNum));
    
    
    %% Wait for trigger
    waitingText = 'Waiting for trigger...';
    displayText(wPtr, waitingText);
    waitForTrigger(kbIdx, Button.trigger, Button.escape);
    
    runOnset = GetSecs;
    trialOnsets = trialOnsets + runOnset;
    
    
    %% Present the trials
    %show fixation cross
    displayText(wPtr, '+');
    
    try
        for trialNum = 1:numTrials
            condition = conditionBlocks{trialNum};
            trialOnset = trialOnsets(trialNum);
            
            %fixation
            if strcmp(condition, 'Fix')
                waitUntilTime(kbIdx, Button.escape, trialOnset);
                
                actualFixStart = GetSecs;
                results.onset{trialNum} = actualFixStart - runOnset;
                
                lastEscapeTime = trialOnset+DURATION.fix-audioQueueTime;
                waitUntilTime(kbIdx, Button.escape, lastEscapeTime);
                continue;
            end
            
            %start audio
            actualAudioStart = PsychPortAudio('Start', pahandle, [], trialOnset, 1);
            
            %end a little early so we can load  & start the next one on time
            audioEndTime = trialOnset + DURATION.audio - fillBufferTime;
            
            results.onset{trialNum} = actualAudioStart - runOnset;
            
            lastEscapeTime = trialOnset+DURATION.audio-audioQueueTime;
            waitUntilTime(kbIdx, Button.escape, lastEscapeTime);
            
            PsychPortAudio('Stop', pahandle, 1, [], [], audioEndTime);
            
            %buffer the next audio file
            soundNum = soundNum + 1;
            if soundNum <= length(buffers)
                PsychPortAudio('FillBuffer', pahandle, buffers(soundNum));
            end
        end
    
    catch errorInfo
        fprintf('\n\n%s%s\n\n', 'error message: ', errorInfo.message)
        for k=1:length(errorInfo.stack)
            disp(errorInfo.stack(k))
        end
        
        fprintf('\n%s%d\n\n', 'Run stopped during trial ', trialNum);
    end
    
    
    %% Done
    %Save all behavioral data to csv
	writetable(results, dataFileToSave);
    
    %Close the PTB screen and audio port
	Screen('CloseAll');
    PsychPortAudio('Close');
	ShowCursor;
    
    %Restore the old level.
    Screen('Preference','SuppressAllWarnings',oldEnableFlag);
    rng(oldRandSettings);
end

