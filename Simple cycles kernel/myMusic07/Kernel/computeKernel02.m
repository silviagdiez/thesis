function computeKernel02()
%=== This function computes the interior product from
% cycles among all pairs of cycles
%============================================

%dirs = {'../Self-avoiding/Cycles','../Self-avoiding/Paths'};
%dirs = {'../Self-avoiding/CyclesQueen'};
dirs = {'../Self-avoiding/CyclesBeatles'};

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
            %ip = cycleKernel03(res1,res2);
            ip = cycleKernel02(res1,res2);
            %ip = cycleKernel(res1,res2);
            K(i,j) = ip;
        end
    end
    
    %=== We save the obtained matrix ===
    if l == 1
        %save('-ascii','KcyclesQueen','K');
        save('-ascii','KcyclesBeatles02','K');
    else
        %save('-ascii','KpathsQueen','K');
        save('-ascii','KpathsBeatles02','K');
    end
    
end
toc()
