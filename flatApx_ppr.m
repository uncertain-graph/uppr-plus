function [pprs, flatApxme] = flatApx_ppr(a,c, qu_set,src, tar,ncon,nparts)
    num_qu_set = numel(qu_set);
    num_src = numel(src);
    
    tic
    n = size(a,1);
  
    %tar = cat(1,tar{:});
    % no. of certain and uncertain edges
    ncedges = nnz(a);
    nucedges = size(src, 2);
    
    % each outgoing edge is associated with 1/(c+u) transition prob.
    certransposs = 1 / (ncedges + nucedges);
    
    
    % each uncertain edge without non-existence is given a transition
    % prob. (1/t)x(1/(c+u))
    a1 = a;
    for i = 1:num_src

         ntargets = size(tar{i},2);
         uncertransposs{i} = (1/ntargets) * certransposs;

         for j = 1:ntargets
             if tar{i}(j)~=0
                a1(src(i),tar{i}(j)) = (1/ntargets) * certransposs;
                %a1(tar{i}(j), src(i)) = (1/ntargets) * certransposs;
                
             end
         end
    end

    addtransposs = sum(cell2mat(uncertransposs));

    % uncertain edge 中有non-exist 
    if any(cellfun(@(x) any(x == 0), tar))
        % 无certain edge
        if ncedges == 0
            a1(a1 ~= 0) = a1(a1 ~= 0) + (addtransposs * (1 / nucedges));
           % disp(w)
        else
            % 有certain edge
            a1(a == 1) = certransposs + addtransposs;
            
        end
    else
          % uncertain edge 中没有non-exist
         a1(a == 1) = certransposs;
    end

    % undirected graph 
    %b = triu(a1)+triu(a1)';
    %%% --end Flattening uncertain edges into certain edges %%%
    
    %%% B-LIN %%%
    
    % column normalization
    n = size(a1,1);    % # of nodes
    d = full(sum(a1,2));      % in-degree vector
    % d(~d)=1;
    % w = a1/spdiags(d',0,n,n);
    d_inv = 1./d;
    d_inv(~isfinite(d_inv)) = 0;
    w = a1' * spdiags(d_inv, 0, n, n);
    
    [xadj, adjncy] = coo2csr(w|w');

    flatApx_preCom_time = toc
   
    memo = 0;
    pprs = 0;
    for qu = 1 : num_qu_set
        nqu = numel(qu_set{qu});
        qu_vec = sparse(qu_set{qu}', 1, 1/nqu, n, 1);
        [ppr,blinme] = Blin(w, c, qu_vec, n, ncon, xadj, adjncy, nparts);
        memo = max(memo, blinme);
        pprs = pprs + ppr;
    end
    pprs = pprs /num_qu_set;

    me = whos;
    bytes = [me.bytes].';
    flatApxme = sum(bytes)+memo
end