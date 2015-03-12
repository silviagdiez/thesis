% Script that runs the clustering over several datasets
% for an optimal theta given an algorithm

thetas = [0.1 0.5 1 1.5 2 2.5 3 3.5 4];

%%% Create kernels 014 %%%
computeKernel('014','RED',thetas(1));
computeKernel('014','RED',thetas(2));
computeKernel('014','RED',thetas(3));
computeKernel('014','RED',thetas(4));
computeKernel('014','RED',thetas(5));
computeKernel('014','RED',thetas(6));
computeKernel('014','RED',thetas(7));
computeKernel('014','RED',thetas(8));
computeKernel('014','RED',thetas(9));

computeKernel('014','RK',thetas(1));
computeKernel('014','RK',thetas(2));
computeKernel('014','RK',thetas(3));
computeKernel('014','RK',thetas(4));
computeKernel('014','RK',thetas(5));
computeKernel('014','RK',thetas(6));
computeKernel('014','RK',thetas(7));
computeKernel('014','RK',thetas(8));
computeKernel('014','RK',thetas(9));

%%% Search the optimal theta %%%
nclass = 3; 
searchOptTheta('014','RED',thetas,nclass);
searchOptTheta('014','RK',thetas,nclass);

%%% Compute kernels for 28 37 257 678 and optimal theta %%%
%%%%%%%%%%%%%%
ot = 4; %%%%%%
%%%%%%%%%%%%%%
computeKernel('28','RED',thetas(ot));
computeKernel('37','RED',thetas(ot));
computeKernel('257','RED',thetas(ot));
computeKernel('678','RED',thetas(ot));

%%%%%%%%%%%%%%
ot = 6; %%%%%%
%%%%%%%%%%%%%%
computeKernel('28','RK',thetas(ot));
computeKernel('37','RK',thetas(ot));
computeKernel('257','RK',thetas(ot));
computeKernel('678','RK',thetas(ot));

computeKernel('28','LED',thetas(ot));
computeKernel('37','LED',thetas(ot));
computeKernel('257','LED',thetas(ot));
computeKernel('678','LED',thetas(ot));

computeKernel('28','AS',thetas(ot));
computeKernel('37','AS',thetas(ot));
computeKernel('257','AS',thetas(ot));
computeKernel('678','AS',thetas(ot));

%%% Perform the clustering with rest of datasets %%%
%%%%%%%%%%%%%%
ot = 4; %%%%%%
%%%%%%%%%%%%%%
nclass = 2;
computeClustering('28','RED',thetas(ot),nclass);
computeClustering('37','RED',thetas(ot),nclass);
nclass = 3; 
computeClustering('257','RED',thetas(ot),nclass);
computeClustering('678','RED',thetas(ot),nclass);

%%%%%%%%%%%%%%
ot = 6; %%%%%%
%%%%%%%%%%%%%%
nclass = 2; 
computeClustering('28','RK',thetas(ot),nclass);
computeClustering('37','RK',thetas(ot),nclass);
nclass = 3; 
computeClustering('257','RK',thetas(ot),nclass);
computeClustering('678','RK',thetas(ot),nclass);

nclass = 2;
computeClustering('28','LED',thetas(ot),nclass);
computeClustering('37','LED',thetas(ot),nclass);
nclass = 3; 
computeClustering('257','LED',thetas(ot),nclass);
computeClustering('678','LED',thetas(ot),nclass);

nclass = 2;
computeClustering('28','AS',thetas(ot),nclass);
computeClustering('37','AS',thetas(ot),nclass);
nclass = 3; 
computeClustering('257','AS',thetas(ot),nclass);
computeClustering('678','AS',thetas(ot),nclass);

