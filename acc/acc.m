%% load results
clear;
res_path = 'C:\Users\u5550119\OneDrive - University of Warwick\Desktop\inc\acc\HP mut results\';

%HP mtp results  %HP mut results

load([res_path, 'cit-HepPh_l6_d4_res20241201.mat'])
bear = load([res_path,'ch_bearppr_res.mat']).bearppr;
gt = gt;

k = 50;
k = min(k, length(gt));

%% rank of ppr
[~, exhPPR_rank] = sort(gt,'descend');
%[~, collPPR_rank] = sort(res_coll_v2,'descend');
%[~, collApx2ppr_rank] = sort(collApx2,'descend');
[~, collApxppr_rank] = sort(res_collApxppr,'descend');
[~, exhApxppr_rank] = sort(res_exhApx,'descend');
%[~, flatPPR_rank] = sort(res_flat,'descend');
[~, flatApxPPR_rank] = sort(res_flatApx,'descend');
[~, upprE5_rank] = sort(res_uppr,'descend');
[~, gt_rank] = sort(gt,'descend');
[~, inc_rank] = sort(res_upprplus,'descend');
[~, bear_rank] = sort(bear,'descend');

%% Evaluate with metrics
%% nDCG

% nDCG_exhppr = ndcg(res_exh, gt, k);
% nDCG_exhApxppr = ndcg(res_exhApx, gt, k);
% nDCG_collppr = ndcg(res_coll_v2, gt, k);
% nDCG_collApxppr = ndcg(res_collApxppr, gt, k);
% nDCG_collApx2ppr = ndcg(collApx2, gt, k);
% nDCG_flatppr = ndcg(res_flat, gt, k);
% nDCG_flatApxppr = ndcg(res_flatApx, gt, k);
% nDCG_uppr = ndcg(res_uppr, gt, k);
% nDCG_inc = ndcg(res_upprplus, gt, k);
% nDCG_bear = ndcg(bear, gt, k);
% 
% nDCG_exhppr_rank = ndcg(exhPPR_rank, gt_rank, k);
% nDCG_exhApxppr_rank = ndcg(exhApxppr_rank, gt_rank, k);
% nDCG_collppr_rank = ndcg(collPPR_rank, gt_rank, k);
% nDCG_collApxppr_rank = ndcg(collApxppr_rank, gt_rank, k);
% nDCG_collApx2ppr_rank = ndcg(collApx2ppr_rank, gt_rank, k);
% nDCG_flatppr_rank = ndcg(flatPPR_rank, gt_rank, k);
% nDCG_flatApxppr_rank = ndcg(flatApxPPR_rank, gt_rank, k);
% nDCG_uppr_rank = ndcg(upprE5_rank, gt_rank, k);
% nDCG_inc_rank = ndcg(inc_rank, gt_rank, k);
% nDCG_bear_rank = ndcg(bear_rank, gt_rank, k);
%% spearman rho


% [rho_exhppr_rank, ~] = corr(exhPPR_rank, gt_rank, 'Type', 'Spearman');
% [rho_exhApxppr_rank, ~] = corr(exhApxppr_rank, gt_rank, 'Type', 'Spearman');
% [rho_collppr_rank, ~] = corr(collPPR_rank, gt_rank, 'Type', 'Spearman');
% [rho_collApxppr_rank, ~] = corr(collApxppr_rank, gt_rank, 'Type', 'Spearman');
% [rho_collApx2ppr_rank, ~] = corr(collApx2ppr_rank, gt_rank, 'Type', 'Spearman');
% [rho_flatPPR_rank, ~] = corr(flatPPR_rank, gt_rank, 'Type', 'Spearman');
% [rho_flatApxPPR_rank, ~] = corr(flatApxPPR_rank, gt_rank, 'Type', 'Spearman');
% [rho_upprE5_rank, ~] = corr(upprE5_rank, gt_rank, 'Type', 'Spearman');
% [rho_inc_rank, ~] = corr(inc_rank, gt_rank, 'Type', 'Spearman');
% [rho_bear_rank, ~] = corr(bear_rank, gt_rank, 'Type', 'Spearman');

[rho_exhppr, ~] = corr(res_exh, gt, 'Type', 'Spearman');
[rho_exhApxppr, ~] = corr(res_exhApx, gt, 'Type', 'Spearman');
%[rho_collppr, ~] = corr(res_coll_v2, gt, 'Type', 'Spearman');
[rho_collApxppr, ~] = corr(res_collApxppr, gt, 'Type', 'Spearman');
%[rho_collApx2ppr, ~] = corr(collApx2, gt, 'Type', 'Spearman');
%[rho_flatPPR, ~] = corr(res_flat, gt, 'Type', 'Spearman');
[rho_flatApxPPR, ~] = corr(res_flatApx, gt, 'Type', 'Spearman');
[rho_upprE5, ~] = corr(res_uppr, gt, 'Type', 'Spearman');
[rho_inc, ~] = corr(res_upprplus, gt, 'Type', 'Spearman');
[rho_bear, ~] = corr(bear, gt, 'Type', 'Spearman');
%% Kendall's Tau 
% [tau_exhppr_rank, ~] = corr(exhPPR_rank, gt_rank, 'Type', 'Kendall');
% [tau_exhApxppr_rank, ~] = corr(exhApxppr_rank, gt_rank, 'Type', 'Kendall');
% %[tau_collppr_rank, ~] = corr(collPPR_rank, gt_rank, 'Type', 'Kendall');
% [tau_collApxppr_rank, ~] = corr(collApxppr_rank, gt_rank, 'Type', 'Kendall');
% %[tau_collApx2ppr_rank, ~] = corr(collApx2ppr_rank, gt_rank, 'Type', 'Kendall');
% %[tau_flatPPR_rank, ~] = corr(flatPPR_rank, gt_rank, 'Type', 'Kendall');
% [tau_flatApxPPR_rank, ~] = corr(flatApxPPR_rank, gt_rank, 'Type', 'Kendall');
% [tau_upprE5_rank, ~] = corr(upprE5_rank, gt_rank, 'Type', 'Kendall');
% [tau_inc_rank, ~] = corr(inc_rank, gt_rank, 'Type', 'Kendall');
% [tau_bear_rank, ~] = corr(bear_rank, gt_rank, 'Type', 'Kendall');

[tau_exhppr, ~] = corr(res_exh, gt, 'Type', 'Kendall');
[tau_exhApxppr, ~] = corr(res_exhApx, gt, 'Type', 'Kendall');
%[tau_collppr, ~] = corr(res_coll_v2, gt, 'Type', 'Kendall');
[tau_collApxppr, ~] = corr(res_collApxppr, gt, 'Type', 'Kendall');
%[tau_collApx2ppr, ~] = corr(collApx2, gt, 'Type', 'Kendall');
%[tau_flatPPR, ~] = corr(res_flat, gt, 'Type', 'Kendall');
[tau_flatApxPPR, ~] = corr(res_flatApx, gt, 'Type', 'Kendall');
[tau_upprE5, ~] = corr(res_uppr, gt, 'Type', 'Kendall');
[tau_inc, ~] = corr(res_upprplus, gt, 'Type', 'Kendall');
[tau_bear, ~] = corr(bear, gt, 'Type', 'Kendall');
%% MAP
map_exhppr = map(res_exh, gt);
map_exhApxppr = map(res_exhApx, gt);
%map_collppr = map(res_coll_v2, gt);
map_collApxppr = map(res_collApxppr, gt);
%map_collApx2ppr = map(collApx2, gt);
%map_flatPPR = map(res_flat, gt);
map_flatApxPPR = map(res_flatApx, gt);
map_upprE5 = map(res_uppr, gt);
map_inc = map(res_upprplus, gt);
map_bear = map(bear, gt);

% map_exhppr_rank = map(exhPPR_rank, gt_rank);
% map_exhApxppr_rank = map(exhApxppr_rank, gt_rank);
% map_collppr_rank = map(collPPR_rank, gt_rank);
% map_collApxppr_rank = map(collApxppr_rank, gt_rank);
% map_collApx2ppr_rank = map(collApx2ppr_rank, gt_rank);
% map_flatPPR_rank = map(flatPPR_rank, gt_rank);
% map_flatApxPPR_rank = map(flatApxPPR_rank, gt_rank);
% map_upprE5_rank = map(upprE5_rank, gt_rank);
% map_inc_rank = map(inc_rank, gt_rank);
% map_bear_rank = map(bear_rank, gt_rank);
%% Euclidean Distance
euc_exhppr = norm(res_exh - gt);
euc_exhApxppr = norm(res_exhApx - gt);
%euc_collppr = norm(res_coll_v2 - gt);
euc_collApxppr = norm(res_collApxppr - gt);
%euc_collApx2ppr = norm(collApx2 - gt);
%euc_flatPPR = norm(res_flat - gt);
euc_flatApxPPR = norm(res_flatApx - gt);
euc_upprE5 = norm(res_uppr - gt);
euc_inc = norm(res_upprplus - gt);
euc_bear = norm(bear - gt);

% euc_exhppr_rank = norm(exhPPR_rank - gt_rank);
% euc_exhApxppr_rank = norm(exhApxppr_rank - gt_rank);
% euc_collppr_rank = norm(collPPR_rank - gt_rank);
% euc_collApxppr_rank = norm(collApxppr_rank - gt_rank);
% euc_collApx2ppr_rank = norm(collApx2ppr_rank - gt_rank);
% euc_flatPPR_rank = norm(flatPPR_rank - gt_rank);
% euc_flatApxPPR_rank = norm(flatApxPPR_rank - gt_rank);
% euc_upprE5_rank = norm(upprE5_rank - gt_rank);
% euc_inc_rank = norm(inc_rank - gt_rank);
% euc_bear_rank = norm(bear_rank - gt_rank);

%% save in excel
%ndcg = [nDCG_inc, nDCG_uppr, nDCG_bear, nDCG_exhppr nDCG_exhApxppr nDCG_collppr nDCG_collApxppr nDCG_collApx2ppr nDCG_flatppr nDCG_flatApxppr]';
map = [map_inc, map_upprE5, map_bear,map_exhppr map_exhApxppr  map_collApxppr   map_flatApxPPR]';
rho = [rho_inc, rho_upprE5,rho_bear, rho_exhppr rho_exhApxppr  rho_collApxppr   rho_flatApxPPR]';
tau = [tau_inc, tau_upprE5, tau_bear,tau_exhppr tau_exhApxppr  tau_collApxppr   tau_flatApxPPR]';
euc = [euc_inc, euc_upprE5, euc_bear,euc_exhppr euc_exhApxppr  euc_collApxppr   euc_flatApxPPR]';

alg = {'upprplus';'uppr';'bear';'exh'; 'exhApx'; 'collApx'; 'flatApx'};
T_ppr = table(alg, map, rho, tau, euc)

filename = 'accppr.xlsx';
writetable(T_ppr, filename, 'Sheet',1, 'Range','D1');



% map = [map_inc_rank, map_upprE5_rank, map_exhppr_rank map_exhApxppr_rank map_collppr_rank map_collApxppr_rank map_collApx2ppr_rank map_flatPPR_rank map_flatApxPPR_rank]';
% rho = [rho_inc_rank, rho_upprE5_rank, rho_exhppr_rank rho_exhApxppr_rank rho_collppr_rank rho_collApxppr_rank rho_collApx2ppr_rank rho_flatPPR_rank rho_flatApxPPR_rank]';
% tau = [tau_inc_rank, tau_upprE5_rank, tau_exhppr_rank tau_exhApxppr_rank tau_collppr_rank tau_collApxppr_rank tau_collApx2ppr_rank tau_flatPPR_rank tau_flatApxPPR_rank]';
% euc = [euc_inc_rank, euc_upprE5_rank, euc_exhppr_rank euc_exhApxppr_rank euc_collppr_rank euc_collApxppr_rank euc_collApx2ppr_rank euc_flatPPR_rank euc_flatApxPPR_rank]';
% 
% T_rank = table(alg, map, rho, tau, euc)
% 
% filename = 'accppr_rank.xlsx';
% writetable(T_rank, filename, 'Sheet',1, 'Range','D1');