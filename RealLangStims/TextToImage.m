function TextToImage(text)
%Takes in text and turns it into a jpeg file in images
    IMAGE_DIR = fullfile(pwd, 'images');
    fileToSave = ['AgentPatientStimuli_image.jpg'];
    fileToSave = fullfile(IMAGE_DIR, fileToSave);
    
    I = imread('blank-white-rectangle.png');
    position = [1000 1000];
    RGB = insertText(I,position,text,'FontSize',200,'BoxOpacity',0);
    
    figure
    imshow(RGB)
    
    imwrite(RGB,fileToSave,'jpg')
end