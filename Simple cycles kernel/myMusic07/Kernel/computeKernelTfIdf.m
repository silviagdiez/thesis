function computeKernelTfIdf(tf_idf,labels)
%=== This function computes the interior product from
% cycles among all pairs of cycles
%============================================

%dirs = {'../Self-avoiding/Cycles','../Self-avoiding/Paths'};
dirs = {'../Self-avoiding/Cycles'};

tic();

for l=1:length(dirs)

    dir = dirs{l};
	mylist = ls(dir);
	numItems = (length(mylist)/41);
	n = 0;
	cbegin = 1;
	cend = 0;
    
    %=== This is the similarity matrix ===
    K = zeros(numItems,numItems);
	
	for i=1:numItems 
		['%%%%%%%%%%%%%% ',mat2str(i),' %%%%%%%%%%%%%%']
		cend = cbegin + 39;
		myfile1 = mylist(cbegin:cend)
		cbegin = cend + 2;
        
        %=== We load the file ===
        path1 = [dir,'/',myfile1];
        f1 = load(path1);
        if l == 1
            res1 = f1.saveCycles;
        else
            res1 = f1.savePaths;
        end
        n2 = 0;
        cbegin2 = 1;
        cend2 = 0;
	
        for j=1:numItems 
            cend2 = cbegin2 + 39;
            myfile2 = mylist(cbegin2:cend2);
            cbegin2 = cend2 + 2;
	
            %=== We load the file ===
            path2 = [dir,'/',myfile2];
            f2 = load(path2);
            if l == 1
                res2 = f2.saveCycles;
            else
                res2 = f2.savePaths;
            end
            
            %=== We compute the inner product ===
            ip = cycleKernelTfIdf(res1,res2,i,j,tf_idf,labels);
            K(i,j) = ip;
            %K(j,i) = ip;
        end
    end
    
    %=== We save the obtained matrix ===
    if l == 1
        save('-ascii','KcyclesTFIDF','K');
    else
        save('-ascii','KpathsTFIDF','K');
    end
    
end
toc()
