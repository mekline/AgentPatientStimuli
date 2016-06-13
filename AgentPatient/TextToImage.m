function TextToImage(order, run)
%Takes in text and turns it into a jpeg file in images
    
    %Reads in materials file
    ORDER_DIR = fullfile(pwd, 'orders');
    order_filename = ['AgentPatientStimuli_Order' order num2str(run) '.csv'];
    order_filename = fullfile(ORDER_DIR, order_filename);
    all_materials = readtable(order_filename);
    sentences = all_materials.ProgressiveActive;
    agents = all_materials.AgentName;
    patients = all_materials.PatientName;
    numSentences = length(sentences);
    
    %Save file in image folder
    IMAGE_DIR = fullfile(pwd, 'debug images');
    
    item_index = 1;
    for i=1:numSentences
        
        text = sentences{i};
        agent = agents{i};
        patient = patients{i};
        text_none = blanks(length(agent));
        
        if ~strcmp(text,'N/A')
            %Sets up image and overlays text
            I = imread('blank-white-rectangle.png');
            position = [250 1000];

            RGB = insertText(I,position,text,'FontSize',150,'BoxOpacity',0);
            RGB = insertText(RGB,position,text_none,'FontSize',150,'BoxOpacity',.4);

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