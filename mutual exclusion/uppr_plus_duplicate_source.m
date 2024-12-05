function pw = uppr_plus_duplicate_source(a, src, tar, qu_set, c)
    num_qu_set = numel(qu_set);
    n = size(a,1);    % # of nodes
    d = full(sum(a'));      % in-degree vector
    d(~d)=1;
    q0 = a' /spdiags(d', 0, n, n);
    
    nsrc  = numel(src);
    tar0 = cellfun(@(x) x, tar, 'UniformOutput', false);
    tars = cell(1,nsrc);
    [tars{end:-1:1}] = ndgrid(tar0{end:-1:1}); 
    % ndgrid replicates the grid vectors x1,x2,...,xn to produce an n-dimensional full grid.
    tars = cat(nsrc+1, tars{:});
    tars = reshape(tars,[],nsrc);  % npw x nsrc matrix

    I = unique(src,'stable');
    I_  = sort(I);
    ud = histc(src,I_);
    l = numel(I);
    % R = inv(eye(n)-c*q0);
    % Ri = R(I,:);
    ei = sparse((1:l)', I', ones(l,1), l, n);
    ei=full(ei);
       
    ilutime = tic;
    T = speye(n) - c * q0;
    [L,U] = ilu(T); 
    
    x = ei / U;
    r = x / L;
    lu_inv = toc(ilutime);
    
    Ri = full(r); 
    
    Rii = Ri(:,I);
    Dii = diag(sum(a(I,:),2));
    
    
    l1 = ones(l,1);
    for qu=1:num_qu_set
        nqu = numel(qu_set{qu});
        quvec = sparse(qu_set{qu}', 1, 1/nqu, n, 1);
        if (mod(qu, 1) == 0)
            fprintf(' query #%d\n', qu);
        end
        p0 = lu_ppr(L,U, quvec, c)
        p0I = p0(I,:);
        
        lambda_hw = sparse(l,1);
        nw = sparse(n,1);
        npw = size(tars,1);
        
        
        for w = 1:npw
            
           if mod(w, ceil(npw/50)) == 0
               fprintf('.');
           end
           J_tars = tars(w,:);
           
         
           Jw = cell(1,l);
           for i = 1:l
               tmp = [];
               for j = 1: nsrc
                   if src(j) == I(i)
                      tmp = [tmp J_tars(j)];
                   end
               end
               Jw{i} = tmp;
            
               Rij(:,i) = sum(Ri(:,Jw{i}),2);   
                
           end
            
           lambdaRii = (l1*ud).*Rii;
           hw1 = (Dii-c*Rij+lambdaRii)\p0I;
            
            
           eta1 = sparse(n,1);
           for i = 1:l
                eta1(Jw{i}) = eta1(Jw{i})+c*hw1(i);
           end
            
           lambda_hw = lambda_hw + ud'.*hw1;
           nw = nw + eta1;
        
        end
        hw = lambda_hw / npw;
        xi = sparse(I, 1, hw, n, 1);
        
        ave_nw = nw / npw;
        zeta = ave_nw - xi;
        pw = p0 + xi + (1/(1-c))*lu_ppr(L,U, zeta,c);
    end

end