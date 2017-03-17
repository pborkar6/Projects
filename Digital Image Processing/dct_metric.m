% I is original Lena
%recons is reconstructed lena
% watermark is original watermark
%  X_rec final extracted watermark 

corr_watermark_dct=corr2(X_rec,watermark)
PSNR_watermark_dct=psnr(X_rec,watermark)



ssim_watermark_dct=ssim(X_rec,watermark)