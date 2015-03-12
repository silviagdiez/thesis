function [A,ht,c] = convertAdjacency(A)
% This function changes the adjacency matrix
% into consecutive numbers 

%=== Useful variables ===
[nr,nc] = size(A);
c = 1;
ht = java.util.Hashtable; 

for i=1:nr
    for j=1:nc
        if A(i,j) ~= 0
            %=== Convert A ===
            A(i,j) = c;
            %=== Add entry to hash ===
            key = mat2str(c);
            value = [i j];
            ht.put(key,value);
            %=== Increment c ===
            c = c+1;
        end
    end
end


return
        