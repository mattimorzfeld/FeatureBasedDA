rga = 0.4:0.01:1.2;
strModel = 'P09';
nSamp = 1e2;

% Make the CD vs alpha curve and save it
MakeCDvsAlpha;

% Gather and save overall mean data
iTrial = iFile;
pltCDvsAlpha;
rgSmMeans = rgM;
rgSmSDs = rgSD;
strLoad = sprintf( './%salphavsCD%02d.mat', strModel, iTrial );
save( strLoad, 'rgAlpha', 'rgSmMeans', 'rgSmSDs' );

% Generate nSamp samples of alpha using the curve
fPlot = true;
SamplingNew;

% Generate sample reversals using alpha samples
SPP09 = SParams;
SPP09.alpha = X;
SPP09.tAlpha = ( 0:size( X, 1 )-1 )*1e3 + 1;
SPP09.nMaxSteps = ( size( X, 1 ) )*1e3;
tic; 
zP09 = fnCRa( SPP09 ); 
toc;

% Calculate the average MCD 
cdP09 = fnGetAvgCD( zP09, iBurnIn, dt, tAvg );