% add means to alpha vs t, remove data
% add means to MCD vs t
% Make 4 subplot graph with MCD vs t over alpha vs t for both B13 and P09
% see if you can change errorbar widths

%%
clear
close all
clc


set( 0, 'DefaultAxesFontSize', 20 );
set( 0, 'DefaultFigureColor', 'w');

cMap = lines( 7 );
c1 = 1; c2 = 2;
cm1 = cMap( 5, : ); cm2 = cMap( 3, : );
% For Matti's Colors:
run( 'colors.m' );
cMap = Color'; 
c1 = 1; c2 = 5;
cm1 = [ 0 -0.1 0.3 ] + cMap( c1, : );
cm2 = cMap(4,:);%[ 0.1 -0.1 0 ] + cMap( c2, : );

% Directory to save output figures in
strSaveDir = './figures';

% Directory all the data files are stored in
strLoadDir = './data';

fSavePDF = false;   % Set to true to save all plots as pdfs
fSaveFig = false;   % Set to true to save all plots as matlab figures
fLogAvsCD = true;   % Set to true if the first plot (alpha vs CD) should be loglog

% Set to true in order to bound the standard deviations on the MCD vs alpha
% curves by eMax
fBoundSD = true;
eMax = 2.5;

% If you don't want some of the plots, set these to false
fPlotAlphavsCD = true; % true;
fPlotAlphavsTime = true; % true;
fPlotMCDvsTime = true; % true;
fPlotMCDvsTSeperate = true;
fPlotMaster = true;
fPlotExamples = true;
fPlotExamplesAlpha1Small = true;
fPlotExamplesAlpha1Big = true;

if fSavePDF || fSaveFig
    if ~exist( strSaveDir, 'dir' )
        mkdir( strSaveDir );
    end
end

if ~exist( strLoadDir, 'dir' )
    error( sprintf( 'Directory %s does not exist', strLoadDir ) );
end

% Default *.mat files

% strLoadCD* is the path to the file containing the alpha vs. chron curve
% data. This mat file must have the alpha values saved in a vector called
% rgAlpha, the CD values saved in a vector called rgSmMeans, and the
% standard deviations saved in a vector called rgSmSDs.
strLoadCDB13 = sprintf( '%s/B13alphavsCD.mat', strLoadDir );      
strLoadCDP09 = sprintf( '%s/P09alphavsCD.mat', strLoadDir );

% strGK is the path to the file which contains the true mean chron duration 
% based on the Gee and Kent 2007 data. This mat file must have the chron
% durations saved in a vector rgCDAvg, with corresponding times in the
% vector rgtAvg. There should also be a scaralar tAvg which is the amount
% of time the data was averaged over.
strGK = sprintf( '%s/GK2007Alpha250.mat', strLoadDir );

% strSamples* is the path to the file which contains the samples of 
% alpha(t) = X(t) and their corresponding weights W(t). The File should
% also include a struct S which contains all the parameters used in the
% sampling run.
strSamplesB13 = sprintf( '%s/B13samps.mat', strLoadDir );
strSamplesP09 = sprintf( '%s/P09samps.mat', strLoadDir );

% strSampeRunsSmall* is the path to the file which contains the mean chron
% duration data for a bunch of runs. This data should be saved as a matrix
% called cdB13 or cdP09 of size ( number of time steps ) x ( number of
% samples ).
strSampleRunsSmallB13 = sprintf( '%s/B13SampleRunsSmall.mat', strLoadDir );
strSampleRunsSmallP09 = sprintf( '%s/P09SampleRunsSmall.mat', strLoadDir );

% str*CR is the path to the file which contains a single sample run from 
% the model *. It must contain the total number of iterations in a variable
% called Steps, the time step in a variable called dt, and the time series
% as a vector called X.
strB13CR = sprintf( '%s/ChronRunsB13.mat', strLoadDir );
strP09CR = sprintf( '%s/ChronRunsP09.mat', strLoadDir );

% strCH is the path to the file containing the GK2007 data with variables 
% vage and vpolarity.
strCH = sprintf( '%s/ChronHistory.mat', strLoadDir );

% strP is a path to the PADM2M data, and strS is a path to the Sint2000 
% data, both with variables epoch and dipole.
strP = sprintf( '%s/myPADM2MStar.mat', strLoadDir );
strS = sprintf( '%s/mySint2000.mat', strLoadDir );

% Same requirements as str*CR, but these are runs with alpha = 1.
strB13CRA1 = sprintf( '%s/B13ChronRunsAlpha1.mat', strLoadDir );
strP09CRA1 = sprintf( '%s/P09ChronRunsAlpha1.mat', strLoadDir );


sB13 = load( strLoadCDB13 );
sP09 = load( strLoadCDP09 );

rgB13A = sB13.rgAlpha;
rgB13CD = sB13.rgSmMeans;
if fBoundSD
    rgB13SD = min( sB13.rgSmSDs, eMax );
else
    rgB13SD = sB13.rgSmSDs;
end

rgP09A = sP09.rgAlpha;
rgP09CD = sP09.rgSmMeans;
if fBoundSD
    rgP09SD = min( sP09.rgSmSDs, eMax );
else
    rgP09SD = sP09.rgSmSDs;
end

if fPlotAlphavsCD
    % ****** %
    % PLOT 1
    % ****** %
    % Alpha vs CD curve with errorbars. 
    hFig = figure( 1 );
    clf;
    hold( 'on' );
    eB13 = errorbar( rgB13A, rgB13CD, 2*rgB13SD );
    plot(rgB13A, rgB13CD,'.','Color',cMap( c1, : ),'MarkerSize',20)
    eB13.LineWidth = 2;
    eB13.Color = cMap( c1, : );
    step = 4;
    eP09 = errorbar( rgP09A( 1:step:end ), rgP09CD( 1:step:end ), 2*rgP09SD( 1:step:end ) );
    plot(rgP09A, rgP09CD,'o','Color',cMap( c2, : ),'MarkerSize',5)
    eP09.LineWidth = 2;
    eP09.Color = cMap( c2, : );
    hold( 'off' );
    
    strVer = version( '-release' );
    nVer = str2double( strVer( 1:4 ) );
    if strcmp( strVer, '2016b' ) || nVer > 2016
        eB13.CapSize = 5;
        eP09.CapSize = 5;
    elseif any( strcmp( strVer, { '2014b', '2015a', '2015b', '2016a' } ) )
        % Width of the top and bottom lines of errorbar
        if ~fLogAvsCD 
            xlength = 0.02*ones( 1, 2 );
        end
        
        X = rgB13A;
        Y = rgB13CD;
        E = 2*rgB13SD;
        % Make horizontal lines with 'line'
        for k = 1:length( X )
            if fLogAvsCD
                tmp = 0.005;
                xlength = X( k ) * [ 1 - 10^-tmp, 10^tmp - 1 ];
            end
            x = [ X( k ) - xlength( 1 ), X( k ) + xlength( 2 ) ];
            y_h = [ Y(k) + E(k), Y(k) + E(k) ];
            line( x, y_h, 'Color', cMap( c1, : ), 'LineWidth', 2 );
            y_b = [ Y(k) - E(k), Y(k) - E(k) ];
            line( x, y_b, 'Color', cMap( c1, : ), 'LineWidth', 2 );
        end
        
        X = rgP09A( 1:step:end );
        Y = rgP09CD( 1:step:end );
        E = 2*rgP09SD( 1:step:end );
        % Make horizontal lines with 'line'
        for k = 1:length( X )
            if fLogAvsCD
                tmp = 0.005;
                xlength = X( k ) * [ 1 - 10^-tmp, 10^tmp - 1 ];
            end
            x = [ X( k ) - xlength( 1 ), X( k ) + xlength( 2 ) ];
            y_h = [ Y(k) + E(k), Y(k) + E(k) ];
            line( x, y_h, 'Color', cMap( c2, : ), 'LineWidth', 2 );
            y_b = [ Y(k) - E(k), Y(k) - E(k) ];
            line( x, y_b, 'Color', cMap( c2, : ), 'LineWidth', 2 );
        end
    else
        xlength = 0.1;
        hb = get( eB13,'children' ); 
        Xdata = get( hb( 2 ), 'Xdata' );
        temp = 4:3:length( Xdata );
        temp( 3:3:end ) = [];
        % xleft and xright contain the indices of the left and right
        %  endpoints of the horizontal lines
        xleft = temp; xright = temp+1;
        % Increase line length by 0.2 units
        Xdata( xleft ) = Xdata( xleft ) - .1;
        Xdata( xright ) = Xdata( xright ) + .1;
        set( hb( 2 ), 'Xdata', Xdata );
        
        hb = get( eP09,'children' ); 
        Xdata = get( hb( 2 ), 'Xdata' );
        temp = 4:3:length( Xdata );
        temp( 3:3:end ) = [];
        % xleft and xright contain the indices of the left and right
        %  endpoints of the horizontal lines
        xleft = temp; xright = temp+1;
        % Increase line length by 0.2 units
        Xdata( xleft ) = Xdata( xleft ) - xlength;
        Xdata( xright ) = Xdata( xright ) + xlength;
        set( hb( 2 ), 'Xdata', Xdata );
    end

    xlabel( '\theta' );
    ylabel( 'MCD (Myr)' );

    aMin = min( rgB13A( 1 ), rgP09A( 1 ) ) - 0.05;
    aMax = max( rgB13A( end ), rgP09A( end ) ) + 0.05;
    
%     pB13 = 20;
%     pP09 = 60;
%     ptsB13 = [ aMin, fnCDtoAlpha( pB13, rgB13A, rgB13CD ) ];
%     ptsP09 = [ aMin, fnCDtoAlpha( pP09, rgP09A, rgP09CD ) ];

    % Plot horizontal and vertical dotted lines to points on the curves
%     hold( 'on' );
%     plot( ptsB13, [ pB13, pB13 ], '--', 'color', cMap( c1, : ) );
%     plot( ptsB13( 2 ) * [ 1, 1 ], [ 0, pB13 ], '--', 'color', cMap( c1, : ) );
%     plot( ptsP09, [ pP09, pP09 ], '--', 'color', cMap( c2, : ) );
%     plot( ptsP09( 2 ) * [ 1, 1 ], [ 0, pP09 ], '--', 'color', cMap( c2, : ) );
    hold( 'off' );
    
    if fLogAvsCD
        set(gca,'YScale','Log')
        set(gca,'XScale','Log')
    end
    
    ylim( [ 0, 100 ] );
    xlim( [ aMin, aMax ] );

%     sLegend = { 'B13', 'P09' };
%     legend( sLegend );
    
    strSaveFile = sprintf( '%s/plotAlphavsCD', strSaveDir );
    if fSavePDF
        set( hFig, 'units', 'inches' );
        pos = get( hFig, 'position' );
        set( hFig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', ...
             'PaperSize', [ pos(3), pos(4) ] );
        print( hFig, strSaveFile, '-dpdf', '-r0' );
    end
    if fSaveFig
        savefig( hFig, strSaveFile );
    end
end
    
load( strGK );

% Get alpha values for real data 
rgaDataB13 = zeros( size( rgCDAvg ) );
rgaDataP09 = zeros( size( rgCDAvg ) );
for i = 1:length( rgCDAvg )
    rgaDataB13( i ) = fnCDtoAlpha( rgCDAvg( i ), rgB13A, rgB13CD );
    rgaDataP09( i ) = fnCDtoAlpha( rgCDAvg( i ), rgP09A, rgP09CD );
end


sB13AC = load( strSamplesB13 );
sP09AC = load( strSamplesP09 );

XB = sB13AC.X; WB = sB13AC.W;
XP = sP09AC.X; WP = sP09AC.W;
XavgB = sum( XB .* WB, 2 );
XavgP = sum( XP .* WP, 2 );

aMin = min( [ XB(:); XP(:) ] ) - 0.05;
aMax = max( [ XB(:); XP(:) ] ) + 0.05;
    
tMin = rgtAvg( 1 ) - 0.1;
tMax = rgtAvg( end ) + 0.1;

if fPlotAlphavsTime
    % ****** %
    % PLOT 2
    % ****** %
    % Alpha over time for all the samples, with the true alpha from the data
    % plotted on top for reference.
    hFig = figure( 2 ); 
    clf;
    hold( 'on' );
    lxB = plot( rgtAvg( 1:length( XB ) ), XB );
    lxP = plot( rgtAvg( 1:length( XP ) ), XP );
    for i = 1:length( lxB )
        % Plotting color c1 with 5% opacity.
        lxB( i ).Color = [ cMap( c1, : ), 0.05 ];
    end
    for i = 1:length( lxP )
        % Plotting color c2 with 5% opacity.
        lxP( i ).Color = [ cMap( c2, : ), 0.05 ];
    end
    % Plot the means 
    mxB = plot( rgtAvg, mean( XB, 2 ), 'Color', cm1, 'LineWidth', 1.5 );
    mxP = plot( rgtAvg, mean( XP, 2 ), 'Color', cm2, 'LineWidth', 1.5 );
    % Plot the true alpha values from the data
    % plot( rgtAvg, rgaDataB13, 'k' );
    % plot( rgtAvg, rgaDataP09, 'k' );
    hold( 'off' );
    
    ylim( [ aMin, aMax ] );
    xlim( [ tMin, tMax ] );
    
    xlabel( 'Time (Myr)' );
    ylabel( '\theta_k' );

    strSaveFile = sprintf( '%s/plotAlphaClouds', strSaveDir );
    if fSavePDF
        set( hFig, 'units', 'inches' );
        pos = get( hFig, 'position' );
        set( hFig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', ...
             'PaperSize', [ pos(3), pos(4) ] );
         
        
        print( hFig, strSaveFile, '-dpdf', '-r0' );
    end
    if fSaveFig
        savefig( hFig, strSaveFile );
    end
end


sB13n = load( strSampleRunsSmallB13 );
sP09n = load( strSampleRunsSmallP09 );

rgCDB = sB13n.cdB13;
rgCDP = sP09n.cdP09;

if fPlotMCDvsTime
    % ****** %
    % PLOT 3
    % ****** %
    % MCD over time as two plots side by side. 
    hFig = figure( 3 );
    clf;
    
    subplot( 1, 2, 1 );
    hold( 'on' );
    lxB = plot( rgtAvg( 1:length( rgCDB ) ) + tAvg/2, rgCDB );
    for i = 1:length( lxB )
        lxB( i ).Color = [ cMap( c1, : ), 0.1 ];
    end
    plot( rgtAvg( 1:length( rgCDB ) ) + tAvg/2, mean( rgCDB, 2 ), ...
        'Color', cm1, 'LineWidth', 1.5 );
    plot( rgtAvg, rgCDAvg, 'k' );

    ylim( [ 0, 10 ] );
    xlim( [ tMin, tMax ] );

    xlabel( 'Time (Myr)' );
    ylabel( 'Mean Chron Duration (Myr)' );

    hold( 'off' );

    subplot( 1, 2, 2 );
    hold( 'on' );
    lxP = plot( rgtAvg( 1:length( rgCDP ) ) + tAvg/2, rgCDP );
    for i = 1:length( lxB )
        lxP( i ).Color = [ cMap( c2, : ), 0.1 ];
    end
    plot( rgtAvg( 1:length( rgCDP ) ) + tAvg/2, mean( rgCDP, 2 ), ...
        'Color', cm2, 'LineWidth', 1.5 );
    plot( rgtAvg, rgCDAvg, 'k' );
    
    hold( 'off' );

    ylim( [ 0, 10 ] );
    xlim( [ tMin, tMax ] );

    xlabel( 'Time (Myr)' );
    ylabel( 'Mean Chron Duraiton (Myr)' );
    
    strSaveFile = sprintf( '%s/plotMCDvsTime', strSaveDir );
    if fSavePDF
        set( hFig, 'units', 'inches' );
        pos = get( hFig, 'position' );
        set( hFig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', ...
             'PaperSize', [ pos(3), pos(4) ] );
        print( hFig, strSaveFile, '-dpdf', '-r0' );
    end
    if fSaveFig
        savefig( hFig, strSaveFile );
    end
    
%     if fPlotMCDvsTSeperate
%         hFig = figure( 3 ); hB = subplot( 1, 2, 1 );
%         hObjB = copyobj( gca, hFig );
%         fB = figure( 4 ); 
%         set( hObjB, 'Parent', fB );
%         set( hObjB, 'Position', hB.Position + [ -.05 0 0.55 0 ] );
%         % figure( 2 ); pos = get( gca, 'Position' );
%         % set( hObjB, 'Position', pos );
%         
%         figure( 3 ); hP = subplot( 1, 2, 2 );
%         hObjP = copyobj( gca, hFig );
%         fP = figure( 5 ); 
%         set( hObjP, 'Parent', fP, 'Position', hObjB.Position );
%     end
end

if fPlotMCDvsTSeperate
    hFig = figure( 4 ); 
    clf;
    
    hold( 'on' );
    lxB = plot( rgtAvg( 1:length( rgCDB ) ) + tAvg/2, rgCDB );
    for i = 1:length( lxB )
        lxB( i ).Color = [ cMap( c1, : ), 0.1 ];
    end
    plot( rgtAvg( 1:length( rgCDB ) ) + tAvg/2, mean( rgCDB, 2 ), ...
        'Color', cm1, 'LineWidth', 1.5 );
    plot( rgtAvg, rgCDAvg, 'k' );

    ylim( [ 0, 10 ] );
    xlim( [ tMin, tMax ] );

    xlabel( 'Time (Myr)' );
    ylabel( 'Mean Chron Duration (Myr)' );

    hold( 'off' );
    
    strSaveFile = sprintf( '%s/plotMCDvsTimeB13', strSaveDir );
    if fSavePDF
        set( hFig, 'units', 'inches' );
        pos = get( hFig, 'position' );
        set( hFig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', ...
             'PaperSize', [ pos(3), pos(4) ] );
        print( hFig, strSaveFile, '-dpdf', '-r0' );
    end
    if fSaveFig
        savefig( hFig, 'strSaveFile' );
    end
    
    hFig = figure( 5 );
    clf;
    
    hold( 'on' );
    lxP = plot( rgtAvg( 1:length( rgCDP ) ) + tAvg/2, rgCDP );
    for i = 1:length( lxP )
        lxP( i ).Color = [ cMap( c2, : ), 0.1 ];
    end
    plot( rgtAvg( 1:length( rgCDP ) ) + tAvg/2, mean( rgCDP, 2 ), ...
        'Color', cm2, 'LineWidth', 1.5 );
    plot( rgtAvg, rgCDAvg, 'k' );

    ylim( [ 0, 10 ] );
    xlim( [ tMin, tMax ] );

    xlabel( 'Time (Myr)' );
    ylabel( 'Mean Chron Duration (Myr)' );

    hold( 'off' );
    
    strSaveFile = sprintf( '%s/plotMCDvsTimeP09', strSaveDir );
    if fSavePDF
        set( hFig, 'units', 'inches' );
        pos = get( hFig, 'position' );
        set( hFig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', ...
             'PaperSize', [ pos(3), pos(4) ] );
        print( hFig, strSaveFile, '-dpdf', '-r0' );
    end
    if fSaveFig
        savefig( hFig, strSaveFile );
    end
end


if fPlotMaster
    hFig = figure( 6 );
    clf;
    
    subplot( 2, 2, 1 );
    hold( 'on' );
    lxB = plot( rgtAvg( 1:length( XB ) ), XB );
    for i = 1:length( lxB )
        % Plotting color c1 with 5% opacity.
        lxB( i ).Color = [ cMap( c1, : ), 0.05 ];
    end
    % Plot the mean
    mxB = plot( rgtAvg, mean( XB, 2 ), 'Color', cm1, 'LineWidth', 1.5 );
    % Plot the true alpha values from the data
    % plot( rgtAvg, rgaDataB13, 'k' );
    % plot( rgtAvg, rgaDataP09, 'k' );
    hold( 'off' );
    
    aMin = min( XB(:) ) - 0.05;
    aMax = max( XB(:) ) + 0.05;
    
    ylim( [ aMin, aMax ] );
    xlim( [ tMin, tMax ] );
    
    xlabel( 'Time (Myr)' );
    ylabel( '\theta_k' );
    
    subplot( 2, 2, 2 );
    hold( 'on' );
    lxP = plot( rgtAvg( 1:length( XP ) ), XP );
    for i = 1:length( lxP )
        % Plotting color c2 with 5% opacity.
        lxP( i ).Color = [ cMap( c2, : ), 0.05 ];
    end
    % Plot the mean
    mxP = plot( rgtAvg, mean( XP, 2 ), 'Color', cm2, 'LineWidth', 1.5 );
    % Plot the true alpha values from the data
    % plot( rgtAvg, rgaDataB13, 'k' );
    % plot( rgtAvg, rgaDataP09, 'k' );
    hold( 'off' );
    
    aMin = min( XP(:) ) - 0.05;
    aMax = max( XP(:) ) + 0.05;
    
    ylim( [ aMin, aMax ] );
    xlim( [ tMin, tMax ] );
    
    xlabel( 'Time (Myr)' );
    ylabel( '\theta_k' );
    
    subplot( 2, 2, 3 );
    hold( 'on' );
    lxB = plot( rgtAvg( 1:length( rgCDB ) ) + tAvg/2, rgCDB );
    for i = 1:length( lxB )
        lxB( i ).Color = [ cMap( c1, : ), 0.1 ];
    end
    plot( rgtAvg( 1:length( rgCDB ) ) + tAvg/2, mean( rgCDB, 2 ), ...
        'Color', cm1, 'LineWidth', 1.5 );
    plot( rgtAvg, rgCDAvg, 'k' );

    ylim( [ 0, 10 ] );
    xlim( [ tMin, tMax ] );

    xlabel( 'Time (Myr)' );
    ylabel( 'Mean Chron Dfigururation (Myr)' );

    hold( 'off' );
    
    subplot( 2, 2, 4 );
    hold( 'on' );
    lxP = plot( rgtAvg( 1:length( rgCDP ) ) + tAvg/2, rgCDP );
    for i = 1:length( lxB )
        lxP( i ).Color = [ cMap( c2, : ), 0.1 ];
    end
    plot( rgtAvg( 1:length( rgCDP ) ) + tAvg/2, mean( rgCDP, 2 ), ...
        'Color', cm2, 'LineWidth', 1.5 );
    plot( rgtAvg, rgCDAvg, 'k' );

    ylim( [ 0, 10 ] );
    xlim( [ tMin, tMax ] );

    xlabel( 'Time (Myr)' );
    ylabel( 'Mean Chron Duraiton (Myr)' );
    
    hold( 'off' );
    
    strSaveFile = sprintf( '%s/plotMaster', strSaveDir );
    if fSavePDF
        set( hFig, 'units', 'inches' );
        pos = get( hFig, 'position' );
        set( hFig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', ...
             'PaperSize', [ pos(3), pos(4) ] );
        print( hFig, strSaveFile, '-dpdf', '-r0' );
    end
    if fSaveFig
        savefig( hFig, strSaveFile );
    end
end


sB13 = load( strB13CR );
sP09 = load( strP09CR );
sCH = load( strCH );
sCH.vpolarity(end) = -1;
if fPlotExamples
    % ****** %
    % PLOT 4
    % ****** %
    % Example runs with variable alpha. 
    hFig = figure( 7 ); 
    clf;

    % Plot the GK 2007 data
    subplot( 3, 1, 1 );
    hold( 'on' );
    stairs( sCH.vage, sCH.vpolarity, 'k' );

    ylim( [ -1.5, 1.5 ] );
    xlim( [ -sB13.Steps 0 ] * sB13.dt * 1e-3 );

    subplot( 3, 1, 2 );
    hold( 'on' );
    plot( ( -sB13.Steps:-1 ) * sB13.dt * 1e-3, sB13.X, ...
          'color', [ cMap( c1, : ), 0.2 ] );
    plot( ( -sB13.Steps:-1 ) * sB13.dt * 1e-3, sign( sB13.X ), ...
          'color', cMap( c1, : ) );
    hold( 'off' );

    ylim( [ -1.5, 1.5 ] );
    xlim( [ -sB13.Steps 0 ] * sB13.dt * 1e-3 );

%     ylabel( 'Signed Dipole Intensity' );

    subplot( 3, 1, 3 );
    hold( 'on' );
    plot( ( -sP09.Steps:-1 ) * sP09.dt, sP09.X, 'color', [ cMap( c2, : ), 0.1 ] );
    plot( ( -sP09.Steps:-1 ) * sP09.dt, sign( sP09.X ), 'color', cMap( c2, : ) );
    hold( 'off' );

    ylim( [ -1.5, 1.5 ] );
    xlim( [ -sB13.Steps 0 ] * sB13.dt * 1e-3 );

    xlabel( 'Time (Myr)' );

    strSaveFile = sprintf( '%s/plotExampleRuns', strSaveDir );
    if fSavePDF
        set( hFig, 'units', 'inches' );
        pos = get( hFig, 'position' );
        set( hFig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', ...
             'PaperSize', [ pos(3), pos(4) ] );
        print( hFig, strSaveFile, '-dpdf', '-r0' );
    end
    if fSaveFig
        savefig( hFig, strSaveFile );
    end
end

sP = load( strP );
sS = load( strS );
sB13n = load( strB13CRA1 );
sP09n = load( strP09CRA1 );

if fPlotExamplesAlpha1Small
    % ****** %
    % PLOT 5
    % ****** %
    % Example runs with fixed alpha = 1, past 2 Myrs data 
    hFig = figure( 8 );
    clf;
    
    subplot( 3, 1, 1 );
    hold( 'on' );
    stairs( sCH.vage, sCH.vpolarity, 'k' );
    tMin = min( sP.epoch( 1 ), sS.epoch( 1 ) );
    tMax = max( sP.epoch( end ), sS.epoch( end ) );

    pP = plot( sP.epoch', sP.dipole, 'Color', [ cMap( c1, : ), 0.5 ], 'LineWidth', 1 );

    pS = plot( sS.epoch', sS.dipole, 'Color', [ cMap( c2, : ), 0.5 ], 'LineWidth', 1 );
    plot( [ tMin, tMax ], [ 0, 0 ], 'k--' );
    hold( 'off' );

    ylim( [ -1.5, 1.5 ] );
    xlim( [ -2e3 0 ] * sP09n.dt );

    smX = smooth( sB13n.X, 5 );
    nMove = 30;
    subplot( 3, 1, 2 );
    hold( 'on' );
    plot( nMove + ( -sB13n.Steps:-1 ) * sB13n.dt * 1e-3, smX, ...
          'color', [ cMap( c1, : ), 0.5 ] );
    plot( nMove + ( -sB13n.Steps:-1 ) * sB13n.dt * 1e-3, sign( smX ), ...
          'color', cMap( c1, : ) );
    hold( 'off' );

    ylim( [ -1.5, 1.5 ] );
    xlim( [ -2e3 0 ] * sB13n.dt * 1e-3 );

    subplot( 3, 1, 3 );
    hold( 'on' );
    plot( ( -sP09n.Steps:-1 ) * sP09n.dt, sP09n.X, 'color', [ cMap( c2, : ), 0.5 ] );
    plot( ( -sP09n.Steps:-1 ) * sP09n.dt, sign( sP09n.X ), 'color', cMap( c2, : ) );
    hold( 'off' );

    ylim( [ -1.5, 1.5 ] );
    xlim( [ -2e3 0 ] * sP09n.dt );

    xlabel( 'Time (Myr)' );
%     ylabel( 'Signed Dipole Intensity' );

    hyLab = get( gca, 'YLabel' );
    set( hyLab, 'Position', get( hyLab, 'Position' ) + [ 0, 4.25, 0 ] );

    strSaveFile = sprintf( '%s/plotExampleRunsAlpha1Small', strSaveDir );
    if fSavePDF
        set( hFig, 'units', 'inches' );
        pos = get( hFig, 'position' );
        set( hFig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', ...
             'PaperSize', [ pos(3), pos(4) ] );
        print( hFig, strSaveFile, '-dpdf', '-r0' );
    end
    if fSaveFig
        savefig( hFig, strSaveFile );
    end
end

if fPlotExamplesAlpha1Big
    % ****** %
    % PLOT 6
    % ****** %
    % Example runs with fixed alpha = 1, past 100 Myrs data 
    hFig = figure( 9 );
    clf;
    
    subplot( 3, 1, 1 );
    hold( 'on' );
    stairs( sCH.vage, sCH.vpolarity, 'k' );
    hold( 'off' );

    ylim( [ -1.5, 1.5 ] );
    xlim( [ -sP09n.Steps 0 ] * sP09n.dt );

    subplot( 3, 1, 2 );
    hold( 'on' );
    plot( ( -sB13n.Steps:-1 ) * sB13n.dt * 1e-3, sB13n.X, ...
          'color', [ cMap( c1, : ), 0.2 ] );
    plot( ( -sB13n.Steps:-1 ) * sB13n.dt * 1e-3, sign( sB13n.X ), ...
          'color', cMap( c1, : ) );
    hold( 'off' );

    ylim( [ -1.5, 1.5 ] );
    xlim( [ -sB13n.Steps 0 ] * sB13n.dt * 1e-3 );

    subplot( 3, 1, 3 );
    hold( 'on' );
    plot( ( -sP09n.Steps:-1 ) * sP09n.dt, sP09n.X, 'color', [ cMap( c2, : ), 0.1 ] );
    plot( ( -sP09n.Steps:-1 ) * sP09n.dt, sign( sP09n.X ), 'color', cMap( c2, : ) );
    hold( 'off' );

    ylim( [ -1.5, 1.5 ] );
    xlim( [ -sP09n.Steps 0 ] * sP09n.dt );

    xlabel( 'Time (Myr)' );
    ylabel( 'Signed Dipole Intensity' );

    hyLab = get( gca, 'YLabel' );
    set( hyLab, 'Position', get( hyLab, 'Position' ) + [ 0, 4.25, 0 ] );

    strSaveFile = sprintf( '%s/plotExampleRunsAlph1Big', strSaveDir );
    if fSavePDF
        set( hFig, 'units', 'inches' );
        pos = get( hFig, 'position' );
        set( hFig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', ...
             'PaperSize', [ pos(3), pos(4) ] );
        print( hFig, strSaveFile, '-dpdf', '-r0' );
    end
    if fSaveFig
        savefig( hFig, strSaveFile );
    end
end


%%
figure
stairs( sCH.vage, sCH.vpolarity, 'k' );
xlabel('Time in Myr')
ylabel('Polarity')
% title('Geomagnetic polarity time scale (Cande & Kent 1995)')
set(gca,'FontSize', 20)
axis([-150 0 -1 1])
box off

%%
% inds = find(rgCDAvg>10);
% rgCDAvg(inds) = 10;
figure
plot( rgtAvg, rgCDAvg, 'k','LineWidth',2);
axis([-140 0 0 10])
xlabel('Time in Myr')
ylabel('Mean chron duration in Myr')
% title('Extracted feature: mean chron duration')
set(gca,'FontSize', 20)
box off