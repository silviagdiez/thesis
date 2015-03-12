function computations()

alphas = [0.1 0.5 1 1.5 2 2.5 3 3.5 4];
%=== compute kernels (tune theta) ===
for i=1:length(alphas)
	param = alphas(i);
	[classif, ri] = computeClustering('RED','SequencesTrain',param,4);
	res(i) = classif;
end
[a,thetaOpt] = max(res);
computeClustering('RED','SequencesTest',alphas(thetaOpt),4);
return
