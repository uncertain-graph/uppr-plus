function [pprs, collApxmem] = collApx_ppr(a, c, qu_set, src, tar,ncon,nparts)
    fprintf('== collApx STARTS == \n');
    num_qu_set = numel(qu_set);
    num_src = numel(src);
    tic
    %% enumerate all target set of possible worlds
    nedges = numel(src);
    for i = 1:nedges
        target_sets{i} = getAllSubsets(tar{i});
    end
   
    pw = CartesianProduct_multi(target_sets);
    npw = size(pw,2);

    
    qppr = 0;
    m = size(a, 2);
    sum_unc_a = sparse(m,m);
    memo = 0;
  
    fprintf("== Start Aggregation == \n")
    for i = 1 : npw
        %disp(pw{i})
        unc_a = sparse(m,m);
         if mod(i, ceil(npw/50)) == 0
           fprintf('.');
         end

         for p =1:size(src,2)
            for r = 1:size(pw{i}{p},2)
                if pw{i}{p}(r)
                    unc_a(src(p),pw{i}{p}(r)) = 1;
                end
            end 
         end 
      
        sum_unc_a= sum_unc_a+unc_a;
    end
    fprintf('\n');
    a2 = a + sum_unc_a / npw;

    [xadj, adjncy] = coo2csr(a2|a2');

    % column norm
    n = size(a2,1);    % # of nodes
    d = full(sum(a2,2));      % in-degree vector
   
    d_inv = 1./d;
    d_inv(~isfinite(d_inv)) = 0;
    w = a2' * spdiags(d_inv, 0, n, n);
    
    colApx_preComp_time = toc;
    
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
    
    me = whos;
    bytes = [me.bytes].';
    collApxmem = sum(bytes)+memo;
    fprintf('== Finished == \n');
end
