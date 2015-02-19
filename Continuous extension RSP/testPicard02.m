function testPicard02()

%-------------------------------------------------------------------
%=== Maximum number iterations ===
MaxIter = 500; 
tol = 1e-4; 
N = 10;
g = inline('0','x','y'); 

%=== x in [0,4] ===
x0 = 0;
xf = 4;

%=== y in [0,4] === 
y0 = 0;
yf = 4;

%=== number of steps ===
Mx = N; 
My = N; 

%=== Function domain === 
D = [x0 xf y0 yf]; 

%=== Forward variable ===
[U0,Uf] = picardForward(N);
%subplot(2,3,1);
%imagesc(U0);

%=== We now iterate over U0 ===
mydif = realmax;
steps = 0;
while (mydif > tol) && (steps < MaxIter)
	[U1,x,y,G] = poisson04(U0,g,D,Mx,My,tol,MaxIter,1);
	steps = steps + 1;
	mydif = norm(abs(U1-U0),inf)/(N*N);
	U0 = U1;
end

Uf = U0
%subplot(2,3,2);
%imagesc(Uf);

%=== Backward variable ===
[U0,Ub] = picardBackward(N);

%subplot(2,3,3);
%imagesc(U0);

%=== We now iterate over U0 ===
mydif = realmax;
steps = 0;
while (mydif > tol) && (steps < MaxIter)
	imagesc(U0)
	reply = input('Do you want more? Y/N [Y]: ', 's');
	[U1,x,y,G] = poisson04(U0,g,D,Mx,My,tol,MaxIter,2);
	steps = steps + 1;
	mydif = norm(abs(U1-U0),inf)/(N*N);
	U0 = U1;
end

Ub = U0
%subplot(2,3,4);
%imagesc(Ub);

%=== Compute mean number of passages ===
[a,b] = size(Uf)
res = zeros(a,b)
rfr0 = Ub(a,b)
for i=1:a
	for j=1:b
		res(i,j) = Uf(i,j)*Ub(i,j)/rfr0;
	end
end
%subplot(2,3,5);
%imagesc(res);

%-------------------------------------------------------------------

return;

