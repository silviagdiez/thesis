function test(algos)

data = 'sequences';

for i=1:8

	if strcmp(algos{i},'RED') || strcmp(algos{i},'RK')
		params = [0.1 0.5 1 1.5 2 2.5 3 3.5 4];
	elseif strcmp(algos{i},'PSPEC') || strcmp(algos{i},'FL')
		params = [5 10 15 20];
	elseif strcmp(algos{i},'GAS')
		params = [0.2 0.4 0.5 0.6 0.8];
	else
		params = 1;
	end
	
	for j=1:length(params)
		computeKernel02(algos{i},data,params(j));		
	end
end



return