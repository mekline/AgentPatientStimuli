function AgentPatientStimuliScratch(subjID, order, run)
    %% Make sure inputs are valid
    %subjID is a string
    assert(ischar(subjID), 'subjID must be a string');

    %AE is whatever it's supposed to be


    %run is 1 or 2
    assert(ismember(run, 1:2), 'run must be 1 for the first run and 2 for the second');
    
    %% Make sure we don't accidentally overwrite a data file
    DATA_DIR = fullfile(pwd, 'data');
    fileToSave = ['AgentPatientStimuli' subjID '_' order num2str(run) '_data.csv'];
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
    %--ntp 720
    %--tr 2
    %--tprescan 0
    %--psdwin 0 12
    %--ev Stimulus 6 120
    %--nkeep 10
    %--o ORDER
    %--nsearch 10000
    
    ORDER_DIR = fullfile(pwd, 'orders');
    
    order_filename = ['AgentPatientStimuli_Order' order num2str(run) '.csv'];
    order_filename = fullfile(ORDER_DIR, order_filename);
    run_order = readtable(order_filename); %the order for this run
    
    numEvents = height(run_order); %the number of trials and fixations
    
    %% Make the experiment run faster if subjID is 'debug'
    if strcmpi(subjID, 'debug')
        scale = 0.1;
        FIX_DUR = FIX_DUR * scale;
        SENT_DUR = SENT_DUR * scale;
        ITI = ITI * scale;
        
        run_order.Onset = run_order.Onset * 0.1;
        run_order.Duration = run_order.Duration * 0.1;
    end
    
    %% Read in the stimuli materials
    MATERIALS_DIR = fullfile(pwd, 'materials'); %where to put the saved materials
    mat_filename = ['AgentPatientStimuli_' subjID '_' order '_materials.mat']; %materials to save
    mat_filename = fullfile(MATERIALS_DIR, mat_filename);
    
    %If this is the first run for this subjectID, read in the materials
    %from the materials file and save them to a .mat file
    if run==1
        %Read in all materials from a csv
        materials_filename = 'AgentPatientStimuli_materials.csv';
        all_materials = readtable(materials_filename);
        
        %Randomize the order of the table
        all_materials = randomizeTableAndFlip(all_materials);
        
        %Save the materials to a matfile
        save(mat_filename, 'all_materials');
        
    end
    
    %Load the materials from the mat file
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
     
    if run==2
        all_materials.Flip = abs(all_materials.Flip - ones(height(all_materials),1));
        all_materials.Flip
    end
    
    %% %% randomizeTableAndFlip
%Randomizes the order of the rows in table table_in and determines random
%flip conditions
function [randomized_table] = randomizeTableAndFlip(table_in)
    itemsInTable = height(table_in);
    
    %Shuffle the materials randomly
    randomized_table = table_in(randperm(itemsInTable), :);
    
    %Add flip conditions
    flip_column = [zeros(itemsInTable/2,1);ones(itemsInTable/2,1)];
    randomized_table.Flip = flip_column;
    
    %Shuffle again
    randomized_table = randomized_table(randperm(itemsInTable), :);
    
end
    
    
    
end