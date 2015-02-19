function [alpha,r,x,y,U] = iterativePoisson(a,b,m,n,q,tol,Uini,g,funf,fung)
%----------------------------------------------------------------------
% Usage:       [alpha,r,x,y,U] = poisson (a,b,m,n,q,tol,f,g)
%
% Description: Use the successive over relaxation (SOR) method and
%              three-point central differences to solve the following
%              partial differential equation called the Poisson equation:
%
%                 (d/dx)(d/dx)u(x,y) + (d/dy)(d/dy)u(x,y) = f(x,y)
%
%              in the rectangular region:
%
%                 R = {(x,y): 0 < x < a, 0 < y < b}
%
%              using the Dirichlet type boundary conditions:
%
%                  u(x,y) = g(x,y)
%
% Inputs:      a   = upper limit of x (a > 0)
%              b   = upper limit of y (b > 0)
%              m   = number of steps in x (m >= 1)
%              n   = number of steps in y (n >= 1)
%              q   = upper bound on the number of SOR iterations (q >= 1)
%              tol = upper bound on the magnitude of the difference
%                    between successive solution estimates (tol >= 0)
%              f   = string containing name of right-hand side function
%              g   = string containing name of boundary condition function.
%
%                    The functions f and g are of the form:
%
%                       function z = f(x,y)
%                       functin  z = g(x,y)
%
%                    When f is called, it must return the value f(x,y).
%                    When g is called with (x,y) on the boundary of R,
%                    it must return the boundary value g(x,y). The
%                    arguments f and g are optional in the sense that
%                    either one can be replaced by the empty string ''
%                    When this is done, the corresponding function is 
%                    assumed to be zero which means that a user-supplied
%                    function is NOT required in this case.
%
% Outputs:     alpha = optimal relaxation parameter
%              r     = number of SOR iterations performed 
%              x     = m by 1 vector of x grid points:
%                      x(k) = k*a/(m+1) for 1 <= k <= m.
%              y     = n by 1 vector of y grid points:
%                      y(j) = j*b/(n+1) for 1 <= j <= m.
%              U     = m by n matrix containing the estimated solution
%                      where U(k,j) = u(x(k),y(j)).
%
%              If r is less than the user specified maximum, q, 
%              then the following termination criterion was satisfied
%              where u(i) denotes the ith solution estimatae and 
%              ||u|| is the infinity norm:
%
%                     ||u(i+1) - u(i)|| < tol  
%
% Notes:      When f(x,y) = 0, Poisson's equation reduces to Laplace's
%             equation which is also called the potential equation. 
%----------------------------------------------------------------------

% Initialize 

   u0 = 0;
   i = 0;
   du = 1 + tol;
   
% Compute optimal relaxation parameter 

   dx = a/(m + 1);
   dy = b/(n + 1);
   dx2 = dx*dx;
   dy2 = dy*dy;
   d = 2*(dx2 + dy2);
   rho = ((cos(pi/m) + (dx2/dy2)*cos(pi/n))/(1 + dx2/dy2));
   alpha = (2/(1 + sqrt(1 - rho*rho)));
   beta = alpha;
   x = dx*[1 : m]';
   y = dy*[1 : n]';
   
% Compute initial guess using average of boundary values 

   if fung
      u0 = feval(g,0,0) + feval(g,0,b) + feval(g,a,0) ...
           + feval(g,a,b);  
      for k = 1 : m
         u0 = u0 + feval(g,x(k),0) + feval(g,x(k),b); 
      end  
      for j = 1 : n
         u0 = u0 + feval(g,0,y(j)) + feval(g,a,y(j));
      end 
      u0 = u0/(2.0*(n + m) + 4.0);
   end
   
   U = u0*ones(m,n);
   
   %U = Uini;
   
% Iterate using SOR method 

   hwbar = waitbar (0,'Solving Poisson''s Equation: poisson');  
   while (du >= tol) & (i < q)
      du = 0;
      i = i + 1;

% Lower left corner: (k,j) = (1,1)       

      v = beta*((dy2*U(2,1) + dx2*U(1,2))/d - U(1,1));
      if fung
         v = v + beta*(dy2*feval(g,0,y(1)) + dx2*feval(g,x(1),0))/d;
      end 
      if funf
         v = v - beta*dx2*dy2*Uini(1,1)/d;
      end
      U(1,1) = U(1,1) + v;
      du = max ([du,abs(v)]);

% Interior left edge: k = 1, 1 < j < n       

      for j = 2 : n-1
         v = beta*((dy2*U(2,j) + dx2*(U(1,j+1) + U(1,j-1)))/d - U(1,j));
         if fung
            v = v + beta*dy2*feval(g,0,y(j))/d;
         end    
         if funf
            v = v - beta*dx2*dy2*Uini(1,j)/d;
         end 
         U(1,j) = U(1,j) + v;
         du = max ([du,abs(v)]);
      end

% Upper left corner: (k,j) = (1,n)       

      v = beta*((dy2*U(2,n) + dx2*U(1,n-1))/d - U(1,n));
      if fung
         v = v + beta*(dy2*feval(g,0,y(n)) + dx2*feval(g,x(1),b))/d;
      end     
      if funf
         v = v - beta*dx2*dy2*Uini(1,n)/d;
      end
      U(1,n) = U(1,n) + v;
      du = max ([du, abs(v)]);
   
      for k = 2 : m-1

% Interior bottom: 1 < k < m, j = 1 

         v = beta*((dy2*(U(k+1,1) + U(k-1,1)) + dx2*U(k,2))/d - U(k,1));
         if fung
            v = v + beta*dx2*feval(g,x(k),0)/d;
         end    
         if funf
            v = v - beta*dx2*dy2*Uini(k,1)/d;
         end
         U(k,1) = U(k,1) + v;
         du = max ([du,abs(v)]);
 
% Interior: 1 < k < m, 1 < j < n 

         for j = 2 : n-1
            v = beta*((dy2*(U(k+1,j) + U(k-1,j)) + dx2*(U(k,j+1) ...
                + U(k,j-1)))/d - U(k,j));
            if funf
               v = v - beta*dx2*dy2*Uini(k,j)/d;
            end
            U(k,j) = U(k,j) + v;
            du = max ([du,abs(v)]); 
         end
 
% Interior top: 1 < k < m, j = n/

         v = beta*((dy2*(U(k+1,n) + U(k-1,n)) + dx2*U(k,n-1))/d - U(k,n));
         if fung
            v = v + beta*dx2*feval(g,x(k),b)/d;
         end 
         if funf
            v = v - beta*dx2*dy2*Uini(k,n)/d;
         end     
         U(k,n) = U(k,n) + v;
         du = max ([du,abs(v)]); 
      end

% Lower right corner: (k,j) = (m,1) 
      
      v = beta*((dy2*U(m-1,1) + dx2*U(m,2))/d - U(m,1));
      if fung
         v = v + beta*(dy2*feval(g,a,y(1)) + dx2*feval(g,x(m),0))/d;
      end     
      if funf
         v = v - beta*dx2*dy2*Uini(m,1)/d;
      end     
      U(m,1) = U(m,1) + v;
      du = max ([du,abs(v)]);

% Interior right edge: k = m, 1 < j < n       
     
      for j = 2 : n-1
         v = beta*((dy2*U(m-1,j) + dx2*(U(m,j+1) + U(m,j-1)))/d - U(m,j));
         if fung
            v = v + beta*dy2*feval(g,a,y(j))/d;
         end     
         if funf
            v = v - beta*dx2*dy2*Uini(m,j)/d;
         end     
         U(m,j) = U(m,j) + v;
         du = max ([du,abs(v)]); 
      end
    
% Upper right corner: (k,j) = (m,n)       
     
      v = beta*((dy2*U(m-1,n) + dx2*U(m,n-1))/d - U(m,n));
      if fung
         v = v + beta*(dy2*feval(g,a,y(n)) + dx2*feval(g,x(m),b))/d;
      end    
      if funf
         v = v - beta*dx2*dy2*Uini(m,n)/d;
      end  
      U(m,n) = U(m,n) + v;
      du = max ([du,abs(v)]); 
      waitbar (max(tol/du,i/q))
   end
      
% Finalize 

   r = i;
   close (hwbar);  
 
%----------------------------------------------------------------


