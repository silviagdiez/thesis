function [p,aux] = computeMaze01(N) 

if N == 36

%=== list of points ===
p = zeros(N,N);

%=== horizontal lines (left to right) ===
p(36,1:10) = 1;
p(18,10:18) = 1;
p(28,19:26) = 1;

%=== vertical lines (left to right) ===
p(18:36,10) = 1;
p(1:28,26) = 1; % PATH GOES DOWN
%p(3:28,26) = 1; % PATH DIVIDES
%p(5:28,26) = 1; % PATH DIVIDES
%p(12:28,26) = 1; % PATH GOES UP

%=== values of function V(x,y) ===
value = 15000000;
p = p*value;

%=== destination and source points ===
aux = p;
aux(28,1) =  10000000; 
aux(28,36) = 10000000;
aux(19,36) = 10000000; % Second goal

else

p = [];
'N must be 36'

end

return;

