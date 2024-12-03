function [ave_pprs,  upprmem] = uppr(a, c, qu_set, ncon, nparts, src, tar)
    fprintf('== UPPR STARTS == \n');
    num_qu_set = numel(qu_set);
    num_src = numel(src);
    %% enumerate possible uncertainity and sum of all uncertainity as P
    nedges = numel(src);
    for i = 1:nedges
        target_sets{i} = getAllSubsets(tar{i});
    end
    
    pw = CartesianProduct_multi(target_sets);

    npw = size(pw,2);
    n = size(a,1);
    P = sparse(n,n);

    tic
    fprintf('== Start P aggregation == \n');
    for i = 1:npw
       if mod(i, ceil(npw/50)) == 0
           fprintf('.');
       end
       tmp = sparse(n,n);
       for p =1:num_src
            for r = 1:size(pw{i}{p},2)
                if pw{i}{p}(r)
                   tmp = P(src(p),pw{i}{p}(r));
                   P(src(p),pw{i}{p}(r)) = tmp + 1;
                end
            end
       end
    end
    fprintf('\n');
    

    %% Inverse certainity
    % column normalization of certain transition matrix
    d = full(sum(a,2));      % in-degree vector
    d_inv = 1./d;
    d_inv(~isfinite(d_inv)) = 0;
    w = a' * spdiags(d_inv, 0, n, n);

    fprintf('== Partitioning == \n')
    [xadj, adjncy] = coo2csr(a|a');
    partition = METIS_PartGraphKway(n,ncon,xadj,adjncy,[],[],[],nparts,[],[],'METIS_OBJTYPE_CUT');
    [par,ix] = sort(partition);

    v0 = find(diff([-1 par]));
    nparts = numel(v0);
    
    fprintf('== Block-wise inversion ==\n')
    [Tbl,x] = blockDiagGraph(w, par,ix, nparts);
    Tx = w - Tbl;
    [Q_inv,~] = block_inv(x, c, nparts);
    
    
    %% Compute UPPR
    pprs = 0;
    fprintf('== Querying ==\n')
    for qu = 1 : num_qu_set
        nqu = numel(qu_set{qu});
        qu_vec = sparse(qu_set{qu}', 1, 1/nqu, n, 1);

        Z = Q_inv *qu_vec;
        Y = Tx * Z; % Tx * Q_inv *s(:,i)
        X = Q_inv * Y; % Q_inv * Tx * Q_inv *s(:,i)

        r1 = (1-c) * Z;
        r2 = c*(1-c) * X;
        r3 = 1/n *  c *(1-c)* (Q_inv * (P * Z));
        r4 =  c^2 * (1-c) * (Q_inv * (Tx * X));
        r5 = 1/n * c^2 * (1-c) *(Q_inv *(P * X));
        r6 = 1/n * c^2 * (1-c) *(Q_inv *(Tx*(Q_inv*(P * Z))));
        ppr = r1 + r2 + r3 + r4 + r5 + r6;
        pprs = pprs + ppr; 
    end 
    ave_pprs = pprs / num_qu_set;
    
    me = whos;
    bytes = [me.bytes].';
    upprmem = sum(bytes);
    fprintf('== Finished ==\n')
end