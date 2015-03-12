function computeKernel04()
%=== This function computes the interior product from
% cycles among all pairs of cycles
%============================================

%dirs = {'../Self-avoiding/Cycles','../Self-avoiding/Paths'};
dirs = {'../Self-avoiding/CyclesBeatles','../Self-avoiding/CyclesQueen'};

tic();

for l=1:length(dirs)

    dir = dirs{l};
	mylist = ls(dir);
	numItems(l) = (length(mylist)/41)
	n = 0;
	cbegin = 1;
	cend = 0;
    
    %=== We make a list of the ids of the files in the directory ===
    for i=1:numItems(l) 
		['%%%%%%%%%%%%%% ',mat2str(i),' %%%%%%%%%%%%%%'];
		cend = cbegin + 39;
		myfile{l,i} = mylist(cbegin:cend);
		cbegin = cend + 2;
        
        n2 = 0;
        cbegin2 = 1;
        cend2 = 0;
    end

end

totalItems = sum(numItems)

%=== This is the similarity matrix ===
K = zeros(totalItems,totalItems);
	
%=== We compute the matrix in 4 steps ===
%for j=1:numItems(1)
%    'part 1'
%    j
%    %=== We load the file ===
%    file1 = myfile{1,j};
%    path1 = [dirs{1},'/',file1];
%    f1 = load(path1);
%    res1 = f1.saveCycles;
    
%    for k=1:numItems(1)
% 
        %=== We load the file ===
%        file2 = myfile{1,k};
%        path2 = [dirs{1},'/',file2];    
%        f2 = load(path2);
%        res2 = f2.saveCycles;
        
        %=== We compute the inner product ===
%        ip = cycleKernel02(res1,res2);
%        K(j,k) = ip;
        
%    end
%end

%for j=1:numItems(2)
%    'part 2'
%    j
    %=== We load the file ===
%    file1 = myfile{2,j};
%    path1 = [dirs{2},'/',file1];
%    f1 = load(path1);
%    res1 = f1.saveCycles;
    
%    for k=1:numItems(2)
         
        %=== We load the file ===
%        file2 = myfile{2,k};
%        path2 = [dirs{2},'/',file2];    
%        f2 = load(path2);
%        res2 = f2.saveCycles;
        
        %=== We compute the inner product ===
%        ip = cycleKernel02(res1,res2);
%        K(j+numItems(1)-1,k+numItems(1)-1) = ip;
%        
%    end
%end

K1 = zeros(numItems(1),numItems(2));

for j=1:numItems(1)
    'part 3'
    j
    %=== We load the file ===
    file1 = myfile{1,j};
    path1 = [dirs{1},'/',file1];
    f1 = load(path1);
    res1 = f1.saveCycles;
    
    for k=1:numItems(2)
         
        %=== We load the file ===
        file2 = myfile{2,k};
        path2 = [dirs{2},'/',file2];    
        f2 = load(path2);
        res2 = f2.saveCycles;
        
        %=== We compute the inner product ===
        ip = cycleKernel02(res1,res2);
        %K(j,k+numItems(1)-1) = ip;
        K1(j,k) = ip;
        
    end
end

save('-ascii','KcyclesBvsQ','K1');

K2 = zeros(numItems(2),numItems(1));

for j=1:numItems(2)
    'part 4'
    j
    %=== We load the file ===
    file1 = myfile{2,j};
    path1 = [dirs{2},'/',file1];
    f1 = load(path1);
    res1 = f1.saveCycles;
    
    for k=1:numItems(1)
         
        %=== We load the file ===
        file2 = myfile{1,k};
        path2 = [dirs{1},'/',file2];    
        f2 = load(path2);
        res2 = f2.saveCycles;
        
        %=== We compute the inner product ===
        ip = cycleKernel02(res1,res2);
        %K(j+numItems(1)-1,k) = ip;
        K2(j,k) = ip;
        
    end
end

save('-ascii','KcyclesQvsB','K2');
	

%save('-ascii','KcyclesBvsQ','K');

toc()
