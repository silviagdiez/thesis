function [u,x,y,G] = poisson04(U0,g,D,Mx,My,tol,MaxIter,opt) 
%=== This version computes the initial values ===
% solve u_xx + u_yy + g(x,y)u = f(x,y) 
% over the region D = [x0,xf,y0,yf] = {(x,y) |x0 <= x <= xf, y0 <= y <= yf} 
% with the boundary Conditions: 
% u(x0,y) = bx0(y), u(xf,y) = bxf(y) 
% u(x,y0) = by0(x), u(x,yf) = byf(x) 
% Mx = # of subintervals along x axis 
% My = # of subintervals along y axis 
% tol	: error tolerance 
% MaxIter: the maximum # of iterations
% opt: 1 for Forward variable, 2 for Backward

%=== We define the domain for the function ===
x0 = D(1); 
xf = D(2); 
y0 = D(3); 
yf = D(4); 

%=== Step size ===
% dx = (xf - x0)/Mx; 
% dy = (yf - y0)/My;
dx = (xf - x0)/(Mx + 1); 
dy = (yf - y0)/(My + 1);

%=== X and Y values ===
% x = x0 + [0:Mx]*dx
% y = y0 + [0:My]'*dy

%=== Step size ===
x = dx*[1 : Mx]';
y = dy*[1 : My]';

%=== Number of subintervals + 1 === 
Mx1 = Mx + 1;
My1 = My + 1; 
Mx2 = Mx + 2;
My2 = My + 2; 

%=== Boundary conditions ===
u = zeros(Mx2,My2);
if opt == 1
	u(2,1) = 1;
	u(1,2) = 1;
else
	u(Mx2,Mx1) = 1;
	u(Mx1,Mx2) = 1;
end

%=== We initialize as the average of boundary values ===
sum_of_bv = sum(sum([u(2:My1,[1 Mx2]) u([1 My2],2:Mx1)'])); 
u(2:My1,2:Mx1) = sum_of_bv/(2*(Mx1 + My1 - 2)); 

%=== We compute the values of g(x,y) ===
for i = 1:My
	for j = 1:Mx 
		G(i,j) = g(x(j),y(i));
		F(i,j) = U0(i,j);
	end
end

%=== Squared step sizes ===
dx2 = dx*dx; 
dy2 = dy*dy; 
dxy2 = 2*(dx2 + dy2); 

%=== Values of ry, rx, rxy ===
rx = dx2/dxy2; 
ry = dy2/dxy2; 
rxy = rx*dy2; 

%=== We iteratively compute u(x,y) according to Eq.(9.1.5a) ===
u0 = realmax; %Fixed by Silvia
for itr = 1:MaxIter
	for j = 2:Mx 
		for i = 2:My
			u(i,j) = ry*(u(i,j+1) + u(i,j-1)) + rx*(u(i+1,j) + u(i-1,j)) + rxy*(G(i,j)*u(i,j)- F(i,j)); 
		end
	end
	if (itr > 1) & (max(max(abs(u-u0))) < tol)
		break; 
	end
	u0 = u; 
end

%=== We return part of the matrix ===
aux = u(2:My1,2:Mx1);
u = aux;