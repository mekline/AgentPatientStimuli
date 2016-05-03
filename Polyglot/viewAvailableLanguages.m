function viewAvailableLanguages()
    stimDir = fullfile(pwd, 'stimuli');
    audioFiles = dir(stimDir);

    audioFiles = {audioFiles.name};
    audioFiles = audioFiles(3:end);

    languages = strtok(audioFiles, '_');
    languages = unique(languages);
    
    languages(strcmp(languages, 'music')) = [];
    languages(strcmp(languages, 'pitchEnv')) = [];
    
    disp(languages')
end