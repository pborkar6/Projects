% Split original image into even and odd
I= imread('lena.png');
I=rgb2gray(I);
figure;
imshow(I);
title('Original image');
[M,N,L]=size(I);
O=I;
E=I;
for i=1:M
    for j=1:N
        if(mod(I(i,j),2)==0)
            E(i,j)=I(i,j);
            O(i,j)=0;
        end
        if(mod(I(i,j),2)~=0)
           O(i,j)=I(i,j);
           E(i,j)=0; 
        end
    end
end
figure;
imshow(E);
title('even');
figure;
imshow(O);
title('odd');

            

