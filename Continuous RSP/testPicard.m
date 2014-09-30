function testPicard()

%-------------------------------------------------------------------
[U0,Uf] = picardForward(10);
[U0,Ub] = picardBackward(10);

[a,b] = size(Uf);
res = zeros(a,b);
rfr0 = Uf(a,b);
for i=1:a
	for j=1:b
		res(i,j) = Uf(i,j)*Ub(i,j)/rfr0;
	end
end

res
imagesc(res)

%-------------------------------------------------------------------

return;

