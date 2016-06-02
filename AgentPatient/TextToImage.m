function TextToImage()
%Takes in text and turns it into a jpeg file in images
    
    %Reads in materials file
    materials_filename = 'AgentPatientStimuli_materials.csv';
    all_materials = readtable(materials_filename);
    sentences = all_materials.ProgressiveSentence;
    numSentences = length(sentences);
    
    %Save file in image folder
    IMAGE_DIR = fullfile(pwd, 'images');
    
    
    for i=1:numSentences
        
        %Sets up image and overlays text
        I = imread('blank-white-rectangle.png');
        position = [250 1000];
        text = sentences{i};
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