function [ppr, ppriterme] = iter_ppr(c, w, s, kmax)
    n = size(w,1);
    %p0 = sparse(1 / n * ones(n,1));
    ppr = s;
    
    %Z = c * w * ppr;
   %tic
   for k = 1:kmax
       ppr = c * w * ppr + (1-c) * s;
      % ppr = (1-c) * w * ppr + c * s;
   end

  % iter_time = toc
   % ppr = ppr/norm(ppr);
    
    me = whos;
    ppriterme = sum([me.bytes].');
end
