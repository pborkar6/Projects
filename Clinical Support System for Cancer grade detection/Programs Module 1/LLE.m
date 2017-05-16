function [Y]=LLE(features,K,d)
% features = N x D matrix, N = number of images, D = number of features
% (dimensions) 
% features=transpose(output_features);
% K = number of neighbors
% d = max embedding dimensionality
% Y = embedding as d x N matrix

[D,N] = size(features);
fprintf(1,'LLE running on %d points in %d dimensions\n',N,D);


% Compute the distance from Xi to every other point Xj
% Find the K smallest distances
% Assign the corresponding points to be neighbours of Xi 

fprintf(1,'-->Finding %d nearest neighbours.\n',K);

X2 = sum(features.^2,1);
distance = repmat(X2,N,1)+repmat(X2',1,N)-2*features'*features;


[sorted,index] = sort(distance);
neighborhood = index(2:(1+K),:);

% STEP2: SOLVE FOR RECONSTRUCTION WEIGHTS
fprintf(1,'-->Solving for reconstruction weights.\n');

if(K>D) 
  fprintf(1,'   [note: K>D; regularization will be used]\n'); 
  tol=1e-3; % regularlizer in case constrained fits are ill conditioned
else
  tol=0;
end

W = zeros(K,N);
for ii=1:N
   % z = matrix consisting on all neighbours of Xi
   % substract Xi from every column of z
   z = features(:,neighborhood(:,ii))-repmat(features(:,ii),1,K); % shift ith pt to origin
   % Compute the local covariance
   C = z'*z;                                        
   C = C + eye(K,K)*tol*trace(C);                   % regularlization (K>D)
   W(:,ii) = C\ones(K,1);                           % solve Cw=1
   W(:,ii) = W(:,ii)/sum(W(:,ii));                  % enforce sum(w)=1
end;


% Compute embedding coordinates Y using weights W. 
fprintf(1,'-->Computing embedding.\n');

% create sparse matrix M = (I-W)'*(I-W) 
M = sparse(1:N,1:N,ones(1,N),N,N,4*K*N); 
M=full(M);
for ii=1:N
   w = W(:,ii);
   jj = neighborhood(:,ii);
   M(ii,jj) = M(ii,jj) - w';
   M(jj,ii) = M(jj,ii) - w;
   M(jj,jj) = M(jj,jj) + w*w';
end;

% CALCULATION OF EMBEDDING
%find bottom d+1 eigenvectors of M 
options.disp = 0; options.isreal = 1; options.issym = 1; 
[Y,eigenvals] = eig(M);
Y = Y(:,2:d+1)'*sqrt(N); % bottom evect is [1,1,1,1...] with eval 0


fprintf(1,'Done.\n');

