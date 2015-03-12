function testMathieu()

%=== This is the maximum length of cycles ===
p = 5; 
%=== Example matrix with two simple cycles: (1,2,3,4,5) and (1,6,5) ===
A = [0     1     0     0     0     1
     0     0     1     0     0     0
     0     0     0     1     0     0
     0     0     0     0     1     0
     1     0     0     0     0     0
     0     0     0     0     1     0];
 
%=== We transform the matrix into a sparse matrix and give an ID to each edge ===
[S,ht] = convertAdjacency02(A);
[C,D,cycles,paths] = simplePaths06(S,p);


%=== We print the results ===
'These are all simple cycles'
e = cycles.keys();
 
while e.hasMoreElements()
 	key = e.nextElement();
    c = cycles.get(key)';
    newcycle = [];
    for i=1:length(c)
         %=== We recover the original edge ===
         b = mat2str(c(i));
         aux = ht.get(b)';
         newcycle = [newcycle aux(1)];
     end
     newcycle
end

%=== We print the results ===
'These are all simple paths'
e = paths.keys();
 
while e.hasMoreElements()
     key = e.nextElement();
     p = paths.get(key)';
     newpath = [];
     for i=1:length(p)
         %=== We recover the original edge ===
         b = mat2str(p(i));
         aux = ht.get(b)';
         newpath = [newpath aux(1)];
     end
     newpath 	
end

%=== IMPORTANT NOTICE: EACH SIMPLE CYCLE/PATH APPEARS AS MANY TIMES AS ITS
%LENGHT ===

return
        