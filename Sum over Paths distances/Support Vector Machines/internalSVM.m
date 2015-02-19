function [thetaOpt,cOpt] = internalSVM(kernels,class,algo,dataset,ps,cValues)
% Internal loop of k-NN where it computes
% the best value of k
% "kernel" > kernel
% "ps" > tested values of parameters
% "cValues" > tested values of C
% "class" > classes of observations

%=== Number of times we perform the k-NN ===
nbruns = 10;

%=== We partition the whole data set into #nbruns disjoint sets ===
perm = 1:nbruns;
perm = repmat(perm,1,floor(length(class)/nbruns));
perm = [perm 1:length(class)-(nbruns*floor(length(class)/nbruns))];

%=== We start the nested Cross-validation ===
for i=1:nbruns
	
	%=== We keep Ti as test set for this fold ===
	data = 1:length(class);
	test = data(perm == i);
	train = data(perm != i);
		
	[thetaOpt,cOpt,avgPerf] = SVMLearner(class,train,test,ps,kernels,algo,dataset,cValues);		
	nbCorrect(i) = avgPerf;
	thetas(i) = thetaOpt;
	cs(i) = cValues(cOpt);
	
end

[a,b]  = max(nbCorrect);
cOpt   = cs(b);
thetaOpt = thetas(b);

return
