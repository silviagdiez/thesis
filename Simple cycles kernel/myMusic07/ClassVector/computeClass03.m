function v = computeClass03()
%============================================
% Computes Class vector
%============================================

mydir = '../Self-avoiding/Cycles';
%dirs = {'../AdjacencyIntervalsSelected','../AdjacencyIntervalsRandom'};
dirs = {'../AdjacencyIntervalsSelected03','../AdjacencyIntervalsRandom03'};


mylist = ls(mydir);
numItems = (length(mylist)/41);
n = 0;
cbegin = 1;
cend = 0;
v = [];

for i=1:numItems 
	cend = cbegin + 39;
	myfile = mylist(cbegin:(cend-4));
	cbegin = cend + 2;
	
	for j=1:length(dirs)
        list2 = ls(dirs{j});
        %=== If the file is in the directory ===
        ind = findstr(list2,myfile);
        if ~isempty(ind)
            v = [v j];
        end
    end	
end
