function gen_collT_mut(ds, src, tar)

    fpath =  '..\..\datasets\';
    savefpath = '..\data\';
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
    unc_a = sparse(m,m);

    
   % tic

    for i = 1 : npw
        if mod(i,100)==0
           fprintf('.');
        end
        for j = 1: numel(src)
            if tars(i,j)
                tmp = unc_a(src(j),tars(i,j));
                unc_a(src(j),tars(i,j)) = tmp + 1;
            end
        end
    end
    fprintf('\n');
    %% compute average ppr
    a2 = a + unc_a / npw;
    
    [i,j] = find(a2);
    savefn = [savepath,ds,'.csv'];
    writematrix([i-1, j-1], savefn,'WriteMode', 'overwrite');

   
   

