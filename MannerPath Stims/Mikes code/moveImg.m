function new_img = moveImg(img,bkg, x,y)
%Melissa sure wishes she remembered what this code accomplishes :(

[m, n, p] = size(img);

'bigimg'
size(ones(m+2*abs(x),n+2*abs(y),p))

pause(2)
'backimg'
size(bkg)
pause(2)

big_img = ones(m+2*abs(x),n+2*abs(y),p)*bkg;

big_img(abs(x)+1:abs(x)+m,abs(y)+1:abs(y)+n,1:p) = img;

new_img = uint8(big_img(abs(x)+x+1:abs(x)+x+m,abs(y)+y+1:abs(y)+y+n,1:p));
