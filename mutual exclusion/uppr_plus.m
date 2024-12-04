function [ave_qres, incme] = uppr_plus(a, c, qu_set, src, tar, fname)
    num_qu_set = numel(qu_set);
    
    na = size(a,1); 
    ue_num = numel(src);
    ue_deg = numel(tar{1});
    

    nsrc = numel(src);
    n = max([na, tar{:}]);
    m = nnz(a);
    a(n,n) = 0;
    if (n>na) 
       d(n,1) = 0;
    end

    fprintf('# of nodes = %d\n', n);
    fprintf('# of edges = %d\n', m);
    
    %%%%%%%%%%%%%% possible worlds %%%%%%%%%%%%%%%%%%%%%%
    % possible target sets 
    tar0 = cellfun(@(x) x, tar, 'UniformOutput', false);
    tars = cell(1,nsrc);
    [tars{end:-1:1}] = ndgrid(tar0{end:-1:1}); 
    % ndgrid replicates the grid vectors x1,x2,...,xn to produce an n-dimensional full grid.
    tars = cat(nsrc+1, tars{:});
    tars = reshape(tars,[],nsrc); 

    %%%%%%%%%%%%%%%% index possible worlds %%%%%%%%%%%%%%
    time_total = tic;
    npw = size(tars,1);
  
    fprintf('\n== BEGIN pre-computing ==\n');
    time2 = tic;

    % same column norm as UPPR
    n = size(a,1);    % # of nodes
    d = full(sum(a,2));      % in-degree vector
    d_inv = 1./d;
    d_inv(~isfinite(d_inv)) = 0;
    q0 = a' *spdiags(d_inv, 0, n, n);
    clear a;
    
    %%% r = ei*(I-cQ)^-1 pre-computing for the later indexing, containing
    %%% [(I-cQ)^-1]i,j , [(I-cQ)^-1]i,i and others.
    ei = sparse((1:nsrc)', src', ones(nsrc,1), nsrc, n);
    ei=full(ei);
    
    T = speye(n) - c * q0;
    [L,U] = ilu(T); 
    
    x = ei / U;
    r = x / L;
 
    r = full(r);  
    period2 = toc(time2);
    fprintf('== END pre-computing ==\n');
    
    fprintf('\n== BEGIN online query ==\n');
    time3 = tic;
    
    qres = 0;
    for qu=1:num_qu_set
        nqu = numel(qu_set{qu});
        quvec = sparse(qu_set{qu}', 1, 1/nqu, n, 1);
        if (mod(qu, 1) == 0)
            fprintf(' query #%d\n', qu);
        end
        ppr0 = lu_ppr(L,U, quvec, c);      
    
        h = zeros(nsrc,1);
        eta = sparse(n,1);
     %%%%%%%% average hw, nw over pws %%%%%%%%%%%%%%%%%%%%%%%% 
        for i=1:npw      
            tar_i = tars(i,:);
            idx_i = find(tar_i);
            tar_i = tar_i(idx_i)';
            src_i = src(idx_i)';
            ntar_i = numel(tar_i);
            
            h_w = inv(diag(d(src_i))-c*r(idx_i,tar_i)+r(idx_i,src_i))*ppr0(src_i);
            eta_w = sparse(tar_i, 1, c*h_w, n, 1);

            h = h + h_w;
            eta = eta + eta_w;
        end
         %%%%%%%% advancing aggregation end %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        xi = sparse(src_i, 1, h/npw, n, 1);  
        zeta = eta/npw - xi;
        
        res = ppr0 + xi + 1/(1-c) * lu_ppr(L,U,zeta,c);
        res = full(res);
        qres = qres + res;
    end
    ave_qres = qres/num_qu_set;


    %%%%%%%% printing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    period3 = toc(time3);
    fprintf('== END online query ==\n');
    period_total = toc(time_total);

    me = whos;
    bytes = [me.bytes].';
    incme = sum(bytes);

    fprintf('\n\n========== total stats (UPPR+) ============\n\n');
    
    fprintf(' >>         dataset              :  %s \n', fname);
    fprintf(' >>      # of nodes              :  %d \n', n);
    fprintf(' >>      # of edges              :  %d \n\n', m);
    fprintf(' >>      # of uncertain edges  (source nodes)  :  %d \n\n', ue_num);
    fprintf(' >>      # of uncertain degree (target nodes for each uncertain edge) :  %d \n\n', ue_deg);
    
    fprintf(' >>  total CPU time              :  %fs \n', period_total);
    fprintf(' >>    2) pre-computing(lu_inv)          :  %fs  \n', period2); 
    fprintf(' >>    3) query                  :  %fs    (# of queries         : %d,    ave = %fs) \n', period3, num_qu_set, period3/num_qu_set);
    fprintf(' >>  total memory                  :  %d   \n', incme);
    
end