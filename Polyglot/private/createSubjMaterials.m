function createSubjMaterials( subjID, matFilename )
%createSubjMaterials
%   Creates a structure called subjMaterials that indicates which item to
%   use for each condition on each run.
%
%   Examples:
%       subjMaterials.run3.L1 might be 'English_6.wav'
%       subjMaterials.run7.Q3 might be 'Arabic_2_quilt.wav'
%
%   This structure is saved as a mat file called <matFilename>
%
%   You should call this function on the first run of the script ONLY.
%   On all subsequent runs, you should just load the relevant mat file.

    %% Make sure we don't accidently overwrite anything
    if exist(matFilename, 'file')
        fprintf('\nThe materials file\n%s\nalready exists!\n\n', matFilename);
        str = input('Overwrite? (y/n): ', 's');
        if ~(strcmpi(str,'y') || strcmpi(str,'yes'))
            error('The materials file already exists for this subject!');
        end
    end
    
    
    %% Read in the subject languages file
    subjLangFile = 'LanguagesToUse.csv';
    languages = readtable(subjLangFile);
    subjLine = find(strcmp(languages.subjID, subjID));
    
	if isempty(subjLine)
        error('\nSubject ID (%s) not found in %s\n', subjID, subjLangFile);
	end
    
    if length(subjLine) > 1
        lineNums = subjLine + 1;
        lineNums = sprintf('%d ', lineNums);
        
        error(['\nSubject ID (%s) appears more than once in %s\n\n'...
               'See lines %s\n'], subjID, subjLangFile, lineNums);
    end
    
    
    subjLanguages = languages{subjLine,2:end};
    
    %make sure we have audio files for all of the subject langauges
    validateSubjLanguages(subjLanguages);
    
    
    %% Choose which item number to use for each langauge on each run
    totalRuns = 8;
    languagesPerRun = 8;
    
    %filler sounds to use in case a subject has fewer than 8 langauges
    langFiller = 'music';
    quiltFiller = 'pitchEnv';
    
    for langIdx = 1:languagesPerRun
        langField  = sprintf('L%d', langIdx);
        quiltField = sprintf('Q%d', langIdx);
        
        language = subjLanguages{langIdx};
        itemNums = randperm(languagesPerRun);
        
        for runIdx = 1:totalRuns
            if isempty(language)
                langItem  = sprintf('%s_%d.wav', langFiller, itemNums(runIdx));
                quiltItem = sprintf('%s_%d.wav', quiltFiller, itemNums(runIdx));
                
            else
                langItem  = sprintf('%s_%d.wav', language, itemNums(runIdx));
                quiltItem = sprintf('%s_%d_quilt.wav', language, itemNums(runIdx));
            end
            
            runField = sprintf('run%d', runIdx);
            
            subjMaterials.(runField).(langField) = langItem;
            subjMaterials.(runField).(quiltField) = quiltItem;
        end
    end
    
    save(matFilename, 'subjMaterials');
    
end

