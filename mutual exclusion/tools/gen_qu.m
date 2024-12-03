function gen_qu(ds)
    fpath =  '..\';
    savepath = [fpath,'qu\'];
   
    fn = [fpath, ds, '.mat'];
    load(fn);
    a = Problem.A;

    G = digraph(a);
    D = outdegree(G);
    [hd, idx] =  sort(D, "descend");
    

    n = length(a);
    stride = 20;
    nqu = 10;
    nq = nqu/(100/stride);
    loca=[];
    for percentiles= stride:stride:100
        loca = [loca floor((n+1)*percentiles/100)-1];
    end
    
    local_startper=[1 1+loca(1:(end-1))];
    local_endper = loca;

    nper = numel(local_startper);
    qu_entries = [];
    for per = 1:nper
         z = idx(local_startper(per):local_endper(per));
         x = z(randperm(length(z), nq))';
         qu_entries =[qu_entries x];
    end
    
    qu={};
    qu{1} = qu_entries;
    savefn = [savepath,'ds_',ds,'_qu', '.mat'];
    disp(savefn)
    save(savefn, 'qu');
