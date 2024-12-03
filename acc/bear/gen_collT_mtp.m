function gen_collT_mtp(ds, src, tar)

    fpath =  '..\..\datasets\';
    savefpath = '\data\';
    savepath = [savefpath];

    fn = [fpath, ds, '.mat'];
    load(fn);
    a = Problem.A;
   
    
    num_src = numel(src);
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
  
    for i = 1 : npw
        %disp(pw{i})
        unc_a = sparse(m,m);
         if mod(i,100)==0
            fprintf('.');
         end

         for p =1:size(src,2)
            for r = 1:size(pw{i}{p},2)
                if pw{i}{p}(r)
                    tmp = unc_a(src(p),pw{i}{p}(r));
                    unc_a(src(p),pw{i}{p}(r)) = tmp+1;
                end
            end 
         end 
       % disp(full(unc_a))
        %sum_unc_a= sum_unc_a+unc_a;
    end
    fprintf('\n');
    a2 = a + unc_a / npw;
    
    [i,j] = find(a2);
    savefn = [savepath,ds,'.csv'];
    writematrix([i-1, j-1], savefn,'WriteMode', 'overwrite');

   
   

