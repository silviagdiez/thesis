function [C,D,cycles,paths] = simplePaths05(A,p)
% This function computes all
% self-avoiding simple paths
% of a directed graph.
% Article by: J. Ponstein 1966
% Implemented by: S.Garcia-Diez (silviagdiez@gmail.com) 2011
% "p" > maximum length for paths
% "A" > adjacency matrix

%=== Useful variables ===
[nr,nc] = size(A);
cycles = java.util.Hashtable; 
paths = java.util.Hashtable; 

%=== We initialize the diagonal matrix ===
D{1} =  diag(diag(A));
'cycles 1';
D{1};

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
'paths 1';
C{1};

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
    
    ['======== cycles ',mat2str(q+1),' ===========']
    %=== We compute C1Cq and CqC1 ===
    C1Cq = C{1}*C{q};
    CqC1 = C{q}*C{1};
    
    %=== We define C{q+1} as the sum of the terms that occur
    % in both C1Cq and CqC1 ===
    C{q+1} = zeros(nr,nc);
    D{q+1} = zeros(nr,nc);
    for i=1:nr
        for j=1:nc  
                if (C1Cq(i,j) ~= 0)
                    
                %=== C1Cq ===
                row1 = C{1}(i,:);
                col1 = C{q}(:,j)';
                %=== CqC1 ===
                row2 = C{q}(i,:); 
                col2 = C{1}(:,j)';
                
                %=== We multiply BY HAND !!! ===
                total = 0;
                newpaths = [];
                for k=1:nc
                    if (row1(k)*col1(k)) ~= 0
                        
                        %=== Previous paths ===
                        key1 = [mat2str(1),': ',mat2str(i),',',mat2str(k)];
                        value1 = paths.get(key1);
                        [a1,b1] = size(value1);
                        if (b1 ~= 1)
                            value1 = value1';
                            [a1,b1] = size(value1);
                        end
                        %value1
                        
                        key2 = [mat2str(q),': ',mat2str(k),',',mat2str(j)];
                        value2 = paths.get(key2);
                        [a2,b2] = size(value2);
                        if (b2 ~= q)
                            value2 = value2';
                            [a2,b2] = size(value2);
                        end
                        %value2
                        
                        if ((a1 ~= 0) && (a2 ~= 0))
                            
                        %=== We compute all possible set combinations
                        for l=1:nc
                            
                            %=== Previous paths ===
                            key3 = [mat2str(q),': ',mat2str(i),',',mat2str(l)];
                            value3 = paths.get(key3);
                            [a3,b3] = size(value3);
                            if (b3 ~= q)
                                value3 = value3';
                                [a3,b3] = size(value3);
                            end
                            %value3
                    
                            key4 = [mat2str(1),': ',mat2str(l),',',mat2str(j)];
                            value4 = paths.get(key4);
                            [a4,b4] = size(value4);
                            if (b4 ~= 1)
                                value4 = value4';
                                [a4,b4] = size(value4);
                            end
                            %value4
                            
                            if ((a3 ~= 0) && (a4 ~= 0))
                                
                                %=== We create all possible sets ===
                                for m=1:a1
                                    for n=1:a2
                                        for o=1:a3
                                            for r=1:a4
                                                set1 = [value1(m,:) value2(n,:)];
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
                        end % END if ((a1 ~= 0) && (a2 ~= 0))   
                                
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
    end
    
    ['cycles ',mat2str(q+1)];
    D{q+1};
    
    ['paths ',mat2str(q+1)];
    C{q+1};
     
    %=== We increment q ===
    q = q+1;
end


return
        