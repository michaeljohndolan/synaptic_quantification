//Code to extract the microglia channel and save it separately for Ilastik processing 

//Get Input directory 
maindir=getDirectory("Choose the parent phagocytosis directory"); 
RawDir=maindir+"RawData/";
list=getFileList(RawDir);

//Open each image and extract the channels 
for (i=0; i<list.length; i++) {
	open(RawDir+"/"+list[i]); //Open each individual simple segmentation 
	run("Split Channels");

	names= getList("image.titles");
	for(j=0;j<names.length;j++){ 

		
		if(startsWith(names[j],"C2" )) {
					selectWindow(names[j]);
					run("Image Sequence... ", "format=TIFF save="+maindir+"VGlut2/"+list[i]);
					print(maindir+"VGlut2/"+list[i]);
					close();
					}
		if(startsWith(names[j],"C3" )) {
					selectWindow(names[j]);
					run("Image Sequence... ", "format=TIFF save="+maindir+"Homer/"+list[i]);
					print(maindir+"Homer/"+list[i]);
					close();
					}
	    }
}