function [C,D,cycles,paths] = simplePaths02(A,p)
% This function computes all
% self-avoiding simple paths
% of a directed graph.
% J. Ponstein 1966
% S.Garcia-Diez (silviagdiez@gmail.com) 2011
% "p" > maximum length for paths
% "A" > adjacency matrix

%=== Useful variables ===
sparse(A)
[nr,nc] = size(A);
cycles = java.util.Hashtable; 
paths = java.util.Hashtable; 

%=== We initialize the diagonal matrix ===
D{1} =  diag(diag(A));
sparse(D{1})

%=== We update the list of self-avoiding CYCLES
for i=1:nr
    if D{1}(i,i) ~= 0
        % KEY = Iteration : i , j 
        key = [mat2str(1),': ',mat2str(i),',',mat2str(i)];
        ['D',key];
        value = [D{1}(i,i)];
        cycles.put(key,value);
    end
end

%=== We initialize the cofactor matrix ===
C{1} = A - D{1};
sparse(C{1})

%=== We update the list of self-avoiding PATHS
for i=1:nr
    for j=1:nc
        if C{1}(i,j) ~= 0
            % KEY = Iteration : i , j 
            key = [mat2str(1),': ',mat2str(i),',',mat2str(j)];
            ['C',key];
            value = [C{1}(i,j)];
            paths.put(key,value);
        end
    end
end

%=== We start the iterative computation of simple paths ===
q = 1;
while (q < p)
    
    
    %=== We compute C1Cq and CqC1 ===
    C1Cq = C{1}*C{q};
    CqC1 = C{q}*C{1};
    
    %=== We Define D{q+1} ===
    D{q+1} = diag(diag(C1Cq));
    sparse(D{q+1})
    
    %=== We update the list of self-avoiding CYCLES
    for i=1:nr
        if D{q+1}(i,i) ~= 0
            row = C{1}(i,:);
            col = C{q}(:,i);
            for j=1:nc
                if (row(j) ~= 0) && (col(j) ~= 0)
                    %=== We extract the nodes from previous matrix ===
                    key1 = [mat2str(1),': ',mat2str(i),',',mat2str(j)];
                    value1 = paths.get(key1);
                    key2 = [mat2str(q),': ',mat2str(j),',',mat2str(i)];
                    value2 = paths.get(key2)';
                    key = [mat2str(q+1),': ',mat2str(i),',',mat2str(i)];
                    ['D',key]
                    value = [value1 value2]
                    cycles.put(key,value);
                end
            end
        end
    end
    
    %=== We define C{q+1} as the sum of the terms that occur
    % in both C1Cq and CqC1 ===
    C{q+1} = zeros(nr,nc);
    for i=1:nr
        for j=1:nc
            if (C1Cq(i,j) == CqC1(i,j)) && (i ~= j)
                C{q+1}(i,j) = C1Cq(i,j);
            end
            
        end
    end
    sparse(C{q+1})
    
    %=== We update the list of self-avoiding PATHS
    for i=1:nr
        for j=1:nc
            if (i ~= j) && (C{q+1}(i,j) ~= 0)
                row = C{1}(i,:);
                col = C{q}(:,j);
                for k=1:nc
                    if (row(k) ~= 0) && (col(k) ~= 0)
                        %=== We extract the nodes from previous matrix ===
                        key1 = [mat2str(1),': ',mat2str(i),',',mat2str(k)];
                        value1 = paths.get(key1);
                        key2 = [mat2str(q),': ',mat2str(k),',',mat2str(j)];
                        value2 = paths.get(key2)';
                        % KEY = Iteration : i , j 
                        key = [mat2str(q+1),': ',mat2str(i),',',mat2str(j)];
                        ['C',key]
                        value = [value1 value2]
                        paths.put(key,value);
                    end
                end
            end
        end
    end
     
    %=== We increment q ===
    q = q+1;
end


return
        