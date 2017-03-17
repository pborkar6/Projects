% I is original Lena
%len_recon is reconstructed lena
% watermark is original watermark
%  X_rec final extracted watermark 

corr_watermark_contour=corr2(X_rec,watermark)
PSNR_watermark_contour=psnr(X_rec,watermark)



ssim_watermark_contour=ssim(X_rec,watermark)