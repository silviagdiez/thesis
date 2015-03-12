function numCycles = computeCountCycles()
%============================================
% Computes Class vector
%============================================

mydir = '../Self-avoiding/CyclesBeatles';
mylist = ls(mydir);
numItems = (length(mylist)/41);
n = 0;
cbegin = 1;
cend = 0;

numCycles = [];
for i=1:numItems 
	cend = cbegin + 39;
	myfile = mylist(cbegin:(cend-4))
	cbegin = cend + 2;
	
    res = load([mydir,'/',myfile]);
    numCycles = [numCycles; countCycles(res)];
	
end
