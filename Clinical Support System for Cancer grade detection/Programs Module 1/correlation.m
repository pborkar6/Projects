y={'Necrosis', 'Necrosis', 'Necrosis','Stroma','Stroma','Stroma','Tumor','Tumor','Tumor'};
a=FEATURES;

g=corr(FEATURES);
MI = entropy(X) + entropy(Y) - JointEntropy(X,Y)

for i=1:171
    gg(i)=mean(g(i,:));
    MI = entropy(a()) + entropy(Y) - JointEntropy(X,Y)
end

[rank,ind]= sort(gg,'descend');

