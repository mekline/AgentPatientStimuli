function [ trialOnsets ] = trialOnsetTimes( conditionBlocks, DURATION )
%trialOnsetTiems
%   returns array of trial onsets in seconds
    
    numTrials = length(conditionBlocks);
    
    trialOnsets = zeros(numTrials,1);
    for trialNum = 1:numTrials-1
        trialOnset = trialOnsets(trialNum);
        
        condition = conditionBlocks{trialNum};
        
        if strcmp(condition, 'Fix')
            trialOnsets(trialNum+1) = trialOnset + DURATION.fix;
            
        else
            trialOnsets(trialNum+1) = trialOnset + DURATION.audio;
        end
    end
end

