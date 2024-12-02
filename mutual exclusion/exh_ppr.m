function [ave_pprs, exhmem] = exh_ppr (a, src, tar, c, qu_set, kmax)
    num_qu_set = numel(qu_set);
    num_src = numel(src);

    %% enumerate all target set of possible worlds
    pw = cell(1, numel(tar));
    [pw{:}] = ndgrid(tar{:});
    tars = cell2mat(cellfun(@(v)v(:), pw, 'UniformOutput',false));
    
    %% compute average ppr
    npw = size(tars,1);
    qppr = 0;
    n = size(a,1);    % # of nodes
    memo = 0;
    for qu = 1 : num_qu_set
        nqu = numel(qu_set{qu});
        qu_vec = sparse(qu_set{qu}', 1, 1/nqu, n, 1);
        pwppr = 0;
        for i = 1 : npw
            
            % construct a1
            a1 = a;
            for j = 1 : num_src 
                if tars(i,j) 
                    a1(src(j),tars(i,j)) = 1;
                end
            end
            
            % compute w = col_norm(a1)
            d = full(sum(a1,2));    % in-degree vector
            d_inv = 1./d;
            d_inv(~isfinite(d_inv)) = 0;
            w = a1' * spdiags(d_inv, 0, n, n);
            
            % compute traditional ppr
            [ppr, ppriterme] = iter_ppr(c, w, qu_vec, kmax);
            pwppr = pwppr + ppr;
            
            memo = max(memo, ppriterme);
        end

        pwppr = pwppr / npw;

        qppr = qppr + pwppr;
        
    end
    ave_pprs = qppr / num_qu_set;
    
    
    mem = whos;
    exhmem = sum([mem.bytes]) + memo


