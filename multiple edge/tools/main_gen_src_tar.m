fpath = '..\datasets\';

folderContents = dir(fpath);
fileNames = {folderContents(~[folderContents.isdir]).name};
ds_names = string(fileNames);

for i = 1: numel(ds_names)
    x = char(ds_names(i));
    dsname = x(1:end-4);
    

    for j =2:2:8
        for k = 2:2:8
            gen_src_tar(dsname, j, k);

        end
    end
    gen_qu(dsname)
 end
