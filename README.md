# CHIPS-Demo

Astrocyte and Neuron Calcium Movie Analysis with MATLAB and CHIPS

1.	System requirements
-	-MATLAB version 2018b or newer (code has been tested most recently on MATLAB 2019a and 2020b).
-	MATLAB Image Processing and Signal Processing Toolboxes
-	CHIPS toolbox (//github.com/EIN-lab/CHIPS/releases)
-	BioFormats toolbox (https://docs.openmicroscopy.org/bio-formats/6.1.0/users/matlab/index.html)- required to open microscope images of different file formats.
-	Fiji/ImageJ (https://imagej.net/software/fiji/downloads- for circling regions of interest (such as neuronal somata)

2.	Installation guide
a)	Install MATLAB (version newer than 2018b) and Fiji (optional). Typical install time on a normal computer (15-20 min).
b)	Save the CHIPS and BioFormats toolbox on the MATLAB path.  These folders are located in the MATLAB files folder or can be downloaded at the links above.

3.	Demo and instructions for use

a)	Demo code outlining the functions and steps in MATLAB for the calcium analysis in this paper is available in the CHIPS_Demo.m file.  Please see this file for more information.  It takes approximately 4 minutes to process this example on a typical computer.
b)	Example data was acquired on a Bruker two-photon microscope using PrairieView software.  The BioFormats toolbox is needed to extract the metadata from these files within MATLAb and this toolbox will work for importing images from most microscope systems.
c)	Active regions of interest (ROIs) are identified based on the FLIKA algorithm from Ellefsen et al. (2014)1.
d)	Expected output: Generates 3 graphs of astrocyte and neuron ROIs identified and their example traces. It also output 3 csv files per analysis step (9 files total) that contains the traces and ROI identification information as well as the signal peaks found in each ROI and their parameters (amplitude, timing, etc.).
Active neuron ROIs that overlapped with ImageJ ROIs were considered somata excluded from further analysis.
e)	Parameters that can be changed to optimize ROI identification from different data:

Smoothing and filtering the movie:
-	freqPassBand- a temporal moving average filter applied to each pixel in time to reduce noise.
-	sigma XY and sigmaT- spatial and temporal Gaussian filters applied to reduce noise

Active pixel identification:
-	thresholdPuff- threshold for standard deviation over the baseline (e.g. 7*SD) in order to be considered an active pixel:
-	minRiseTime- minimum time duration to reach the signal peak
-	maxRiseTime- maximum time duration to reach the signal peak
-	minROIArea- minimum spatial area of active ROI (in µm2)

Filtering noisy pixels or tiny regions of interest:
-	erodeXY- shrink all ROIs by defined µm to remove noisy pixels
-	erodeT- shrink all ROIs by defined time (s) to remove noisy pixels
-	dilateXY- expand all ROIs by defined µm to remove erosion (erodeXY)
-	dilateT- expand all ROIs by defined time (s) to remove erosion (erodeT)
-	discardBorderROIs- set as true to exclude ROIs that touch the edge of the imaging frame

For more information and video instructions for analysis steps, please see the JoVe video by Meza-Resillas et al. (2021)2.

Papers that have used this same analysis3–6:
1.	Ellefsen, K. L., Settle, B., Parker, I. & Smith, I. F. An algorithm for automated detection, localization and measurement of local calcium signals from camera-based imaging. Cell Calcium 56, 147–156 (2014).
2.	Meza-Resillas, J., Ahmadpour, N., Stobart, M. & Stobart, J. Brain pericyte calcium and hemodynamic imaging in transgenic mice in vivo. J. Vis. Exp. 177, 1–17 (2021).
3.	Barrett, M. J. P., Ferrari, K. D., Stobart, J. L., Holub, M. & Weber, B. CHIPS: an extensible toolbox for cellular and hemodynamic two-photon image analysis. Neuroinformatics 16, 145–147 (2018).
4.	Stobart, J. L. et al. Cortical circuit activity evokes rapid astrocyte calcium signals on a similar timescale to neurons. Neuron 98, 726-735.e4 (2018).
5.	Zuend, M. et al. Arousal-induced cortical activity triggers lactate release from astrocytes. Nat. Metab. 2, (2020).
6.	Glück, C. et al. Distinct signatures of calcium activity in brain mural cells. Elife 10, 1–27 (2021).


