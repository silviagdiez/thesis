function [classif,randIndex] = computeClustering02(K,class,nclass,name)
% Function that performs a k-means kernel clustering over 
% a given a kernel
% "K" > kernel
% "class" > class vector
% "nclass" > number of different classes

[rows,cols] = size(K)
length(class)

tic();

% Parameters for clustering
%class = class';

[r1,rc1,r2,rc2] = global_fuzzy(K, nclass, class)
classif = r1;
randIndex = r2;
cd 'results';
results(1,1) = r1;
results(1,2) = rc1;
results(2,1) = r2;
results(2,2) = rc2;
save('-ascii',[name,"_ClusteringSimple"],'results');
resText = [mat2str(r1),",",mat2str(rc1),",",mat2str(r2),",",mat2str(rc2)]
save('-ascii',[name,"_ClusteringSimple.csv"],'resText');
cd '..';
toc()
return
