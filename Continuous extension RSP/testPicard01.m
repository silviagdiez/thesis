function testPicard01(N)

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

%=== Poisson parameters for initialization ===
a = 4;
b = 4;
m = N;
n = N;
q = MaxIter;
tol = tol;
f = inline('-4*(x == 0)*(y == 0)','x','y'); % D = 1
g = inline('(x == 0)*(y == 0)','x','y'); 
funf = 1;
fung = 1;

%[alpha,r,x,y,U0] = poisson(a,b,m,n,q,tol,f,g,funf,fung)
[u,x,y,G] = poisson04(f,g,D,Mx,My,tol,MaxIter)
imagesc(U0)

%=== We re-compute the right side of the equation ===
norm = inline('mvnpdf([x y],[2 2],[0.1 0; 0 0.1])','x','y');
for i=1:length(x)
	for j=1:length(y)
		aux(
		
[u,x,y,G] = poisson02(f,g,time,D,Mx,My,tol,MaxIter)

%=== f(x,y) and g(x,y) ===
f = inline('0','x','y');  
g = inline('mvnpdf([x y],[2 2],[0.1 0; 0 0.1])','x','y'); 

%=== Call the procedure (1st time) ===
%[U1,x1,y1,G] = picard01(f,g,D,tol,MaxIter)

%=== Call the procedure (2nd time) ===
%[U2,x2,y2,G] = poisson02(f,g,2,D,Mx,My,tol,MaxIter);
%aux2 = U2(2:aux-1,2:aux-1)

%=== average number of passages ===
%rfr0 = aux1(N-1,N-1)
%np = zeros(N-1,N-1);
%for i=1:N-1
%	for j=1:N-1
%		np(i,j) = (aux1(i,j)*aux2(i,j))/rfr0;
%	end
%end


%subplot(2,2,1)
%imagesc(G)
%subplot(2,2,2)
%imagesc(U1)
%subplot(2,2,3)
%imagesc(aux2)
%subplot(2,2,4)
%imagesc(np)

%=== Plot ===
%mesh(x,y,U) 
%surf(x,y,U)
%axis([0 4 0 4 -100 100])

%-------------------------------------------------------------------

return;

