function playAudio(audioInfo, waitTime, kbIdx, escapeKey)
%playAudio

    sampleRate  = audioInfo.SampleRate;
    numChannels = audioInfo.NumChannels;
    waveData = audioInfo.WaveData;
    
    pahandle = PsychPortAudio('Open', [], [], 0, sampleRate, numChannels);

    PsychPortAudio('FillBuffer', pahandle, waveData);

    PsychPortAudio('Start', pahandle);
    %WaitSecs(duration);
    waitForTime(kbIdx, escapeKey, waitTime)
    PsychPortAudio('Close');
end

