# -*- coding: utf-8 -*-
"""
Created on Fri Sep 27 12:01:09 2024

@author: u5550119
"""

import scipy.io
from sklearn.metrics import ndcg_score, average_precision_score
from mean_average_precision import MetricBuilder
import pandas as pd
import numpy as np
# results list
# wiki-Vote_res
 
def pr2ranks(r):
    n = len(r)
    pr = {i: r[i] for i in range(n)}
    tops = sorted(pr, key=pr.get, reverse=True)
    ranks = [0 for _ in range(n)]
    for i in range(n):
        ranks[tops[i]] = i
    return ranks

filename = 'cit-HepPh_l4_d3_res.mat';
res = scipy.io.loadmat(filename)
filebear = 'ch_bearppr_res.mat';
res_bear = scipy.io.loadmat(filebear)
ground_truth = res['res_exh']

exh = res['res_exh']
exhapx = res['res_exhApx']
#collapx2 = res['collApx2']
#coll = res['res_coll_v2']
collapx = res['res_collApxppr']
#flat = res['res_flat']
flatapx = res['res_flatApx']
uppr = res['res_uppr']
inc  = res['res_upprplus']

bear = res_bear['bearppr']

ppr = [inc, uppr, bear, exh, exhapx, collapx, flatapx]
alg = ['upprplus','uppr','bear', 'exh', 'exhapx',  'collapx', 'flatapx']
scores = []

for i in range(len(ppr)):
    ppr[i] = np.array(ppr[i]).reshape(-1,1)
    score = ndcg_score(ground_truth.T, ppr[i].T, k = 500)
    scores.append(score)

data = {'alg': alg,'ndcg': scores}
df = pd.DataFrame(data)
df.to_excel('ndcgacc.xlsx', index = False)

#score = ndcg_score(coll.T, bear.T, k = 500)


