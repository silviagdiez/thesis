function [C,D] = simplePaths04(A,p)
% This function computes all
% self-avoiding simple paths
% of a directed graph.
% J. Ponstein 1966
% S.Garcia-Diez (silviagdiez@gmail.com) 2011
% "p" > maximum length for paths
% "A" > adjacency matrix

%=== Useful variables ===
[nr,nc] = size(A);
cycles = java.util.Hashtable; 
paths = java.util.Hashtable; 
A

%=== We initialize the diagonal matrix ===
D{1} =  diag(diag(A));
'cycles 1'
D{1}

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
    for i=1:nr
        %i
        for j=1:nc
            %j
            if (i ~= j) % PATHS
                %=== C1Cq ===
                row1 = C{1}(i,:)
                col1 = C{q}(:,j)'
                %=== CqC1 ===
                row2 = C{q}(i,:)
                col2 = C{1}(:,j)'
                              
                %=== We multiply by hand ===
                total = 0;
                for k=1:nc
                    if (row1(k)*col1(k)) ~= 0
                        %=== Previous paths ===
                        key1 = [mat2str(1),': ',mat2str(i),',',mat2str(k)];
                        value1 = paths.get(key1)
                    
                        key2 = [mat2str(q),': ',mat2str(k),',',mat2str(j)];
                        value2 = paths.get(key2)'
                        
                        set1 = [value1 value2]
                    
                        key3 = [mat2str(q),': ',mat2str(i),',',mat2str(k)];
                        value3 = paths.get(key3)'
                    
                        key4 = [mat2str(1),': ',mat2str(k),',',mat2str(j)];
                        value4 = paths.get(key4)'
                        
                        set2 = [value3 value4]
                        
                        %=== We check the common members of both sets ===
                    end
                    r1 = row1(k)*col1(k);
                    r2 = row2(k)*col2(k);
                    if (r1 == r2)
                        total = total + r1;
                    end 
                end
                total
                %=== We update the list of self-avoiding PATHS
                % KEY = Iteration : i , j 
                %key = [mat2str(q+1),': ',mat2str(i),',',mat2str(j)];
                %['C',key]
                %value = [value1 value2]
                %paths.put(key,value);
                
            else % CYCLES
                D{q+1}(i,j) = C1Cq(i,j);
            end
        end
    end
    
    ['cycles ',mat2str(q+1)]
    D{q+1}
    
    ['paths ',mat2str(q+1)]
    C{q+1}
     
    %=== We increment q ===
    q = q+1;
end


return
        