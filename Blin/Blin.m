function  [rwr,blinme] = Blin(w, c, s, n, ncon, xadj, adjncy, nparts)
%[rwrs , par_t, block_inv_t, parts] = Blin(w, c, s, n, ncon, xadj, adjncy, nparts)
    %% pre-compute
    
    partition = METIS_PartGraphKway(n,ncon,xadj,adjncy,[],[],[],nparts,[],[],'METIS_OBJTYPE_CUT');
    % par_t = toc;

    % sort group no., return with the previous indice
    [par,ix] = sort(partition);
    
    % change dimision if the npart is 1
    % if nparts == 1
    %     par = par';
    % end

    % construct w1 and w2
    [w1, x] = blockDiagGraph(w, par, ix, nparts);

    w2 = w - w1;
    
    v0 = find(diff([-1 par]));
    parts = numel(v0);
    % compute inverse of w1 block-wisely
    % tic
    [Q_inv, ~] = block_inv(x, c, parts);
    % I = speye(n,n);
    % Q_inv = inv(I - c * w1);
    % block_inv_t = toc;

    % Q_inv = Q_inv(ix,ix)
    % rank-k leads to high time cost and error 
    rank_k = min(50, sprank(w2));
    [U,S,V] = svds(w2, rank_k);

    temp = inv(inv(S) - c * V' * Q_inv * U);
    
    %% queries  
   % fprintf('This is blin queries \n');
    %rwrs = 0;

    %Z = c * Q_inv * U * temp * V';


  
    %for i = 1 : size(s,2)
    x = Q_inv * s;
    Y = V' * x;
    O = temp * Y;
    P = U * O;
    E = c * Q_inv * P;

    rwr = (1-c) * (x + E);
        % rwr = rwr(ix);

        % associative law
        % rwr = (1-c) * (Q_inv * s(:,i) + (c * Q_inv * U * temp) * (V' * Q_inv * s(:,i))); 
        %rwrs = rwrs+ rwr;

   % end
   % ave_rwrs = rwrs/size(s,2);
    %ave_rwrs = ave_rwrs/norm(ave_rwrs);
    
   % rwrs = rwrs';

   
    me = whos;
    bytes = [me.bytes].';
    blinme = sum(bytes);
end