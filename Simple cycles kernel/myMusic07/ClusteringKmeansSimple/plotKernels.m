function kernel = plotKernels()

% Open file with sequences

datasets = ['28';'37';'257';'678'];
algos = ['LED';'AS';'RED';'RK'];

cd 'kernels';
res = load('-ascii','ResAS_678');
cd '..';		
imagesc(res)
cd 'plots';
print('ResAS_678_SN','-d jpg')
cd '..';
		

return
