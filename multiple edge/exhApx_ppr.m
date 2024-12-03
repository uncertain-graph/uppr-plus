function  [ave_pprs, exhApxmem] = exhApx_ppr(a, c, qu_set, src, tar,ncon,nparts)
   fprintf('== exhApx STARTS == \n');
    num_qu_set = numel(qu_set);

    %% enumerate all target set of possible worlds
    nedges = numel(src);
    for i = 1:nedges
       target_sets{i} = getAllSubsets(tar{i});
    end
   
    pw = CartesianProduct_multi(target_sets);

    npw = size(pw,2);
   
    qppr = 0;
    n = size(a,1);    % # of nodes
    memo = 0;
    for qu = 1 : num_qu_set
        nqu = numel(qu_set{qu});
        qu_vec = sparse(qu_set{qu}', 1, 1/nqu, n, 1);
        pwppr = 0;
        for i = 1 : npw
            a1 = a;
            for p =1:size(src,2)
                for r = 1:size(pw{i}{p},2)
                    if pw{i}{p}(r)
                        a1(src(p),pw{i}{p}(r)) = 1;
                    end
                end 
            end 
    
            % column norm
            n = size(a1,1);    % # of nodes
            d = full(sum(a1,2)); % in-degree vector
           
            d_inv = 1./d;
            d_inv(~isfinite(d_inv)) = 0;
            w = a1' * spdiags(d_inv, 0, n, n);
            
            [xadj, adjncy] = coo2csr(a1|a1');
          
    
           [rwrs, blinmem] = Blin(w,c,qu_vec,n,ncon,xadj, adjncy, nparts);
           
           
            pwppr = pwppr + rwrs;
            memo = max(memo, blinmem);
        end    
        pwppr = pwppr / npw;

        qppr = qppr + pwppr;
    end
    ave_pprs = qppr / num_qu_set;
   
    me = whos;
    bytes = [me.bytes].';
    exhApxmem = sum(bytes);
    exhApxmem = sum(bytes)+memo;
     fprintf('== Finished ==\n');
end