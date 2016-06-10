function TextToImage(order, run)
%Takes in text and turns it into a jpeg file in images
    
    %Reads in materials file
    ORDER_DIR = fullfile(pwd, 'orders');
    order_filename = ['AgentPatientStimuli_Order' order num2str(run) '.csv'];
    order_filename = fullfile(ORDER_DIR, order_filename);
    all_materials = readtable(order_filename);
    sentences = all_materials.ProgressiveActive;
    numSentences = length(sentences);
    
    %Save file in image folder
    IMAGE_DIR = fullfile(pwd, 'debug images');
    
    
    for i=1:numSentences
        
        text = sentences{i};
        
        if ~strcmp(text,'N/A')
            %Sets up image and overlays text
            I = imread('blank-white-rectangle.png');
            position = [250 100];

            RGB = insertText(I,position,text,'FontSize',150,'BoxOpacity',0);

            %Sets up file to save
            fileToSave = ['AgentPatientStimuli_image' num2str(i) '.jpg'];
            fileToSave = fullfile(IMAGE_DIR, fileToSave);

            %Displays text image
            %figure
            %imshow(RGB)

            %Saves text image
            imwrite(RGB,fileToSave,'jpg')
        end
        
    end
    
    

    
end