function mturk_csv_generator(order)
    %This is where the data file will go
    DATA_DIR = pwd;
    %This is what we'll call the data file we're making
    fileToSave = ['mturk_images_' order '.csv'];
    %The file should be in the DATA_DIR folder
    fileToSave = fullfile(DATA_DIR, fileToSave);
    
    %Initialize cells
    img_files = cell(1,120);
    IMAGE_DIR = fullfile(pwd, 'images', 'stills');

    for run=1:2
        %Set up order
        ORDER_DIR = fullfile(pwd, 'orders'); %folder containing all orders

        order_filename = ['AgentPatientStimuli_Order' order num2str(run) '.csv']; %order for this run
        order_filename = fullfile(ORDER_DIR, order_filename); %full path for that order
        all_materials = readtable(order_filename); %order stored as a table

        numEvents = height(all_materials); %the total number of trials and fixations

        %Set up results
        resultsHdr = {'image_number','image_name'};
        results = cell(numEvents, length(resultsHdr));
        results = cell2table(results, 'VariableNames', resultsHdr);

        %Fill in image numbers
        counter=1;
        for eventNum=1:120
            results.image_number{eventNum} = char(['IMAGE_' num2str(counter)]);
            counter = counter + 1;
        end

        index = 1;
        %Loop through all the events
        for eventNum=1:numEvents
            condition = all_materials.Condition(eventNum);
            flip = all_materials.Flip{eventNum};

            flip_word_0 = 'orig';
            flip_word_1 = 'flipped';

            if ~strcmp(char(condition), 'NULL ') %if this trial isn't a fixation
                %Determine flip
                switch flip
                    case '0'
                        flip_word = flip_word_0;
                    case '1'
                        flip_word = flip_word_1;
                end

                %what is the name of the image we want
                img_name = [char(condition) '_' flip_word '_' char(all_materials.ItemNumber{eventNum}) '.jpg'];

                %put it into a cell with the other image filenames
                img_files{1,index} = fullfile(IMAGE_DIR, img_name);

                %read in the image name
                image_name = img_files{index};
                %and store it in results
                results.image_name{index} = image_name;

                %increment index
                index = index + 1;

            end
        end
    end
    writetable(results,fileToSave);
end