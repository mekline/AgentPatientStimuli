function [pahandle, buffers] = setUpAudioFiles(conditionBlocks, materials)
%setUpAudioFiles
%   creates a buffer for each sound file

    %Initialize the sound driver
    InitializePsychSound(1);
    PsychPortAudio('Close');
    
    sampleRate = 20000;
    numChannels = 2;
    
    pahandle = PsychPortAudio('Open', [], [], 0, sampleRate, numChannels);
    
    %Read all sound files and create & fill one dynamic audio buffer for each soundfile
    stimDir = fullfile(pwd, 'stimuli');
    buffers = [];
    
    numTrials = length(conditionBlocks);
    for trialNum=1:numTrials
        condition = conditionBlocks{trialNum};
        
        if strcmp(condition, 'Fix')
            continue
        end
        
        %Get the audio filename
        audioFile = fullfile(stimDir, materials.(condition));
        
        %Read in the audio file
        try
            [audioSample, sampleRateIn] = audioread(audioFile);
        catch
            error('Audio file not found:\n\t%s', audioFile);
        end
        
        if sampleRateIn ~= sampleRate
            audioSample = resample(audioSample, sampleRate, sampleRateIn);
        end
        
        %Save audio data
        waveData = audioSample';
        numChannelsIn = size(waveData,1);
        
        %convert to stereo if mono
        if numChannelsIn == 1
            waveData = [waveData; waveData];
        end
        
        buffers(end+1) = PsychPortAudio('CreateBuffer', [], waveData);
    end
end

