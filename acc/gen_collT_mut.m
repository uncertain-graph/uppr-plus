function a2 = gen_collT_mut(ds, src, tar)

    fpath =  '..\..\datasets\';
    savefpath = 'data\';
    savepath = [savefpath];
    fn = [fpath, ds, '.mat'];
    load(fn);
    a = Problem.A;
   
    
    num_src = numel(src);
    %% enumerate all target set of possible worlds
    pw = cell(1, numel(tar));
    [pw{:}] = ndgrid(tar{:});
    tars = cell2mat(cellfun(@(v)v(:), pw, 'UniformOutput',false));
    
    npw = size(tars,1);
    
    m = size(a, 2);
   sum_unc_a = sparse(m,m);

    
   % tic

    for i = 1 : npw
        if mod(i, ceil(npw/50)) == 0
                fprintf('.');
            end
        for j = 1: numel(src)
            if tars(i,j)
               
                unc_a(src(j),tars(i,j)) =  1;
            end
        end
        sum_unc_a= sum_unc_a+unc_a;
    end
    
    %% compute average ppr
    a2 = a + sum_unc_a / npw;
    %%%%%%%%% a2 should be used to compute BEAR %%%%%%%%%%%%%%%%

    % [i,j] = find(a2);
    % savefn = [savepath,ds,'.csv'];
    % writematrix([i-1, j-1], savefn,'WriteMode', 'overwrite');

   
   

