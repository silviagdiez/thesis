function m = test()
algos = {'AS','FL','PSPEC'};
datas = {'arrows','digits','figures','letters','sequences'};

for i=1:length(algos)
	for j=1:length(datas)
		externalNNnorm(algos{i},datas{j});
	end
end


return
