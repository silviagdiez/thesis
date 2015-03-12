function [A,ht] = convertAdjacency02(A)
% This function changes the adjacency matrix
% into consecutive numbers 
% "A" must be a sparse matrix

%=== Useful variables ===
c = 1;
ht = java.util.Hashtable; 

%=== Values of sparse matrix ===
[k,l,s] = find(A);

for m=1:length(k)
    i = k(m);
    j = l(m);
    %=== Convert A ===
    A(i,j) = c;
    %=== Add entry to hash ===
    key = mat2str(c);
    value = [i j];
    ht.put(key,value);
    %=== Increment c ===
    c = c+1;
end


return
        