# synaptic_quantification
Code to quantify number of synapses in brain slices based on IHC and pre- and post- segmentation by Ilastik. Data analyzed by ImageJ and processed in R 

1. Place data to analyze in the RawData directory (DAPI, Pre and Post stain, default is VGlut2 and Homer)
2. Run SplitSaveChannels_singleslice.ijm to separate each stack into individual images, split channels and save them in the correct directory (VGlut2 or Homer)  [Plan to implement DAPI normalization]
3. For each of the two directories: Create an ilastik project and train software to recognise object. Make a simple segmentation as a tif and save into the SimpleSegmentation subdirectory in both the VGlut2 and Homer directories
4. Now run VGlut2_quantification_analysis.ijm, Homer_quantification_analysis.ijm and Synapse_analysis.ijm to determine objects in each image. 
5. Save each result as a csv 
6. Use the R script, Synaptic_quantification_analysis.R, to assign metadata and perform final plotting and statistical analysis 
