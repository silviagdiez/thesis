function testPoisson()

%-------------------------------------------------------------------
   m = 29                 % x precision 		
   n = 29                 % y precision 
   q = 500                % maximum iterations 
   a = 4                  % maximum x 
   b = 4                  % maximim y  
   tol = 1.e-4;		   	   % error bound  
   %=== Example parameters ===
   %g = inline ('exp(y)*cos(x) - exp(x)*cos(y)','x','y');
   g = inline('1/exp(x*y)','x','y');
   f = '';
   fung = 1;
   funf = 0;
   %=== First simple version of boundaries ===
   %g1 = inline('abs(x)+abs(y) == 0','x','y');
   %g2 = inline('(x == 1)*(y == 1)','x','y');
   %=== g(0,0) = g(1,1) = 1 and 0 otherwise ===
   %g = inline('-(((y == 1)*(1 == x))+((y == 0)*(0 == x)))','x','y');% boundary conditions
   %=== First simple version of V ===
   %f = inline('1','x','y'); % V(x,y) cost density
   %=== f = V(x,y) where V simulates a 2D-gaussian ===
   %f = inline('mvnpdf([x y],[2 2],[1 0; 0 1])','x','y'); % V(x,y) cost density
   %fung = 1;
   %funf = 1;

% Find solution

   fprintf ('Example 9.2.2: Steady State Temperature\n');
   [alpha1,r1,x1,y1,U1] = poisson(a,b,m,n,q,tol,f,g,funf,fung);
   %[alpha1,r1,x1,y1,U1] = poisson(a,b,m,n,q,tol,f,g1,funf,fung);
   %U1
   %[alpha2,r2,x2,y2,U2] = poisson(a,b,m,n,q,tol,f,g2,funf,fung);
   %subplot(2,2,1)
   %imagesc(U1)
   %subplot(2,2,2)
   %imagesc(U2)
   %rfr0 = U1(size(U1,1),size(U1,2))
   %np = zeros(size(U1,1),size(U1,2));
   %for i=1:size(U1,1)
	%	for j=1:size(U1,2)
	%		np(i,j) = (U1(i,j)*U2(i,j))/rfr0;
	%	end
   %end
   %['Number of iterations',mat2str(r)]
   %['Optimal relaxation parameter',mat2str(alpha)]
   %du = 0;
   %for i = 1 : m
   %   for j = 1 : n
   %      du = max(du,abs(U(i,j) - g(x(i),y(j))));
   %   end
   %end
   %['maximum error',mat2str(du)]
   %plotxyz (x,y,U,'Steady-State Temperature','x','y','u')
   %surf(x1,y1,U1);
   imagesc(U1);
   %subplot(2,2,3)
   %imagesc(np)

%-------------------------------------------------------------------

return;

