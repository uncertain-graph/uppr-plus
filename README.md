# uppr-plus
## Test environment: 
Matlab R2023b <br>
Windows 10/11

## Datasets
Datasets can be downloaded from links: https://sparse.tamu.edu/SNAP and https://sparse.tamu.edu/LAW <br>
Please create a new folder named `datasets` and save `.mat` datastes under this folder.

## Preparation
### Preparation for METIS
Extract all files from `metismex-master.zip`, and execute the file `METIS_startup.m`. <br>
The zip file was modified and can be adapted based on Yingzhou's package from: https://github.com/YingzhouLi/metismex

### Preparation for uncertain source and target nodes
Run `main_gen_src_tar.m` to generate src and target nodes in `mutual exclusion` and `multiple edge`.

## UPPR+ under Mutual Exclusion semantics
Run the program `main.m` under the folder `mutual exclusion` (Double check every path in the file when you encounter the "no such file" error.) 

## UPPR+ under Multiple edge semantics
Run the program `main.m` under the folder `multiple edge` (Double check every path in the file when you encounter the "no such file" error.) 

## Accuracy 
Use `acc.m` to evaluate all PPR results. <br>
NDCG scores should be tested in `ndcg.py`. 

## Others
If you would like to run BEAR, generate collapse-based uncertain graph firstly using `main_gen_collT.m` under `acc\`. <br>
Implementation of BEAR comes from: https://datalab.snu.ac.kr/bear/ `BEAR-v1.0`.

