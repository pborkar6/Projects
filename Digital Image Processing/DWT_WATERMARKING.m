I=imread('lena.png');

R=I(:,:,1); 

G=I(:,:,2); 

B=I(:,:,3); 
%%%%%%%%%%%CONVERSION TO YUV SPACE
YY = 0.299 * R + 0.587 * G + 0.114 * B; % luminance selected
UU = -0.14713 * R - 0.28886 * G + 0.436 * B;
VV= 0.615 * R - 0.51499 * G - 0.10001 * B;

YUV = cat(3,YY,UU,VV);

%dwt on original image

[LL,LH,HL,HH]=dwt2(YY,'haar');


% PCA on watermark

W=(((imresize(imread('cameraman.tif'),[256 256]))));
W=double(im2bw(W));
figure;
imshow(W);

X=W;
[M N] = size(X);
u = mean(X,2); % you need to calculate u 
U = repmat(u,1,N); % you need to construct U. You may use the function repmat 
%% Step 3: Subtracting the mean =========================================
%%%% EDIT THIS PART %%%
Y = X- U; % you need to calculate Y  
%% Step 4: Calcualting the autocorrelation matrix =======================
%%% EDIT THIS PART %%%
Ry = Y*Y'/N; % you need to calculate R  
%% Step 5: Finding the eigen vectors ================================
V = zeros(M,N); 
%%% EDIT THIS PART %%%
% calculate the eigen vectors and put them in as columns of the matrix V.
% You may use the function "svd" which is the same as "eig" for
% positive semi-definite matrices but it orders the vectors in a descening
% order of the eigen values 
[V LAMBDA] = svd(Ry); 
%% Step 6: Define the transformation matrix ============================
%%% EDIT THIS PART %%%
A2 = V'; %define A
%% STEP 7: Calculating the KLT ==========================================
%%%% EDIT THIS PART %%%
Z_w = A2*Y; %calculate the KLT of the X




% Embedding the watermark with strength a
a=0.2;
Z_watLL=LL+a*Z_w;

R_recon=idwt2(Z_watLL,LH,HL,HH,'haar');
YUVt_recon = cat(3,R_recon,UU,VV);

R1t = uint8(R_recon) + 1.139834576 * VV;
G1t = uint8(R_recon) -0.3946460533 * UU -.58060 * VV;
B1t = uint8(R_recon) + 2.032111938 * UU;

Watermarked_DWT = cat(3,R1t,G1t,B1t);
figure;
imshow(Watermarked_DWT);
title('Watermarked image using DWT');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Re=Watermarked_DWT(:,:,1); 
% Ge=Watermarked_DWT(:,:,2); 
% Be=Watermarked_DWT(:,:,3); 
% 
% Ye = 0.299 * Re + 0.587 * Ge + 0.114 * Be;
% UUe = -0.14713 * Re - 0.28886 * Ge + 0.436 * Be;
% VVe= 0.615 * Re - 0.51499 * Ge - 0.10001 * Be;
% 
% YUVe = cat(3,Ye,UUe,VVe);

[LLe,LHe,HLe,HHe]=dwt2(R_recon,'haar');

a=0.2;
Well=(LLe-LL)/a; % extracting


LLp=((A2')*Well)+U; 
figure;
imshow(LLp);
title('Extracted Watermark');

lenaLL=(LLe-Well*a);
Lena=idwt2(lenaLL,LHe,HLe,HHe,'haar');
YUVt_recon = cat(3,R_recon,UU,VV);

R1t = uint8(Lena) + 1.139834576 * VV;
G1t = uint8(Lena) -0.3946460533 * UU -.58060 * VV;
B1t = uint8(Lena) + 2.032111938 * UU;

Lena = cat(3,R1t,G1t,B1t);

figure;
imshow(Lena);
title('Get back lena');

PSNR_watermark_DWT=psnr(LLp,W)
Corr_watermark_DWT=corr2(LLp,W)
ssim_watermark_DWT=ssim(LLp,W)