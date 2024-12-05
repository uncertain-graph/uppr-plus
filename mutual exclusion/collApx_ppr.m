function [pprs, collApxme] = collApx_ppr(a, c, qu_set, src, tar,ncon,nparts)
    num_qu_set = numel(qu_set);
    num_src = numel(src);
    fprintf('== collApx STARTS == \n');
    %% enumerate all target set of possible worlds
    pw = cell(1, numel(tar));
    [pw{:}] = ndgrid(tar{:});
    tars = cell2mat(cellfun(@(v)v(:), pw, 'UniformOutput',false));
    
    fprintf("== Start Aggregation == \n")
    npw = size(tars,1);

    m = size(a, 2);
    sum_unc_a = sparse(m,m);


    for i = 1 : npw
        unc_a = sparse(m,m);
        if mod(i, ceil(npw/50)) == 0
                fprintf('.');
            end
        for j = 1: numel(src)
            if tars(i,j)
               
                unc_a(src(j),tars(i,j)) =  1;
            end
        end
        sum_unc_a= sum_unc_a+unc_a;
    end
    
    %% compute average ppr
    a2 = a + sum_unc_a / npw; 
    fprintf("\n== Finished Aggregation == \n")
    [xadj, adjncy] = coo2csr(a2|a2');

    % column norm
    n = size(a2,1);    % # of nodes
    d = full(sum(a2,2));      % in-degree vector
    d_inv = 1./d;
    d_inv(~isfinite(d_inv)) = 0;
    w = a2' * spdiags(d_inv, 0, n, n);
    
    colApx_preComp_time = toc;
    
    blint = tic;
    memo = 0;
    pprs=0;
    fprintf('== Querying == \n');
    for qu = 1 : num_qu_set
        nqu = numel(qu_set{qu});
        qu_vec = sparse(qu_set{qu}', 1, 1/nqu, n, 1);
        [ppr, blinme] = Blin(w, c, qu_vec, n, ncon, xadj, adjncy, nparts);
    
        memo = max(memo, blinme);
        pprs = pprs + ppr;
    end
    pprs = pprs / num_qu_set;
    blintime = toc;
    
    me = whos;
    bytes = [me.bytes].';
    collApxme = sum(bytes)+memo;
    fprintf('== Finished == \n');
end