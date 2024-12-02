function p = lu_ppr(L,U, qu, c)
n = size(L,1);
%p = sparse(qu', 1, 1/nqu, n, 1, n);
x = L \ qu;
p = U \ x;
% for k=1:kmax
%     p = c*w*p + p0;
% end
p = (1-c)*p;
%p = p/norm(p);