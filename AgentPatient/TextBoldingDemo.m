function TextToImage(order, run)
%Takes in text and turns it into a jpeg file in images

    %Constants
    FONT_SIZE = 110;

    %Sets up image and overlays text
    I = imread('blank-white-rectangle.png');
    position = [250.5 1000];
    position_highlight = [275.5 1000];
    text = 'hello world';

    RGB = insertText(I,position,text,'FontSize',FONT_SIZE,'BoxOpacity',0,'Font','Courier');
    size(I,1)
    size(I,2)
    size(RGB,1)


    %Displays text image
    figure
    imshow(RGB)

end