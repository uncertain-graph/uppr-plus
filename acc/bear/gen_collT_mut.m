function gen_collT_mut(ds, src, tar)

    fpath =  'C:\Users\u5550119\OneDrive - University of Warwick\Documents\PageRank\pageRank\datasets\';
    savefpath = 'C:\Users\u5550119\Downloads\bear-master\bear-master_v1_norm_mod\data\';
    savepath = [savefpath,'\bear\'];
    % soc-LiveJournal1
    % it-2004
    % email-EuAll web-Stanford cit-Patents soc-LiveJournal1 
    % uk-2002  arabic-2005  sk-2005
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

   
   

