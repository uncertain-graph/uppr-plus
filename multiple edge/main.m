
clear;
addpath("..\BLin\");
addpath("..\metismex-master\build\mex\");
addpath("..\metismex-master\build\src\");

fpath =  '..\datasets\';

%%%%%%%%%%%%%%%%%%%%% datasets %%%%%%%%%%%%%%%%%%%%%%%%%
fname = 'cit-HepPh';
fn = [fpath, fname, '.mat'];
load(fn);
a = Problem.A;
%%%%%%%%%%%%%%%% hyperparameter %%%%%%%%%%%%%%%%%%%%%%%%%
m = nnz(a);
n = size(a,2);
c = 0.8;
kmax = 100;
ncon = 1;
nparts = 5;

% %%%%%%%%%%%%%%%%% src, tar, qu %%%%%%%%%%%%%%%%%%%%%%%%%%
l = 6;
d = 4;

src_tarfpath = ['src_tar\','ds_',fname,'_l',int2str(l),'_d',int2str(d),'.mat'];
qufpath = ['qu\','ds_',fname,'_qu','.mat'];

src = load(src_tarfpath).src';

tar =  load(src_tarfpath).tar;

qu_set = load(qufpath).qu;

savefpath = 'results\';
savefn = [savefpath, fname,'_l',int2str(l),'_d',int2str(d),'_res', '.mat'];
save(savefn, 'fname');
%%%%%%%%%%%%%%%%%%%%%%%%%% PPR Calculations %%%%%%%%%%%%%%
upprplust = tic;
[res_upprplus, upprplusmem] = uppr_plus(a, c, qu_set, src, tar, fname);
upprplus_time=toc(upprplust);
save(savefn, "res_upprplus","-append") 

upprt = tic;
[res_uppr, upprmem] = uppr(a, c, qu_set, ncon, nparts, src, tar);
uppr_time = toc(upprt);
save(savefn, "res_uppr","-append") 

[gt, exhmem]  = exh_ppr(a, c, qu_set, src, tar, kmax);
save(savefn, "gt","-append");

exht = tic;
[res_exh, exhmem] = exh_ppr(a, c, qu_set, src, tar, kmax);
exh_time = toc(exht);
save(savefn, "res_exh","-append")

exhApxt = tic;
[res_exhApx, exhApxmem]= exhApx_ppr(a, c, qu_set, src, tar, ncon, nparts);
exhApx_time = toc(exhApxt);
save(savefn, "res_exhApx","-append")

collApxt = tic;
[res_collApxppr, collApxmem] = collApx_ppr(a, c, qu_set, src, tar,ncon,nparts);
collApx_time = toc(collApxt);
save(savefn, "res_collApxppr","-append") 

flatApxt = tic;
[res_flatApx, flatApxmem]= flatApx_ppr(a, c, qu_set, src, tar,ncon, nparts);
flatApx_time = toc(flatApxt);
save(savefn, "res_flatApx","-append")

%%%%%%%%%% save results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alg = {'upprplus';'uppr';'exh'; 'exhApx';'collApx';'flatApx'};
%%%%%%%%%%% save time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time = [upprplus_time; uppr_time; exh_time; exhApx_time; collApx_time; flatApx_time];
filename = 'excel_output\timeppr.xlsx';
T1 = rows2vars(table(alg, time))
writetable(T1, filename, 'Sheet',1, 'Range','D1');

%%%%%%%%%%% save memory %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
memo = [upprplusmem; upprmem; exhmem; exhApxmem; collApxmem; flatApxmem];
filename = 'excel_output\memoryppr.xlsx';
T2 = rows2vars(table(alg, memo))
writetable(T2, filename, 'Sheet',1, 'Range','D1');


