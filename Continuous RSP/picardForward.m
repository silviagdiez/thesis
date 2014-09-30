function [Uini,U1] = picardForward(N)

%-------------------------------------------------------------------

%=== x in [0,4] ===
x0 = 0;
xf = 4;

%=== y in [0,4] === 
y0 = 0;
yf = 4;

%=== Function domain === 
D = [x0 xf y0 yf]; 

%=== Maximum number iterations ===
MaxIter = 500; 
tol = 1e-4; 

%=== Normal function ===
V = inline('mvnpdf([x y],[2 2],[0.1 0; 0 0.1])','x','y'); 

%=== Poisson parameters for initialization ===
a = 4;
b = 4;
m = N;
n = N;
q = MaxIter;
tol = tol;
%f = inline('-4*(x == 0)*(y == 0)','x','y'); % D = 1
%g = inline('(x == 0)*(y == 0)','x','y'); 
f = inline('-4*(abs(x-0.3636)<0.001)*(abs(y-0.3636)<0.001)','x','y'); % D = 1
g = inline('(abs(x-0.3636)<0.001)*(abs(y-0.3636)<0.001)','x','y'); 
funf = 1;
fung = 1;

%=== We initialize the matrix U ===
[alpha,r,x,y,U0] = poisson(a,b,m,n,q,tol,f,g,funf,fung);
Uini = U0;

%=== We iterate until convergence ===
mydif = realmax;
steps = 0;
while (mydif > tol) && (steps < MaxIter)

	imagesc(U0)
	reply = input('Do you want more? Y/N [Y]: ', 's');

	%=== We update the value of U0 ===
	for i=1:N
		for j=1:N
			%U0(i,j) = U0(i,j)*V(x(i),y(j));
		end
	end

	%=== We iterate to compute U ===
	[alpha,r,x,y,U1] = iterativePoisson(a,b,m,n,q,tol,U0,g,funf,fung);
	
	mydif = norm(abs(U1-U0),inf)/(N*N);
	steps = steps+1
	U0 = U1
	
end


%-------------------------------------------------------------------

return;

