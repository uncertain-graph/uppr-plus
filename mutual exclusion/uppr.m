function [ave_pprs,  upprme] = uppr(a, c, qu_set, ncon, nparts, src, tar)
    fprintf('\n >>>>>>>>> UPPR starts >>>>>>>>>>>>>>\n');
    num_qu_set = numel(qu_set);
    num_src = numel(src);
    n = size(a,1);
    
    fprintf('>>>>>>>>> Precomputation starts >>>>>>>>>>>>>>\n');
    %% enumerate possible uncertainity and sum of all uncertainity as P
    pw = cell(1, numel(tar));
    [pw{:}] = ndgrid(tar{:});
    tars = cell2mat(cellfun(@(v)v(:), pw, 'UniformOutput',false));

    npw = size(tars, 1); 
    n = size(a,1);
    P = sparse(n,n);
    for i = 1:npw
        

        for j = 1:num_src
            if tars(i,j)
                 tmp = P(src(j), tars(i,j));
                 P(src(j), tars(i,j)) = tmp + 1;
            end
        end
    end

    %% Inverse certainity
   
    % column normalization of certain transition matrix
    d = full(sum(a,2));      % in-degree vector
    d_inv = 1./d;
    d_inv(~isfinite(d_inv)) = 0;
    w = a' * spdiags(d_inv, 0, n, n);
   
    [xadj, adjncy] = coo2csr(a|a');
    partition = METIS_PartGraphKway(n,ncon,xadj,adjncy,[],[],[],nparts,[],[],[]);
    [par,ix] = sort(partition);

    v0 = find(diff([-1 par]));
    nparts = numel(v0);
    
    [Tbl,x] = blockDiagGraph(w, par,ix, nparts);
    Tx = w - Tbl;
    [Q_inv,~] = block_inv(x, c, nparts);
    
    Tbl =sparse(Tbl);

    Tx = sparse(Tx);
    
    Q_inv = sparse(Q_inv);
    
    
    %% Compute UPPR
    pprs = 0;
    fprintf('>>>>>>>>> Query starts >>>>>>>>>>>>>>\n');
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
    upprme = sum(bytes);
end