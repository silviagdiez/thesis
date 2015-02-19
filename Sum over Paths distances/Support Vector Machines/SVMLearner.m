function [thetaOpt,cOpt,avgPerf] = SVMLearner(Y,Yf,paramTest,alphas,kernels,algo,dataset,cValues)

%"Yf" = vector of class
%"alphas" = values of theta
%"kernels" = precomputed kernels

preds = zeros(size(alphas,2),size(cValues,2));

% calculation of the pred matrix
for j=1:size(alphas,2)
	for k=1:size(cValues,2)
			% choose the correct kernel
			res = kernels{j};
			train = res(Yf,Yf);
			test = res(paramTest,Yf);
	
			train_target = Y(Yf);
			test_target = Y(paramTest);
	
			% we transform the kernel into the good format
			tk(train_target,train,size(Yf,2),size(Yf,2),'train',algo,dataset);
			tk(test_target,test,size(paramTest,2),size(Yf,2),'test',algo,dataset);

			% we call the SVM classifier
			SVM(1,'train',algo,dataset,cValues(k));
			SVM(2,'test',algo,dataset,cValues(k));
	
			% predictions
			pred = load('-ascii',["trKernels_",algo,"_",dataset,"/predictions"]);
			pred = pred(:,1);
			pred = pred';
		
			preds(j,k) = sum(pred == test_target)/length(test_target);			
	end
end

% we count the number of maximum values
nmax = 0;
max = 0;
for j=1:size(alphas,2)
	for k=1:size(cValues,2)
		if (preds(j,k) > max)
			max = preds(j,k);
			nmax = 1;
			row = j;
			col = k;
		elseif (preds(j,k) == max)
			nmax++;
		end
	end
end 

% if there are more than one maximum value
if (nmax > 1)

	[thetaOpt,cOpt] = grid(preds);
	
else % just one maximum

	thetaOpt = row;
	cOpt = col;
	
end

avgPerf = preds(thetaOpt,cOpt)*100;

printf('The best theta is %f with c = %f and an average performance of %f\n',thetaOpt,cOpt,avgPerf);
fflush(stdout);

return;