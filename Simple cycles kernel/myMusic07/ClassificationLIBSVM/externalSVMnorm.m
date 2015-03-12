function m = externalSVMnorm(Res,algo,dataset,ps,myclass)
% Function that calculates the SVM of
% two sequences to the given classes
% "dataset" > dataset
% "algo" > method to calculate distances

tic();

%=== Number of times we perform the k-NN ===
nbruns = 10;

%=== Tested values for C ===
cValues = [0.1 0.5 1 5 10];

%=== Class vector ===
s = myclass;
nclass = length(s);
ini = 1;
fin = 0;
for i=1:nclass
	fin = fin + s(i);
	class(ini:fin) = i;
	ini = ini + s(i);
end

%=== We set the random seed ===
rand('seed',14111981);

%============= We partition the whole data set into #nbruns disjoint sets ==========================
perm = 1:nbruns;
perm = repmat(perm,1,floor(sum(s)/nbruns));
perm = [perm 1:sum(s)-(nbruns*floor(sum(s)/nbruns))];

%======================= We start the nested Cross-validation ======================================
for i=1:nbruns
	
	%=== We keep Ti as test set for this fold ===
	data = 1:sum(s);
	test = data(perm == i);
	testClass = class(test);
	train = data(perm != i);
	trainClass = class(train);
	
	%=== we call the nested loop for getting the best theta ===
	for j=1:length(ps)
		Ktest{j} = Res{j}(test,train);
		Ktrain{j} = Res{j}(train,train);
	end
	[thetaOpt,cOpt] = internalSVM(Ktrain,trainClass,algo,dataset,ps,cValues,nbruns)
	
	%=== we classify with SVM each observation of Ti ===
	trainSet = Ktrain{thetaOpt};
	testSet = Ktest{thetaOpt};
	
	train_target = trainClass;
	test_target = testClass;
	
	% we transform the kernel into the good format
	tk(train_target,trainSet,size(train,2),size(train,2),'train',algo,dataset);
	tk(test_target,testSet,size(test,2),size(train,2),'test',algo,dataset);

	% we call the SVM classifier
	SVM(1,'train',algo,dataset,mat2str(cOpt));
	SVM(2,'test',algo,dataset,mat2str(cOpt));
	
	% predictions
	pred = load('-ascii',["trKernels_",algo,"_",dataset,"/predictions"]);
	pred = pred(:,1);
	pred = pred';
	
	%=== we compute the classification rate for this fold and this k ===
	nbCorrect(i) = sum(pred == testClass)*100/length(test)
			
end

%=== mean ===
m = mean(nbCorrect)
cd('results');
save(["ncCorrect_",algo,"_",dataset],'nbCorrect');
save(["mean_",algo,"_",dataset],'m');

%=== result storage ====
%cd '../resultsSVM';
%save('-ascii',["Mean_",algo,"_",dataset],'m');
%save('-ascii',["NC_",algo,"_",dataset],'nbCorrect');
%csvwrite(["Mean_",algo,"_",dataset,'.csv'],m);
%dlmwrite(["NC_",algo,"_",dataset],nbCorrect);
%=== we keep track of the script that generated the results ===
%info{1} = date();
%info{2} = pwd();
%info{3} = [mat2str(localtime(time()).hour),":",mat2str(localtime(time()).min)];
%info{4} = ["Elapsed time: ",mat2str(toc())];
%save(["Info_",algo,"_",dataset],'info');
%cd '../ClassificationSvmLiblinearNorm';
%cd('..');

return
