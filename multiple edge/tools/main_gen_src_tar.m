fpath = '/dcs/large/u5550119/datasets/';

folderContents = dir(fpath);
fileNames = {folderContents(~[folderContents.isdir]).name};
ds_names = string(fileNames);
ds_names = ["sk-2005.mat"];
for i = 1: numel(ds_names)
    x = char(ds_names(i));
    dsname = x(1:end-4);
    

    for j =2:2:8
        for k = 1:2:7
            gen_src_tar(dsname, j, k);

        end
    end
   % gen_qu(dsname)
 end
