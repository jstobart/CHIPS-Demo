%% CHIPS (Cell and Hemodynamic Image Processing Suite)
% For region of interest detection and data extraction from calcium imaging
% movies

% Run through each section below

%% Step 1: Load the calcium movie into MATLAB

% define the data on each imaging channel.  This depends on the microscope.
channels = struct('Ca_Neuron',1, 'Ca_Memb_Astro', 2);

% import the data file

% when prompted, open the Raw Data Control folder and click on the
% *.xml file to import the calcium mvoie
Img =  BioFormats([], channels);

% it is possible to view the movie in MATLAB
Img.plot();

%% Step 2: Setup the Configurations for identifying astrocyte regions of interest (microdomain ROIs)

% ASTROCYTES
% from the Lck-GCaMP6f images on channel 2 in the example file

% define the baseline frames in the movie: first 5 s
BL_frames= floor(5*Img.metadata.frameRate); % number of baseline frames

% parameters for automated selection of active microdomains
findConf = ConfigFindROIsFLIKA_2D.from_preset('ca_memb_astro', 'baselineFrames',...
    BL_frames,'freqPassBand',0.5,'sigmaXY', 2,...
    'sigmaT', 0.14,'thresholdPuff', 7, 'threshold2D', 0.1,...
    'minRiseTime',0.14, 'maxRiseTime', 1,'minROIArea', 10,...
    'dilateXY', 4, 'dilateT', 0.3,'erodeXY', 1, 'erodeT', 0.1);

% measure ROIs (extract the traces)
measureConf = ConfigMeasureROIsDummy();

% parameters to filter the ROI traces to detect the signal peaks
detectConf = ConfigDetectSigsClsfy('baselineFrames', BL_frames,...
    'propagateNaNs', false, 'excludeNaNs', false, 'lpWindowTime', 1.5, 'spFilterOrder', 2,...
    'spPassBandMin',0.05, 'spPassBandMax', 0.5, 'thresholdLP', 3,'thresholdSP', 5);

% Combine the parameters into a CellScan variable for Lck-GCaMP
configCS= ConfigCellScan(findConf, measureConf, detectConf); %


%% Step 3: Analyze the data


% Create the CellScan object that contains the movie data and parameters
cs1 = CellScan([], Img, configCS, 2);  % 2 is the channel for analysis

% Process the CellScan object (find regions of interest and detect calcium
% peaks based on the above parameters)
cs1.process();

% Produce a plot of the found ROIs and traces
cs1.plot();

% output data for further statistics
cs1.output_data();

% OPTIONAL: to change ROI identification parameters and re-process the data:
cs1.opt_config();


%% Step 4a: Setup the Configurations for neuron somata: circled by hand in ImageJ

% NEURONS
% from the RCaMP1.07 images on channel 1 in the example file

% Analyzed based on structure (visible somata)

% load regions of interest from ImageJ (requires *.zip with ROIs)
x_pix= size(Img.rawdata,2); 
y_pix= size(Img(1,1).rawdata,1);
scaleF = 1;

% load imageJ ROIs for mask on the movie
N_findConf1 = ConfigFindROIsDummy.from_ImageJ([], x_pix, y_pix, scaleF);

% measure ROIs (extract the traces)
N_measureConf = ConfigMeasureROIsDummy();

% filter the traces to detect the calcium peaks
N_detectConf = ConfigDetectSigsClsfy('baselineFrames', BL_frames,...
    'propagateNaNs', false,'excludeNaNs', false, 'lpWindowTime', 5, 'spFilterOrder', 2,...
    'spPassBandMin',0.1, 'spPassBandMax', 1, 'thresholdLP', 5,'thresholdSP', 4);


% Combine the parameters into a CellScan config for neuronal RCaMP
N_configCS_ImageJ= ConfigCellScan(N_findConf1, N_measureConf, N_detectConf); 


%% Step 4b: Setup the Configurations for neuron ROI identification by activity

% NEURONS
% from the RCaMP1.07 images on channel 1 in the example file


% identify active regions of interest (dendrites and somata) with automated algorithm

% parameters for automated selection of active ROIs
N_findConf2 = ConfigFindROIsFLIKA_2D.from_preset('ca_neuron', 'baselineFrames',...
    BL_frames,'freqPassBand',1,'sigmaXY', 2,...
    'sigmaT', 0.14,'thresholdPuff', 7, 'threshold2D', 0.1,...
    'minRiseTime',0.07, 'maxRiseTime', 1,'minROIArea', 10,...
    'dilateXY', 4, 'dilateT', 0.2,'erodeXY', 1, 'erodeT', 0.1,...
    'discardBorderROIs',false);


N_configCS_FLIKA= ConfigCellScan(N_findConf2, N_measureConf, N_detectConf); 


%% Step 5a: Analyze the data for NEURONS ImageJ structural ROIs (somata)

% Create the CellScan object that contains the movie data and parameters
cs2 = CellScan([], Img, N_configCS_ImageJ, 1);  % 1 is the neuron channel for analysis

% Process the CellScan object (find regions of interest and detect calcium
% peaks based on the above parameters)
cs2.process();

% Produce a plot of the found ROIs and traces
cs2.plot();

% output data for further statistics
cs2.output_data();


%% Step 5b: Analyze the data for NEURONS to identify active ROIs

% Create the CellScan object that contains the movie data and parameters
cs3 = CellScan([], Img, N_configCS_FLIKA, 1);  % 1 is the neuron channel for analysis

% Process the CellScan object (find regions of interest and detect calcium
% peaks based on the above parameters)
cs3.process();

% Produce a plot of the found ROIs and traces
cs3.plot();

% output data for further statistics
cs3.output_data();

% OPTIONAL: to change ROI identification parameters and re-process the data:
cs3.opt_config();

