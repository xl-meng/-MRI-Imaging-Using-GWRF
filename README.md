
<!---
xl-meng/xl-meng is a ✨ special ✨ repository because its `README.md` (this file) appears on your GitHub profile.
You can click the Preview link to take a look at your changes.
--->
Detection of Association Features Based on Gene Eigenvalues and MRI Imaging Using Genetic Weighted Random Forest

A Matlab Implementation of Genetic Weighted Random Forest
In this work, we present a novel data fusion method and a genetic weighted random forest method to mine the important features fused by voxels and gene eigenvalues. Specifically, we amplify the difference among AD, LMCI, EMCI and HC by introducing eigenvalues calculated from the gene p-value matrix for feature fusion. Furthermore, we construct the genetic weighted random forest using the resulting fusion features. Genetic evolution is used to increase the diversity among decision trees and the decision trees generated are weighted by weights. After training, the genetic weighted random forest is analyzed further to detect the significant fusion features. 

Main_code ----->ADEMCI.m ADHC.m ADLMCI.m HCEMCI.m HCLMCI.m 
main_code folder contains the main code of random forest, weighted random forest, genetic evolution random forest and genetic weighted random forest.

Algorithm_implementation ----> RF_use.m GA_RF_use.m GAWF_RF_use.m
The RF_use.m is the algorithm implementation code of traditional random forest and weighted random forest. The GA_RF_use.m is the algorithm implementation code of genetic evolution random forest. The GAWF_RF_use.m is the algorithm implementation code of genetic weighted random forest.

Sample_partition ----->train_valid_ADEMCI.mat  train_valid_ADHC.mat train_valid_ADLMCI.mat train_valid_HCEMCI.mat train_valid_HCLMCI.mat
Sample_partition folder contains the participants' partition of train set,  valid set and test set used in our work.

Data ----->feature_filter_MulGeneP_AD_EMCI.mat feature_filter_MulGeneP_AD_HC.mat feature_filter_MulGeneP_AD_LMCI.mat feature_filter_MulGeneP_HC_EMCI.mat feature_filter_MulGeneP_HC_EMCI.mat 
Data folder contains the extracted features fused by voxels and gene eigenvalues of 5 datasets.

Usage
Run the *.m file in Main_code folder and obtain the important features of each dataset.
The data used in our work could be found in https://pan.baidu.com/s/1gR_uMtXllPcVWO-aQ43-Sw?pwd=6666 

If you want to use your own data fused by voxels and  gene eigenvalues, the files in Data folder should be replaced by your data.
