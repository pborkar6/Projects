% imagefiles = dir('*.png');      
% nfiles = length(imagefiles);    % Number of files found
% for ii=1:nfiles
%    currentfilename = imagefiles(ii).name;
%    currentimage = double(imread(currentfilename));
%    images{ii} = currentimage;
% end
% len=length(images);

function[texture_features]=texture_feature(input_image)
    Ng=256;
    contrast=0;
    IDM=0;
    SOS=0;
    E=0;
    pxppy=zeros(2*Ng-1,1);
    pxmy=zeros(2*Ng-1,1);
    I=double(imread(input_image));
    I=uint8((I(:,:,1)+I(:,:,2)+I(:,:,3))/3);
    p = graycomatrix(I);
    u=mean(p);
    stdp=std2(p);
    [M,N]=size(p);
    for j=1:M
        px(j)=sum(p(j,:));
        py(j)=sum(p(:,j));
    end
    ux=mean(px);
    uy=mean(py);
    stdx=std2(px);
    stdy=std2(py);
    
    for k=2:2*Ng
       for i=1:M
        for j=1:N
            if(i+j==k)
                pxppy(k)=pxppy(k)+p(i,j);
            end
        end
       end
   end
   
   for k=2:2*Ng
       for i=1:M
        for j=1:N
            if(abs(i-j)==k)
                pxmy(k)=pxmy(k)+p(i,j);
            end
        end
       end
   end
    

    
    % 1. Angular Second Moment
    angular_second_moment=sum(sum(p*p));
    %2.variance
    variance=var(p);
    
    % 3.inverse difference moment
    for i=1:M
        for j=1:N
            IDM=IDM+p(i,j)/(1/(1+(i-j)*(i-j)));
        end
    end
    
    %4. sum of squares
    for i=1:M
        for j=1:N
            SOS=SOS+p(i,j)*(i-u).^2;
        end
    end
    
   % 5.Contrast
   % 6.Correlation
   glcm_prop = graycoprops(p);
   correlation=glcm_prop.Correlation;
   contrast=glcm_prop.Contrast;
   
   % 7.Entropy
   for i=1:M
        for j=1:N
            E=E+p(i,j)*log(1/p(i,j));
        end
   end
   
   % 8.Sum Average
   sum_avg=0;
   for k=2:2*Ng-1
       sum_avg = sum_avg + k*pxppy(k);
   end
   
   texture_features = [
                    angular_second_moment, ...
                   IDM, ...
                   SOS, ...
                   E, ...
                   correlation, ...
                   contrast,...                   
                   sum_avg];
  
    
end