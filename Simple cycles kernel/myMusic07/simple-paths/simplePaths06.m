function [C,D,cycles,paths] = simplePaths06(A,p)
% This function computes all
% self-avoiding simple paths and cycles
% of a directed graph.
% Article by: J. Ponstein 1966
% Implemented by: S.Garcia-Diez (silviagdiez@gmail.com) 2011
% "p" > maximum length for paths
% "A" > sparse adjacency matrix

%=== Useful variables ===
cycles = java.util.Hashtable; 
paths = java.util.Hashtable; 
[nr,nc] = size(A);
if nr ~= nc
    dim = max(nr,nc);
    A(dim,dim) = 0;
else
    dim = nr;
end


%=== We initialize the diagonal matrix ===
D{1} = sparse(dim,dim);
%size(D{1},1)
%size(D{1},2)
[k,l,s] = find(diag(diag(A))); % Returns the list of non-zero entries
for m=1:length(k)
    i = k(m);
    j = l(m);
    value = s(m);
    D{1}(i,j) = value;
end
'cycles 1';
%size(D{1},1)
%size(D{1},2)
D{1};

%=== We update the list of self-avoiding CYCLES
[k,l,s] = find(D{1}); % Returns the list of non-zero entries
for m=1:length(k)
    i = k(m);
    j = l(m);
    value = s(m);
    if value ~= 0
        % KEY = Iteration : i , j 
        key = [mat2str(1),': ',mat2str(i),',',mat2str(j)];
        ['D',key];
        cycles.put(key,value);
    end
end

%=== We initialize the cofactor matrix ===
C{1} = sparse(dim,dim);
%[nr,nc] = size(D{1})
%[nr,nc] = size(A-D{1})
C{1} = A - D{1};

'paths 1';
C{1};

%=== We update the list of self-avoiding PATHS
[k,l,s] = find(C{1}); % Returns the list of non-zero entries
for m=1:length(k)
    i = k(m);
    j = l(m);
    value = s(m);
    if value ~= 0
        % KEY = Iteration : i , j 
        key = [mat2str(1),': ',mat2str(i),',',mat2str(j)];
        ['C',key];
        paths.put(key,value);
    end
end

%=== We start the iterative computation of simple paths ===
q = 1;
while (q < p)
    
    ['======== cycles ',mat2str(q+1),' ===========']
    %=== We compute C1Cq and CqC1 ===
    C1Cq = C{1}*C{q};
    
    %=== We define C{q+1} as the sum of the terms that occur
    % in both C1Cq and CqC1 ===
    %C{q+1} = sparse(nr,nc);
    %D{q+1} = sparse(nr,nc);
    C{q+1} = sparse(dim,dim);
    D{q+1} = sparse(dim,dim);
    [n,l,s] = find(C1Cq); % Returns the list of non-zero entries
    
    for m=1:length(n)
        
        %=== Indexes ===
        i = n(m);
        j = l(m);
        
        %=== C1Cq ===
        row1 = C{1}(i,:);
        col1 = C{q}(:,j);
        
        %=== CqC1 ===
        row2 = C{q}(i,:);
        col2 = C{1}(:,j);
        
        %=== We multiply BY HAND !!! ===
        total = 0;
        newpaths = [];
        [n2,l2,s2] = find(row1);
        
        %=== For each element in the row 1 ===
        for m2=1:length(n2) 
            iniR = n2(m2);
            endR = l2(m2);
            
            % We check if there are any elements in the column that match
            [n3,l3,s3] = find(col1);
            
            %=== For each element in the column 1 ===
            for m3=1:length(n3) 
                iniC = n3(m3);
                endC = l3(m3);
                
                if (endR == iniC) % This product matches
                    
                    %=== Previous paths ===
                    key1 = [mat2str(1),': ',mat2str(i),',',mat2str(endR)];
                    value1 = paths.get(key1);
                    [a1,b1] = size(value1);
                    if (b1 ~= 1)
                        value1 = value1';
                        [a1,b1] = size(value1);
                    end
                    
                    %value1

                    key2 = [mat2str(q),': ',mat2str(iniC),',',mat2str(j)];
                    value2 = paths.get(key2);
                    [a2,b2] = size(value2);
                    if (b2 ~= q)
                        value2 = value2';
                        [a2,b2] = size(value2);
                    end
                    
                    %value2
                    
                    if ((a1 ~= 0) && (a2 ~= 0))
                    
                    %=== We check if this path exists in CqC1 ===
                    [n4,l4,s4] = find(row2);
                    
                    %=== For each element in the row 2 ===
                    for m4=1:length(n4) 
                        iniR2 = n4(m4);
                        endR2 = l4(m4);
                        
                        % We check if there are any elements in the column that match
                        [n5,l5,s5] = find(col2);
                        
                        %=== For each element in the column 2 ===
                        for m5=1:length(n5) 
                            iniC2 = n5(m5);
                            endC2 = l5(m5);
                            
                            if (endR2 == iniC2) % This product matches
                                
                                %=== Previous paths ===
                                key3 = [mat2str(q),': ',mat2str(i),',',mat2str(endR2)];
                                value3 = paths.get(key3);
                                [a3,b3] = size(value3);
                                if (b3 ~= q)
                                    value3 = value3';
                                    [a3,b3] = size(value3);
                                end
                                
                                %value3

                                key4 = [mat2str(1),': ',mat2str(iniC2),',',mat2str(j)];
                                value4 = paths.get(key4);
                                [a4,b4] = size(value4);
                                if (b4 ~= 1)
                                    value4 = value4';
                                    [a4,b4] = size(value4);
                                end
                                
                                %value4
                                
                                if ((a3 ~= 0) && (a4 ~= 0))
                                    
                                %=== We create all possible sets ===
                                for u=1:a1
                                    for v=1:a2
                                        for o=1:a3
                                            for r=1:a4
                                                set1 = [value1(u,:) value2(v,:)];
                                                set2 = [value3(o,:) value4(r,:)];
                                                
                                                %=== We verify if ANY of both sets share elements ===
                                                %=== (1) We find a new path ===
                                                if (length(set1) <= length(set2))
                                                    ism = ismember(set1,set2);
                                                    auxpaths =  set1(ism);
                                                else
                                                    ism = ismember(set2,set1);
                                                    auxpaths = set2(ism);
                                                end
                                                %=== (2) We add it ===
                                                if (sum(ism) == (q+1))
                                                    newpaths = [newpaths; auxpaths];
                                                    
                                                    %=== (3) We update the total product ===
                                                    auxvalue = 1;
                                                    for s=1:length(auxpaths)
                                                        auxvalue = auxvalue * auxpaths(s);
                                                    end
                                                    total = total + auxvalue;
                                                    
                                                end
                                            end
                                        end
                                    end
                                end
                                end
                            end
                        end
                    end
                    end % END if ((a1 ~= 0) && (a2 ~= 0)
                    
                    %=== We update C{q+1} and D{q+1} ===
                    if (~isempty(newpaths))
                        if i == j
                            %=== We update the list of self-avoiding CYCLES
                            % KEY = Iteration : i , j 
                            key = [mat2str(q+1),': ',mat2str(i),',',mat2str(j)];
                            ['D',key];
                            newpaths;
                            cycles.put(key,newpaths);
                            D{q+1}(i,j) = total;
                        else
                            %=== We update the list of self-avoiding PATHS
                            % KEY = Iteration : i , j 
                            key = [mat2str(q+1),': ',mat2str(i),',',mat2str(j)];
                            ['C',key];
                            newpaths;
                            paths.put(key,newpaths);
                            C{q+1}(i,j) = total;
                        end
                    end
                end
            end
        end
    end
    ['cycles ',mat2str(q+1)];
    D{q+1};
    
    ['paths ',mat2str(q+1)];
    C{q+1};
     
    %=== We increment q ===
    q = q+1;
end

return
        