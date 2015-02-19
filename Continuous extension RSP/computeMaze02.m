function p = computeMaze02(N) 

if N == 56

%=== list of points ===
p = zeros(N,N);

%=== horizontal lines (up to down) ===
p(13:43,8:11) = 1;
p(13:43,19:22) = 1;
p(13:43,30:33) = 1;
p(13:56,45:48) = 1;

%=== vertical lines (left to right) ===
p(27:30,11:19) = 1;

%=== values of function V(x,y) ===
value = 15000000;
p = p*value;

else

p = [];
'N must be 56'

end

return;

