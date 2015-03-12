function v = findQuerySongs()
%============================================
% Finds the query songs from the Beatles Annotations
%============================================

mydir = '../Self-avoiding/CyclesBeatles';

%=== This is the vector class with songs identifiers ===
ids = tdfread('IdsBeatlesURLSAnnotations.txt');
ids = ids.Ids;
[nr,nc] = size(ids);

%=== This is the order in which they will be read ===
mylist = ls(mydir);
numItems = (length(mylist)/41);
v = [];

for i=1:71 % ONLY THE FIRST 71 SONGS ARE QUERY SONGS
    n = 0;
    cbegin = 1;
    cend = 0;

    %=== For each song in the directory ===
    for j=1:numItems 
        cend = cbegin + 39;
        myfile = mylist(cbegin:(cend-4));
        cbegin = cend + 2;
	
        %=== we verify if it's one of the query songs ===
        if strcmp(ids(i,:),myfile)
			v(i) = j;
            myfile
        end
    end
end
