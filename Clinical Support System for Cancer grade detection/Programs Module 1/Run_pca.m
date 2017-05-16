features=transpose(features_matrix);
[coeff,score]=pca(features);

numberOfDimensions=50; % To be decided later
reducedDimension = coeff(:,1:numberOfDimensions);
reducedData = features* reducedDimension;
numim=1:300;
numdim=1:171;
numreddim=1:50;

normfeat=normr(features);
surf(numim,numdim,normfeat,'edgecolor','none');
normredfeat=transpose(normredfeat);
surf(numim,numreddim,normredfeat,'edgecolor','none')