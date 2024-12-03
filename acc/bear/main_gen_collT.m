clear;
addpath("C:\Users\u5550119\OneDrive - University of Warwick\NAIVE PPR\mule_naive_ppr")
fpath =  'C:\Users\u5550119\OneDrive - University of Warwick\Documents\PageRank\pageRank\datasets\';

folderContents = dir(fpath);
fileNames = {folderContents(~[folderContents.isdir]).name};
ds_names = string(fileNames);


l = 6;
de = 4;
d = de-1;
ds_names = ["cit-HepPh.mat","email-EuAll.mat","web-Stanford.mat","cit-Patents.mat"];
for i = 1: numel(ds_names)
    x = char(ds_names(i));
    disp(x)
    dsname = x(1:end-4);
    disp(dsname)
    
    src_tarfpath = [fpath,'src_tar_mule\','ds_',dsname,'_l',int2str(l),'_d',int2str(d),'.mat'];
    src = load(src_tarfpath).src;
    tar =  load(src_tarfpath).tar;
    
    gen_collT_mtp(dsname, src, tar)
    %gen_collT_mut(dsname, src, tar)
 end