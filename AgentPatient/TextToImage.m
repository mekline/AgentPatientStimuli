function TextToImage(order, run)
%Takes in text and turns it into a jpeg file in images
    
    %Reads in materials file
    ORDER_DIR = fullfile(pwd, 'reference_data');
    order_filename = ['AgentPatientStimuli_reference_' order num2str(run) '_data.csv'];
    order_filename = fullfile(ORDER_DIR, order_filename);
    all_materials = readtable(order_filename);
    sentences = all_materials.Sentence;
    conditions = all_materials.Condition;
    flips = all_materials.Flip;
    agentNames = all_materials.AgentName;
    patientNames = all_materials.PatientName;
    agentShapes = all_materials.AgentShape;
    patientShapes = all_materials.PatientShape;
    numSentences = length(sentences);
    
    %Save file in image folder
    IMAGE_DIR = fullfile(pwd, 'debug images');
    
    item_index = 1;
    
    for i=1:numSentences
        if ~strcmp(char(condition),'NULL ')
            %Extract info for the item we're currently on
            text = sentences{i};
            condition = conditions{i};
            flip = flips{i};
            agent = [agentNames{i} ' ' agentShapes{i}];
            patient = [patientNames{i} ' ' patientShapes{i}];

            %Spaces don't work out uniformly, so adjust for each name
            %Will want to switch for the one being highlighted, not nec. agent
    %         switch agent
    %             case 'Melissa Oval'
    %                 adjustment = 5;
    %             case 'Lily Triangle'
    %                 adjustment = 5;
    %             case 'Kyle Square'
    %                 adjustment = 4;
    %             case 'Zach Star'
    %                 adjustment = 4;
    %         end

            %Makes a text object with as many spaces as there are in agent
            highlight_box = blanks(length(agent)-adjustment);


            %Sets up image and overlays text
            I = imread('blank-white-rectangle.png');
            position = [250 1000];
            position_highlight = [275 1000];

            RGB = insertText(I,position,text,'FontSize',110,'BoxOpacity',0,'Font','Courier');
            RGB = insertText(RGB,position_highlight,highlight_box,'FontSize',150,'BoxOpacity',.4,'Font','Courier');

            %Sets up file to save; numbers indicate index at which stimulus
            %was presented
            fileToSave = ['AgentPatientStimuli_image' num2str(item_index) '.jpg'];
            fileToSave = fullfile(IMAGE_DIR, fileToSave);

            %Displays text image
            %figure
            %imshow(RGB)

            %Saves text image
            imwrite(RGB,fileToSave,'jpg')

            %Increments counter
            item_index = item_index + 1;
        end
        
    end

    
end