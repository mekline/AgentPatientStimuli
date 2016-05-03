function validateInputs(inputs)
%validateInputs
%   makes sure all user inputs won't crash the program later

	subjID = inputs.subjID;
    randSeed = inputs.randSeed;
    run = inputs.run;
    conditionOrder = inputs.conditionOrder;
    
    
    %subjID is a string
    assert(ischar(subjID), 'subjID must be a string');
    
    %randSeed is a positive integer
    assert((isnumeric(randSeed))&(randSeed>0)&(mod(randSeed,1)==0), ...
           'randSeed must be a positive integer');
    
    %run is 1 - 8
    assert(ismember(run, 1:8), 'list must be 1 - 8');
    
    %conditionOrder is 1 - 8
    assert(ismember(conditionOrder, 1:8), 'list must be 1 - 8');
end