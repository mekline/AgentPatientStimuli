function TextToImage(order, run)
%Takes in text and turns it into a jpeg file in images

    %Constants
    FONT_SIZE = 110;
    
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
            
            %Determine person to be highlighted
            switch condition
                case 'Agent'
                    person = agent;
                case 'Patient
                    person = patient;
            end

            %Spaces don't work out uniformly, so adjust for each name
            %Will want to switch for the one being highlighted
    %         switch person
    %             case 'Melissa Oval'
    %                 adjustment = 5;
    %             case 'Lily Triangle'
    %                 adjustment = 5;
    %             case 'Kyle Square'
    %                 adjustment = 4;
    %             case 'Zach Star'
    %                 adjustment = 4;
    %         end
    
            %Determine whether person comes 1st or 2nd in sentence
            if (strcmp(char(condition), 'Agent') xor flip == 1)
                position = 1;
            else
                position = 2;
            end
            
            %Determine where highlight starts and ends, based on position
            switch position
                case 1
                    %Determine where to start the highlight
                    highlight_start = 275;
                    %Make a string with as many spaces as there are in person
                    highlight_box = blanks(length(person)-adjustment);
                case 2
                    %uhhh

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
            
            


            %Sets up image and overlays text
            I = imread('blank-white-rectangle.png');
            position = [250 1000];
            position_highlight = [highlight_start 1000];

            RGB = insertText(I,position,text,'FontSize',FONT_SIZE,'BoxOpacity',0,'FontName','FixedWidth');
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