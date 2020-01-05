#Normalized counts of putative pre-, post- and whole synapses from confocal slices 
#Run this code after complete training and processing of Ilastik and subsequent ImageJ pipelines 
#NOTE: Assign genotype IDs, set the data paths and set data object before running 

#Load up required libraries and custom functions 
library(dplyr)
library(ggplot2)
add.metadata<-function(df) { 
  df$Image<-sapply(strsplit(x = as.character(df$Label), ".tif"), "[", 1) 
  df$animal<-sapply(strsplit(x = as.character(df$Label), "_"), "[", 2) 
  df$stack<-sapply(strsplit(x = as.character(df$Label), "00"), "[", 1) #This will be wrong if more than 99 slices for a tile
  return(df)
} #Assigns ID, animal ID and stack ID to each object 
add.genotypes<-function(df, geno) {
  df$Condition<-df$animal 
  for(i in 1:nrow(geno))  {
    df$Condition<-sub(df$Condition, pattern = geno[i,1], replacement = geno[i,2])
  }
  return(df)
}

#Create dataframe with the genotype of each animal: 
genotypes<-data.frame(id=c("M42", "M56", "M57", "M58", "M59", "M60")
                      , geno=c("B6", "B6", "B6", "Ccr5KO", "Ccr5KO", "Ccr5KO"))

#Load up the required datasets for pre-,post- and synapses 
homer.data<-read.csv("/Volumes/Samsung_T5/KeckLSC_CCR5KO_P10_Dec2019_Analysis/Homer_analysis_results.csv")
vglut2.data<-read.csv("/Volumes/Samsung_T5/KeckLSC_CCR5KO_P10_Dec2019_Analysis/VGlut2_analysis_results.csv")
synapse.data<-read.csv("/Volumes/Samsung_T5/KeckLSC_CCR5KO_P10_Dec2019_Analysis/RGC_synapse_analysis_results.csv")

#Set the catagory (pre-,post-, paired synapses) under analysis: 
data<-synapse.data
  
#Assign the metadata (IDs) and genotypes using custom functions
data<-add.metadata(data)
data<-add.genotypes(data, geno = genotypes)

#Caluclate number of objects per image and plot:  
data.number<-select(data, Image, animal, Condition, stack) 
data.number<-group_by(data, animal, Condition, stack) 
data.number<-count(data.number, Image) 

g<-ggplot(data.number, aes(x=Condition, y=n))
g<-g+geom_boxplot(outlier.shape = NA, alpha=0.5, notch = T, fill="white", col="white")
g<-g+geom_jitter(aes(color=animal), width = 0.2, alpha=0.5, size=3)
g

#Caluclate per tile and per animal averages of number of objects: 
data.number<-summarise(data.number, mean_stack=mean(n))
data.number<-summarise(data.number, mean_animal=mean(mean_stack))

g<-ggplot(data.number, aes(x=Condition, y=mean_animal))
g<-g+geom_boxplot(outlier.shape = NA, alpha=0.5, notch = F, fill="white", col="white")
g<-g+geom_jitter(aes(color=animal), width = 0.2, alpha=0.5, size=3)
g

#OTHER FUNCTIONS FOR SPECIFIC ANALYSES 
#Plot the area of the objects per genotype:  
g<-ggplot(data, aes(x=Condition, y=Area))
g<-g+geom_boxplot(outlier.shape = NA, alpha=0.5, notch = F, fill="magenta", col="magenta")
g<-g+coord_cartesian(ylim=c(0,100))
g

#Read in and combine with other data: 