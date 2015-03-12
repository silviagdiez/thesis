function computeKernel03()
%=== This function computes the interior product from
% cycles among all pairs of cycles
%============================================


dirs = {'../Self-avoiding/CyclesQueen','../Self-avoiding/PathsQueen'};

tic();

mylist = ls(dirs{1});
numItems = (length(mylist)/41);
n = 0;
cbegin = 1;
cend = 0;

%=== This is the similarity matrix ===
K1 = zeros(numItems,numItems);
K2 = zeros(numItems,numItems);

for i=1:numItems 
    ['%%%%%%%%%%%%%% ',mat2str(i),' %%%%%%%%%%%%%%']
    cend = cbegin + 39;
    myfile1 = mylist(cbegin:cend)
    cbegin = cend + 2;

    %=== We load the file ===
    path1 = [dirs{1},'/',myfile1];
    f1 = load(path1);
    path2 = [dirs{2},'/',myfile1];
    f2 = load(path2);
        
    res1 = f1.saveCycles;
    res2 = f2.savePaths;
    
    n2 = 0;
    cbegin2 = 1;
    cend2 = 0;

    for j=1:numItems 
        cend2 = cbegin2 + 39;
        myfile2 = mylist(cbegin2:cend2);
        cbegin2 = cend2 + 2;

        %=== We load the file ===
        %=== We load the file ===
        path3 = [dirs{1},'/',myfile2];
        f3 = load(path3);
        path4 = [dirs{2},'/',myfile2];
        f4 = load(path4);

        res3 = f3.saveCycles;
        res4 = f4.savePaths;

        %=== We compute the inner product ===
        [ip1,ip2] = pathKernel03(res1,res2,res3,res4);
        K1(i,j) = ip1;
        K2(i,j) = ip2;
    end
end

%=== We save the obtained matrix ===
save('-ascii','KcyclesPathsQueen01','K1');
save('-ascii','KcyclesPathsQueen02','K2');
    
toc()
