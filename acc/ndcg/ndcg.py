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

 

filename = 'cit-HepPh_l4_d3_res.mat';
res = scipy.io.loadmat(filename)

ground_truth = res['res_exh']

exh = res['res_exh']
exhapx = res['res_exhApx']

collapx = res['res_collApxppr']

flatapx = res['res_flatApx']
uppr = res['res_uppr']
inc  = res['res_upprplus']


ppr = [inc, uppr, exhapx, collapx, flatapx]
alg = ['upprplus','uppr', 'exhapx',  'collapx', 'flatapx']
scores = []

for i in range(len(ppr)):
    ppr[i] = np.array(ppr[i]).reshape(-1,1)
    score = ndcg_score(ground_truth.T, ppr[i].T, k = 500)
    scores.append(score)

data = {'alg': alg,'ndcg': scores}
df = pd.DataFrame(data)
df.to_excel('ndcgacc.xlsx', index = False)




