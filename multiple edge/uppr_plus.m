function [ave_qres, upprplusmem] = uppr_plus_v2(a, c, qu_set, I, tar, fname)
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
   fprintf("========= Finish to get all subsets ==========")

   J = CartesianProduct_multi(target_sets);
   uds = CartesianProduct_multi(len_target_sets);
   npw = size(J,2);
   fprintf('npw: %d',npw);
   % for i = 1:npw
   %      disp(pw{i})
   % end
   time_total = tic;
   
   %%%%%%%%%%%%%%%%% pre-computing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fprintf('\n== BEGIN pre-computing ==\n');
   time2 = tic;

   n = size(a,1);    % # of nodes
   d = full(sum(a,2));      % in-degree vector
   d_inv = 1./d;
   d_inv(~isfinite(d_inv)) = 0;
   T0 = a' * spdiags(d_inv, 0, n, n);

   % R = inv(eye(n)-c*T0);
   % Ri = R(I,:);
   % Rii = R(I,I);
   ei = sparse((1:l)', I', ones(l,1), l, n);
   ei=full(ei);
   

   ilutime = tic;
   T = speye(n) - c * T0;
   [L,U] = ilu(T); 
    
   x = ei / U;
   r = x / L;
   lu_inv = toc(ilutime)
    
   Ri = full(r);  
   % Ri = R(I,:);
   Rii = Ri(:,I);
   
   %d = full(sum(T0(:,I)~=0,1));
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

        fprintf('Start ');
        for w = 1:npw
            if mod(w, ceil(npw/50)) == 0
                fprintf('.');
            end
            Jw = J{w};
            %ud  = cellfun(@length, Jw);
            ud = cat(2,uds{w}{:});
            %lambda1 = diag(ud);
            
            
            % ej = sparse(n,l);

            Rij = sparse(l,l);
            for i = 1:l
                % tmp = 0;
                Rij(:,i) = sum(Ri(:,Jw{i}),2);
                % for j =1:size(Jw{i},2)
                %     if Jw{i}(j) 
                %         tmp = tmp + Ri(:,Jw{i}(j));
                %         %Riej(i,Jw{i}(j) ) = tmp+ ud(i);
                %     end
                %     %ej(Jw{i}(j),i)=1;  
                % end
                % Rij(:,i) = tmp;
            end
            %Riej = full(Riej)
            %ejR = Ri*ej
            lambdaRii = (l1*ud).*Rii;

            hw1 = (Dii-c*Rij+lambdaRii)\p0I;
            %hw1 = (Dii-c*Ri*ej+(l1*ud).*Rii)\p0I;
            
            %E1 = En(:,I)*lambda1*hw1;
            %disp(full(ej))
            %nw1 = ej*c*hw1
            
            %eta = sparse(n,1);
            eta1 = sparse(n,1);
            for i = 1:l
                 eta1(Jw{i}) = eta1(Jw{i})+c*hw1(i);
                % for j =1:size(Jw{i},2)
                %     if Jw{i}(j) 
                %         tmp =  eta(Jw{i}(j));
                %         eta(Jw{i}(j)) = tmp+ c*hw1(i);
                %     end
                % end
               % Riej(:,i) = tmp;
            end
            %nw1 = full(nw1)

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
    fprintf(' >>      # of uncertain degree (target nodes for each uncertain edge) :  %d \n\n', ue_deg);
    
    fprintf(' >>  total CPU time              :  %fs \n', period_total);
    fprintf(' >>    2) pre-computing(lu_inv)          :  %fs  \n', period2); 
    fprintf(' >>    3) query                  :  %fs    (# of queries         : %d,    ave = %fs) \n', period3, num_qu_set, period3/num_qu_set);
    
    me = whos;
    bytes = [me.bytes].';
    upprplusmem = sum(bytes);
end

 