%% load results
clear;
res_path = 'results\';

load([res_path, '%%%%%%resulte file%%%%%'])
bear = load([res_path,'%%%%%%resulte file of bear%%%%%']).bearppr;

k = 50;
k = min(k, length(gt));

%% rank of ppr
[~, exhPPR_rank] = sort(gt,'descend');
[~, collApxppr_rank] = sort(res_collApxppr,'descend');
[~, exhApxppr_rank] = sort(res_exhApx,'descend');
[~, flatApxPPR_rank] = sort(res_flatApx,'descend');
[~, upprE5_rank] = sort(res_uppr,'descend');
[~, gt_rank] = sort(gt,'descend');
[~, inc_rank] = sort(res_upprplus,'descend');
[~, bear_rank] = sort(bear,'descend');

%% Evaluate with metrics
%% spearman rho
[rho_exhppr, ~] = corr(res_exh, gt, 'Type', 'Spearman');
[rho_exhApxppr, ~] = corr(res_exhApx, gt, 'Type', 'Spearman');
[rho_collApxppr, ~] = corr(res_collApxppr, gt, 'Type', 'Spearman');
[rho_flatApxPPR, ~] = corr(res_flatApx, gt, 'Type', 'Spearman');
[rho_upprE5, ~] = corr(res_uppr, gt, 'Type', 'Spearman');
[rho_inc, ~] = corr(res_upprplus, gt, 'Type', 'Spearman');
[rho_bear, ~] = corr(bear, gt, 'Type', 'Spearman');

%% Kendall's Tau 
[tau_exhppr, ~] = corr(res_exh, gt, 'Type', 'Kendall');
[tau_exhApxppr, ~] = corr(res_exhApx, gt, 'Type', 'Kendall');
[tau_collApxppr, ~] = corr(res_collApxppr, gt, 'Type', 'Kendall');
[tau_flatApxPPR, ~] = corr(res_flatApx, gt, 'Type', 'Kendall');
[tau_upprE5, ~] = corr(res_uppr, gt, 'Type', 'Kendall');
[tau_inc, ~] = corr(res_upprplus, gt, 'Type', 'Kendall');
[tau_bear, ~] = corr(bear, gt, 'Type', 'Kendall');

%% MAP
map_exhppr = map(res_exh, gt);
map_exhApxppr = map(res_exhApx, gt);
map_collApxppr = map(res_collApxppr, gt);
map_flatApxPPR = map(res_flatApx, gt);
map_upprE5 = map(res_uppr, gt);
map_inc = map(res_upprplus, gt);
map_bear = map(bear, gt);

%% Euclidean Distance
euc_exhppr = norm(res_exh - gt);
euc_exhApxppr = norm(res_exhApx - gt);
euc_collApxppr = norm(res_collApxppr - gt);
euc_flatApxPPR = norm(res_flatApx - gt);
euc_upprE5 = norm(res_uppr - gt);
euc_inc = norm(res_upprplus - gt);
euc_bear = norm(bear - gt);

%% save in excel
map = [map_inc, map_upprE5, map_bear,map_exhppr map_exhApxppr  map_collApxppr   map_flatApxPPR]';
rho = [rho_inc, rho_upprE5,rho_bear, rho_exhppr rho_exhApxppr  rho_collApxppr   rho_flatApxPPR]';
tau = [tau_inc, tau_upprE5, tau_bear,tau_exhppr tau_exhApxppr  tau_collApxppr   tau_flatApxPPR]';
euc = [euc_inc, euc_upprE5, euc_bear,euc_exhppr euc_exhApxppr  euc_collApxppr   euc_flatApxPPR]';

alg = {'upprplus';'uppr';'bear';'exh'; 'exhApx'; 'collApx'; 'flatApx'};
T_ppr = table(alg, map, rho, tau, euc)

filename = 'accppr.xlsx';
writetable(T_ppr, filename, 'Sheet',1, 'Range','D1');
