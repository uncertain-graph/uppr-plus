function [ave_qres, upprplusmem] = uppr_plus(a, c, qu_set, I, tar, fname)
   num_qu_set = numel(qu_set);
   l = length(I);

   ue_num = l;
   ue_deg = numel(tar{1});
    
   na = size(a,1);
  
   n = max([na, tar{:}]);
   m = nnz(a);
   %%%%%%%%%%%%%%%%% possible worlds %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   nedges = numel(I);
   target_sets= cell(1, nedges);
   len_target_sets= cell(1, nedges);
   for i = 1:nedges
       [target_sets{i}, len_target_sets{i}] = getAllSubsets(tar{i});
   end

   J = CartesianProduct_multi(target_sets);
   uds = CartesianProduct_multi(len_target_sets);
   npw = size(J,2);
 
   time_total = tic;
   
   %%%%%%%%%%%%%%%%% pre-computing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fprintf('\n== BEGIN pre-computing ==\n');
   time2 = tic;

   n = size(a,1);    % # of nodes
   d = full(sum(a,2));      % in-degree vector
   d_inv = 1./d;
   d_inv(~isfinite(d_inv)) = 0;
   T0 = a' * spdiags(d_inv, 0, n, n);

  
   ei = sparse((1:l)', I', ones(l,1), l, n);
   ei=full(ei);
   
   T = speye(n) - c * T0;
   [L,U] = ilu(T); 
    
   x = ei / U;
   r = x / L;
 
   Ri = full(r);  
   
   Rii = Ri(:,I);
   
   Dii = diag(d(I));

   period2 = toc(time2);
   fprintf('== END pre-computing ==\n');
   
   %%%%%%%%%%%%%%%%% online query %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   fprintf('\n== BEGIN online query ==\n');
   time3 = tic;
    
   qres = 0;
   for qu=1:num_qu_set
        nqu = numel(qu_set{qu});
        quvec = sparse(qu_set{qu}', 1, 1/nqu, n, 1);
        if (mod(qu, 1) == 0)
            fprintf(' query #%d\n', qu);
        end
        p0 = lu_ppr(L,U, quvec, c);

        p0I = p0(I);

        
    
        l1 = ones(l,1);
        lambda_hw = sparse(l,1);
        nw = sparse(n,1);
   %%%%%%%% average hw, nw over pws %%%%%%%%%%%%%%%%%%%%%%%%     
        for w = 1:npw
           
            Jw = J{w};
           
            ud = cat(2,uds{w}{:});
            Rij = sparse(l,l);
            for i = 1:l
              
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
        fprintf('\n');
    %%%%%%%% advancing aggregation end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hw = lambda_hw / npw;
        xi = sparse(I, 1, hw, n, 1);
        
        ave_nw = nw / npw;
        
        zeta = ave_nw - xi;
    
        pw = p0 + xi + (1/(1-c))*lu_ppr(L,U, zeta,c);
        res = full(pw);
        qres = qres + res;
   end
   
   ave_qres = qres/num_qu_set;

   %%%%%%%% printing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    period3 = toc(time3);
    fprintf('== END online query ==\n');
    period_total = toc(time_total);
    
    fprintf('\n\n========== total stats (UPPR+) ============\n\n');
    
    fprintf(' >>         dataset              :  %s \n', fname);
    fprintf(' >>      # of nodes              :  %d \n', n);
    fprintf(' >>      # of edges              :  %d \n\n', m);
    fprintf(' >>      # of uncertain edges  (source nodes)  :  %d \n\n', ue_num);
    fprintf(' >>      # of uncertain degree (target nodes for each uncertain edge) :  %d \n\n', ue_deg+1);
    
    fprintf(' >>  total CPU time              :  %fs \n', period_total);
    fprintf(' >>    2) pre-computing(lu_inv)          :  %fs  \n', period2); 
    fprintf(' >>    3) query                  :  %fs    (# of queries         : %d,    ave = %fs) \n', period3, num_qu_set, period3/num_qu_set);
    
    me = whos;
    bytes = [me.bytes].';
    upprplusmem = sum(bytes);
end

 
