% I is original Lena
%recons is reconstructed lena
% watermark is original watermark
%  X_rec final extracted watermark 

PSNR_hostImage_curvelet=psnr(X_rec,watermark)
corr_watermark_curvelet=corr2(X_rec,watermark)
ssim_watermark_curvelet=ssim(X_rec,watermark)

