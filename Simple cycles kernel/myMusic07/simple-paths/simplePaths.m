function [C,D] = simplePaths(p,A)
% This function computes all
% self-avoiding simple paths
% of a directed graph.
% J. Ponstein 1966
% Implemented by Silvia Garcia-Diez 2011
% "p" > maximum length for paths
% "A" > adjacency matrix

%=== Useful variables ===
[nr,nc] = size(A);

%=== We initialize the diagonal matrix ===
D{1} =  diag(diag(A));
D{1};

%=== We initialize the cofactor matrix ===
C{1} = A - D{1};

%=== We start the iterative computation of simple paths ===
q = 1;
while (q < p)
    
    
    %=== We compute C1Cq and CqC1 ===
    C1Cq = C{1}*C{q};
    CqC1 = C{q}*C{1};
    
    %=== We Define D{q+1} ===
    D{q+1} = diag(diag(C1Cq));
    D{q+1};
    
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
    C{q+1};
    
    %=== We increment q ===
    q = q+1;
end

%=== We print the result ===
C{p};

return
        