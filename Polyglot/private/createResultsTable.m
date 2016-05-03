function [results] = createResultsTable(inputs, materials, conditionBlocks)
%createResultsTable
%	Sets up the data table we want to save

    %unpack the inputs structure
    subjID = inputs.subjID;
    randSeed = inputs.randSeed;
    run = inputs.run;
    conditionOrder = inputs.conditionOrder;
    
    numTrials = length(conditionBlocks);

    resultsHdr = {'subjID', 'randSeed', 'run', 'order', 'trialNum', ...
                  'condition', 'audioFile', 'onset'};
	
    %results is the table that will hold all of the data we want to save
    results = cell(numTrials, length(resultsHdr));
    results = cell2table(results, 'VariableNames', resultsHdr);
    
    %Fill in the user input information
    results.subjID(:) = {subjID};
    results.randSeed = ones(numTrials,1)*randSeed;
	results.run   = ones(numTrials,1)*run;
    results.order   = ones(numTrials,1)*conditionOrder;
    
    %Fill in the info we already know
    results.trialNum = (1:numTrials)';
    results.condition = conditionBlocks';
    
    for trialNum = 1:numTrials
        condition = conditionBlocks{trialNum};
        
        if strcmp(condition, 'Fix')
            results.audioFile{trialNum} = 'NA';
            
        else
            results.audioFile{trialNum} = materials.(condition);
        end
    end
    
end

