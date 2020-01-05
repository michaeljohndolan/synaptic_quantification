//Quantify the number of synapses using both VGlut2 and Homer puncta 
run("Clear Results");

//Get Main directory 
maindir=getDirectory("Choose the parent phagocytosis directory"); 

//Make a list of all files under analysis 
list_vglut=getFileList(maindir+"Vglut2/SimpleSegmentation/"); 
list_homer=getFileList(maindir+"Homer/SimpleSegmentation/"); 

for (i=0; i<list_vglut.length; i++) {

	//Open the VGlut2 image 
	open(maindir+"VGlut2/SimpleSegmentation/"+list_vglut[i]);
	run("16-bit");
	setThreshold(1, 1);
	run("Convert to Mask");
	run("Erode");
	run("Dilate");
	rename("Vglut2");

	//Open the corresponding Homer image 
	open(maindir+"Homer/SimpleSegmentation/"+list_homer[i]);
	run("16-bit");
	setThreshold(1, 1);
	run("Convert to Mask");
	run("Erode");
	run("Dilate");
	rename("Homer"); 

	//Run AND operation on the pre- and post- synaptic masks 
	imageCalculator("AND create", "Vglut2","Homer");
	rename("Result"); 
	close("Vglut2");
	close("Homer");
	selectWindow("Result");
	rename(list_vglut[i]); 
	
	//Begin analysis of individual puncta
	run("Analyze Particles...", "size=0-Infinity show=Overlay add in_situ");
	run("From ROI Manager");
	run("Set Measurements...", "area display redirect=None decimal=3"); 
	roiManager("Measure");

	//Delete the accumulated ROIs and close the image, the results window 
	//will remain open. 
	roiManager("Delete");
	close(list_vglut[i]); 
}
