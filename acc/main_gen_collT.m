clear;
fpath =  '..\datasets\';

folderContents = dir(fpath);
fileNames = {folderContents(~[folderContents.isdir]).name};
ds_names = string(fileNames);


l = 6;
d = 4;
ds_names = ["cit-HepPh.mat"];
for i = 1: numel(ds_names)
    x = char(ds_names(i));
    disp(x)
    dsname = x(1:end-4);
    disp(dsname)

    stpath= '..\mutual exclusion\';
    src_tarfpath = [stpath,'src_tar\','ds_',dsname,'_l',int2str(l),'_d',int2str(d),'.mat'];
    src = load(src_tarfpath).src;
    tar =  load(src_tarfpath).tar;

    mut_a = gen_collT_mut(dsname, src, tar);
    fprintf('\n');

    stpath= '..\multiple edge\';
    src_tarfpath = [stpath,'src_tar\','ds_',dsname,'_l',int2str(l),'_d',int2str(d),'.mat'];
    src = load(src_tarfpath).src';
    tar =  load(src_tarfpath).tar;
    mtp_a = gen_collT_mtp(dsname, src, tar);
    fprintf('\n');
 end
