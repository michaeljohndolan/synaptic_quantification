//Code to calcuate the number and volume of VGlut2 puncta in different brains 
run("Clear Results");

//Get Main directory 
maindir=getDirectory("Choose the parent phagocytosis directory"); 

//Make a list of all files under analysis 
list=getFileList(maindir+"VGlut2/SimpleSegmentation/"); 

for (i=0; i<list.length; i++) {

	//Open a VGlut2 image 
	open(maindir+"VGlut2/SimpleSegmentation/"+list[i]);
	run("16-bit");
	setThreshold(1, 1);
	run("Convert to Mask");
	run("Erode");
	run("Dilate");

	//Begin analysis of individual puncta
	run("Analyze Particles...", "size=0-Infinity show=Overlay add in_situ");
	run("From ROI Manager");
	run("Set Measurements...", "area display redirect=None decimal=3"); 
	roiManager("Measure");

	//Delete the accumulated ROIs and close the image, the results window 
	//will remain open. 
	roiManager("Delete");
	close(list[i]); 
}




