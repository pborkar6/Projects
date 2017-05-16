BMED6780/BMED4783/ECE6780/ECE6780
Medical Image Processing Course Project
README file

The main program is Main_program_module1.main

This program reads a file called test containing all the images that need to be tested.

The program is divided in two parts:

1. Image segmentation:

Calling histopath_seg function.
histopath_seg calls kmeans_fv_colorseg to perform the Kmeans segmentation.
histopath_seg also calls the inbuilt MATLAB function watershed to perform the watershed segmentation.

2. Feature extraction:

Calling histopath_features.
For each image, histopath_features returns a cell array with two layers. 
The first one contains a vector with the values of the features.
The second one contains a vector with the labels of the features.


Main_program_module1 also returns a matrix containing all the features of all images. 

correlation.m is used for feature ranking.

There are two programs for dimensionality reduction:
1. Dimen_reduction_LLE.m which calls the function LLE, which performs locally linear embedding.
2. Run_pca.m which calls the MATLAB function pca and plots the features before and after PCA. 