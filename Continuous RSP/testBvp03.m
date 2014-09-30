function testBvp03(N) 
% solve BVP2: z" + (- 4 - h^2 * lambda * s) * z = 0 
% with z(t0) = z0, z(tf) = zf 
% by the finite difference method 
% and for a NxN grid

t0 = 0;
tf = 4;
z0 = 1;
zf = 1;

np = bvp_fdf03(t0,tf,z0,zf,N); 

return;

