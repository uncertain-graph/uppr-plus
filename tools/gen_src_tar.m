function  gen_src_tar(ds, l, d)

    fpath =  '/dcs/large/u5550119/datasets/';
    savepath = [fpath,'src_tar/'];
    % soc-LiveJournal1
    % it-2004
    % email-EuAll web-Stanford cit-Patents soc-LiveJournal1 
    % uk-2002  arabic-2005  sk-2005
    fn = [fpath, ds, '.mat'];
    load(fn);
    a = Problem.A;

   
    n = length(a);
    %src =  randperm(n, l);
    G = digraph(a);
    D = outdegree(G);
    [hd, idx] =  sort(D, "descend");
    src = idx(1:l);

    tar = cell(l,1);
    for i = 1 : l
        z = find(~a(src(i),:));
        tar{i} = z(randperm(length(z), d));
    end

    savefn = [savepath,'ds_',ds,'_l',int2str(l),'_d',int2str(d), '.mat'];
    disp(savefn)
    save(savefn, 'src','tar');