function testPoisson02(N)

%-------------------------------------------------------------------

%=== f(x,y) and g(x,y) ===
f = inline('0','x','y'); 
%g = inline('1','x','y'); 
g = inline('mvnpdf([x y],[2 2],[0.1 0; 0 0.1])','x','y'); 

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

%=== Maximum number iterations ===
MaxIter = 500; 
tol = 1e-4; 

%=== Call the procedure (1st time) ===
[U1,x1,y1,G] = poisson02(f,g,1,D,Mx,My,tol,MaxIter);
aux = size(U1);
aux1 = U1(2:aux-1,2:aux-1)

%=== Call the procedure (2nd time) ===
[U2,x2,y2,G] = poisson02(f,g,2,D,Mx,My,tol,MaxIter);
aux2 = U2(2:aux-1,2:aux-1)

%=== average number of passages ===
rfr0 = aux1(N-1,N-1)
np = zeros(N-1,N-1);
for i=1:N-1
	for j=1:N-1
		np(i,j) = (aux1(i,j)*aux2(i,j))/rfr0;
	end
end


subplot(2,2,1)
imagesc(G)
subplot(2,2,2)
imagesc(aux1)
subplot(2,2,3)
imagesc(aux2)
subplot(2,2,4)
imagesc(np)

%=== Plot ===
%mesh(x,y,U) 
%surf(x,y,U)
%axis([0 4 0 4 -100 100])

%-------------------------------------------------------------------

return;

