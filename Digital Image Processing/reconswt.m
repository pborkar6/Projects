% Re=G_recon(:,:,1); 
% 
% Ge=G_recon(:,:,2); 
% 
% Be=G_recon(:,:,3); 
% Ye = 0.299 * Re + 0.587 * Ge + 0.114 * Be;
% 
% UUe = -0.14713 * Re - 0.28886 * Ge + 0.436 * Be;
% VVe= 0.615 * Re - 0.51499 * Ge - 0.10001 * Be;
% YUVe = cat(3,Ye,UUe,VVe);


[LLe,LHe,HLe,HHe]=swt2(R_recon,1,'haar');
a=0.2;
Well=(LLe-LL)/a; % extracting


LLp=double(((A2')*Well)+U );
figure;
imshow(LLp);
title('Extracted Watermark');


lenaLL=(LLe-Well*a);
Lena=iswt2(lenaLL,LHe,HLe,HHe,'haar');
YUVt_recon = cat(3,Lena,UU,VV);

R1t = uint8(Lena) + 1.139834576 * VV;
G1t = uint8(Lena) -0.3946460533 * UU -.58060 * VV;
B1t = uint8(Lena) + 2.032111938 * UU;

Lena1 = cat(3,R1t,G1t,B1t);

figure;
imshow(Lena1);
title('Get back lena');

PSNR_hostImage_SWT = psnr(G_recon,I)
PSNR_watermark_SWT=psnr(LLp,W)

ssim_hostImage_SWT = ssim(G_recon,I)
ssim_watermark_SWT=ssim(LLp,W)


