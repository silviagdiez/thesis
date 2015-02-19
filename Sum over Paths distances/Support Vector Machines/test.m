function m = test()
algos = {'FL','LED','RED','RK','PSPEC'};
datas = {'figures'};

for i=1:length(algos)
	for j=1:length(datas)
		externalSVMnorm(algos{i},datas{j});
	end
end


return
