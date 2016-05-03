function fileToSave = getDataFilename(inputs)
%getDataFilename
%   Returns a string of the output filename and makes sure we don't
%   accidentally overwrite an existing file
    
    %Create the data diretory if it doesn't already exist
    dataDir = fullfile(pwd, 'data');
    if ~exist(dataDir, 'dir')
        mkdir(dataDir);
    end
    
    
    %Get the string of the file we want to save
    subjID = inputs.subjID;
    run = num2str(inputs.run);
    conditionOrder = num2str(inputs.conditionOrder);
    
	fileToSave = ['PolyglotStories_' subjID '_run' run '_order' conditionOrder '_data.csv'];
              
    fileToSave = fullfile(dataDir, fileToSave);
    
    
	%Make sure we don't accidentally overwrite a data file
	if exist(fileToSave, 'file')
        fprintf('\nThe data file\n%s\nalready exists!\n\n', fileToSave);
        str = input('Overwrite? (y/n): ', 's');
        if ~(strcmpi(str,'y') || strcmpi(str,'yes'))
            error('The data file already exists for this subject!');
        end
	end
end