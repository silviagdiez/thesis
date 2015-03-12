function calculateClusters(algo,dataset)

if (strcmp(algo,'RED') || strcmp(algo,'RK'))
	params = [0.1 0.5 1 1.5 2 2.5 3 3.5 4];	
elseif (strcmp(algo,'PSPEC') || strcmp(algo,'FL'))
	params = [5 10 15 20];
elseif (strcmp(algo,'GAS'))
	params = [0.2 0.4 0.5 0.6 0.8];
end

for i=1:length(params)
	param = params(i);
	computeClustering(algo,dataset,param);
end

return
