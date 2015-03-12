function Graphs = dataStructureBeatles()
%=======================================================================
% Output: Graphs - a 1xN array of graphs
% 		  Graphs(i).am is the adjacency matrix of the i'th graph, 
% 		  Graphs(i).al is the adjacency list of the i'th graph, 
%         Graphs(i).nl.values is a column vector of node
%                   labels for the i'th graph.
%         Graphs(i) may have other fields, but they will not be
%                   used here.
%=======================================================================

dirs = {'../AdjacencyIntervalsBeatles'};

count = 1;

for l = 1:1

dir = dirs{l};

mylist = ls(dir);
numItems = (length(mylist)/37);
n = 0;
cbegin = 1;
cend = 0;

for i=1:numItems 
	'%%%%%%%%%%%%%% NEW ITEM %%%%%%%%%%%%%%'
	cend = cbegin + 35;
	myfile = mylist(cbegin:cend);
	cbegin = cend + 2;
	
	%=== For each graph ADJACENCY MATRIX ===
	path = [dir,'/',myfile]
	adj = load(path);
	adj = spconvert(adj);
	Graphs(count).am = adj;
    [nr,nc] = size(adj);
    dim = max(nr,nc);
	
	%=== For each graph ADJACENCY LIST ===
    [n,l,s] = find(adj);
    [a,b] = sort(n);
    n = n(b);
    l = l(b);
    s = s(b);
    
    oldInd = 0;
    v = [];
    for j=1:length(n)
        ind = n(j);
        succ = l(j);
        %=== if the value is the same we add it to the vector ===
        if (j > 1) 
            if (ind == oldInd)
                v = [v succ];
            else
                %oldInd
                %v
                Graphs(count).al{oldInd} = v;
                oldInd = ind;
                v = succ;
            end
        else
            v = [v succ];
            oldInd = ind;
        end
    end
    %oldInd
    %v
	Graphs(count).al{oldInd} = v;
    
	
	%=== For each graph NODE LABELS ===
    labels = 1:9100; % I have 9100 different intervals
	labels = labels';
	Graphs(count).nl.values = labels;
    
    %=== We increment the counter of graphs ===
    count = count + 1;

end

end

%=== We save the result ===
save('GraphsBeatles05.mat','Graphs');

return

