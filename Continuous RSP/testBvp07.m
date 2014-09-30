function testBvp07(N,D) 
%=============================================================================
% "N" < size of the grid
% "D" < diffussion coefficient [0,1)
% solve BVP2: D*z" + (- 4*D - V(x,y)) * z = -4*D*delta(x)*delta(y)
% with z(t0) = z0, z(tf) = zf by the finite difference method 
% for a NxN grid
% Implemented by Silvia Garcia 2011.
% From the book "Applied Numerical Methods for Engineers: Using Matlab anc C"
% Schilling and Harris.
%=============================================================================

t0 = 0;
tf = 4;
z0 = 1;
zf = 1;

np = bvp_fdf07(t0,tf,z0,zf,N,D); 

return;

