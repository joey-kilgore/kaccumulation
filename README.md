# kaccumulation
Model of a STN axon with k+ accumulation. See Bellinger et. al. 2008

This repository is used for keeping track of modifications to the simulation environment while using the original model to see the effect KHFAC (kilohertz frequency alternating current) extracellular stimulation has. The original paper discusses using a range of frequencies from 10-300Hz and can cause block after prolonged periods of activation.

Bellinger, S. C., Miyazawa, G., &amp; Steinmetz, P. N. (2008). Submyelin potassium accumulation may functionally block subsets of local axons during deep brain stimulation: A modeling study. Journal of Neural Engineering, 5(3), 263-274. doi:10.1088/1741-2560/5/3/001

Link to ModelDB of original model : https://senselab.med.yale.edu/ModelDB/showmodel.cshtml?model=121253#tabs-1  
Link to original paper used with this model : https://pubmed.ncbi.nlm.nih.gov/18566505/

## Installation  
For a video guide, please go to [this YouTube video](https://www.youtube.com/watch?v=iusXitDGVKI) and then clone this repository instead of the Nerve-Block-Modeling repo.  
After installing all of the software and downloading everything, you will need to build the models folder within this repository (as shown in the video for the other repo).

## Loading up the environment  
First you will open the NEURON GUI. From there you can go to file -> working directory, and set the working directory to the models folder within this repository. From there you can load a .hoc file by going to file -> load hoc, and then you will need to navigate up one folder with the .. and then select the mosinit.hoc file. This will load up all of the needed hoc files.
