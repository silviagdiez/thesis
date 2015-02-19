function m = test()
algos = {'RED','RK'};
datas = {'digits','figures'};

for i=1:length(algos)
	for j=1:length(datas)
		printf('1-NNP: %s %s\n',algos{i},datas{j});
		fflush(stdout);
		externalNNnorm(algos{i},datas{j});
	end
end


return
