# uppr-plus
## Test environment: 
Matlab R2023b <br>
Windows 10/11

## Datasets:
Datasets can be downloaded from links: https://sparse.tamu.edu/SNAP and https://sparse.tamu.edu/LAW <br>
Please create a new folder named `datasets` and save datastes under this folder.

## Preparation
Extract all files from `metismex-master.zip`, and execute the file `METIS_startup.m`. <br>
Create new folders `excel_output` and `results` under the folders `mutual exclusion` and `multiple edge`.

## UPPR+ under Mutual Exclusion semantics
Run the program `main.m` under the folder `mutual exclusion` (Double check every path in the file when you encounter the "no such file" error.) 

## UPPR+ under Multiple edge semantics
Run the program `main.m` under the folder `multiple edge` (Double check every path in the file when you encounter the "no such file" error.) 

## Accuracy 
Use `acc.m` to evaluate all PPR results. <br>
NDCG should be tested in `ndcg.py`. 

## Others
If you would like to run BEAR, generate collapse-based uncertain graph firstly using `main_gen_collT.m`.
