function  [pprs, exhApxme] = exhApx_ppr(a, c, qu_set, src, tar,ncon,nparts)

    num_qu_set = numel(qu_set);
    fprintf('\n >>>>>>>>> exhApx starts >>>>>>>>>>>>>>\n');
    %% enumerate all target set of possible worlds
    pw = cell(1, numel(tar));
    [pw{:}] = ndgrid(tar{:});
    tars = cell2mat(cellfun(@(v)v(:), pw, 'UniformOutput',false));
    n = size(a,1);
    %% compute average ppr
    npw = size(tars,1);
    memo = 0;
    pprs = 0;
    for qu = 1:num_qu_set
        nqu = numel(qu_set{qu});
        qu_vec = sparse(qu_set{qu}', 1, 1/nqu, n, 1);
        ppr = 0;
        for i = 1 : npw 
           
           % tic
            a1 = a;
             for j = 1: numel(src)
                if tars(i,j) 
                    a1(src(j),tars(i,j)) = 1;
                end
             end
    
            % column norm
            n = size(a1,1);    % # of nodes
            d = full(sum(a1,2)); % in-degree vector
            % d(~d)=1;
            % w = a1 / spdiags(d', 0, n, n);
            d_inv = 1./d;
            d_inv(~isfinite(d_inv)) = 0;
            w = a1' * spdiags(d_inv, 0, n, n);
            
            [xadj, adjncy] = coo2csr(a1|a1');
            %npw_preCompute = toc
    
           [rwrs, blinme] = Blin(w,c,qu_vec,n,ncon,xadj, adjncy, nparts);
           % [rwrs, par_t, block_inv_t, parts] = Blin(w, c, s, n, ncon, xadj, adjncy, nparts);
           
            ppr = ppr + rwrs;
            memo = max(memo, blinme);
        end    
        ppr = ppr/npw;
        pprs = pprs+ppr;
    end
    pprs = pprs/num_qu_set;
   

    %pprs = [pprs ppr];
    me = whos;
    bytes = [me.bytes].';
    exhApxme = sum(bytes)
    exhApxme = sum(bytes)+memo;
end