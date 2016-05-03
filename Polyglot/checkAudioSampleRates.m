function checkAudioSampleRates()
    stimDir = fullfile(pwd, 'stimuli');
    stim = dir(stimDir);
    stim = {stim.name};
    stim = stim(3:end);

    for i=1:length(stim)
        audioFile =fullfile(stimDir, stim{i});
        [~, sampleRate] = audioread(audioFile);
        if sampleRate ~= 20000
            disp(audioFile)
            disp(sampleRate)
        end
    end
end