function test01()

dataset = '4chords';

myclass = load('../ClassVector/class02.mat');
myclass = myclass.v;
[a,b] = sort(myclass);
myclass = [93 203];

%=== sub-tree kernel ===
cd('../sub-tree-kernel');
res1 = load('K1norm.mat');
res1 = res1.K1norm;
res2 = load('K2norm.mat');
res2 = res2.K2norm;
res3 = load('K3norm.mat');
res3 = res3.K3norm;
res4 = load('K4norm.mat');
res4 = res4.K4norm;
cd('../ClassificationLIBSVM');
res = {res1,res2,res3,res4};
ps = [1 2 3 4];
algo = 'sub-tree'
externalSVMnorm(res,algo,dataset,ps,myclass,algo);

%=== LED ===
cd('../EditDistance');
res1 = load('NormLED_intervals');
res1 = res1(b,b);
cd('../ClassificationLIBSVM');
res = {res1};
ps = [1];
algo = 'LED'
externalSVMnorm(res,algo,dataset,ps,myclass,algo);

%=== AS ===
cd('../EditDistance');
res1 = load('ResAS_intervals');
res1 = res1(b,b);
cd('../ClassificationLIBSVM');
res = {res1};
ps = [1];
algo = 'AS'
externalSVMnorm(res,algo,dataset,ps,myclass,algo);

%=== JSD Kernel ===
cd('../JSDMatrices');
res1 = load('KEcycles0.1');
res1 = res1(b,b);
res2 = load('KEcycles0.3');
res2 = res2(b,b);
res3 = load('KEcycles0.5');
res3 = res3(b,b);
res4 = load('KEcycles0.7');
res4 = res4(b,b);
res5 = load('KEcycles0.9');
res5 = res5(b,b);
cd('../ClassificationLIBSVM');
res = {res1,res2,res3,res4,res5};
ps = [0.1 0.3 0.5 0.7 0.9];
algo = 'JSD'
externalSVMnorm(res,algo,dataset,ps,myclass,algo);

%=== Cycle Kernel ===
cd('../Kernel');
res1 = load('Kcycles');
res1 = res1(b,b);
cd('../ClassificationLIBSVM');
res = {res1};
ps = [1];
algo = 'Kernel'
externalSVMnorm(res,algo,dataset,ps,myclass,algo);


return;