function validateSubjLanguages( subjLanguages )
%validateSubjLangauges
%   ensures that we have audio files for all of the languages set for a
%   subject

    stimDir = fullfile(pwd, 'stimuli');
    audioFiles = dir(stimDir);

    audioFiles = {audioFiles.name};
    audioFiles = audioFiles(3:end);

    availableLanguages = strtok(audioFiles, '_');
    availableLanguages = unique(availableLanguages);
    
    availableLanguages(strcmp(availableLanguages, 'music')) = [];
    availableLanguages(strcmp(availableLanguages, 'pitchEnv')) = [];
    
    for i=1:length(subjLanguages)
        subjLangauge = subjLanguages{i};
        if isempty(subjLangauge)
            continue
        end
        
        if ~any(strcmp(availableLanguages, subjLangauge))
            error('\tNo audio files for language: %s', subjLangauge);
        end
    end
end

