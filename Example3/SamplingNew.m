if ~exist( 'nSamp', 'var' )
    nSamp = 10;
end

if ~exist( 'nStep', 'var' )
    nStep = 1;
end

if ~exist( 'strModel', 'var' )
    strModel = 'B13';
end

if ~exist( 'strSaveDir', 'var' )
    strSaveDir = sprintf( './testSampling%s', strModel );
end
if ~exist( strSaveDir, 'dir' )
    mkdir( strSaveDir );
end
 
if ~exist( 'mina', 'var' )
    mina = 1;
end

if ~exist( 'nMaxSteps', 'var' )
    nMaxSteps = 1e6;
end
if ~exist( 'nRev', 'var' ) 
    nRev = 2e2;
end
if ~exist( 'spanSm', 'var' )
    spanSm = 25;
end
if spanSm > 1
    fSmooth = true;
else
    fSmooth = false;
end
if ~exist( 'nIter', 'var' )
    nIter = 1;
end

if ~exist( 'a', 'var' )
    a = ones( 1, nSamp );
end

if ~exist( 'dt', 'var' )
    dt = 1;
end
tMax = 500;

if ~exist( 'fPlot', 'var' )
    fPlot = false;
end

tAlpha = 1;

if ~exist( 'rga', 'var' )
    rga = 0.4:0.05:2.4;
end

if ~exist( 'rgSteps', 'var' )
    rgSteps = [ 3e5*ones( size( find( rga < 0.7 + 1e2*eps ) ) ), ...
                1e5*ones( size( find( 0.7 + 1e2*eps <= rga & rga < 1 + 1e2*eps ) ) ), ...
                5e4*ones( size( find( 1 + 1e2*eps <= rga & rga < 1.6 + 1e2*eps ) ) ), ...
                2e4*ones( size( find( 1.6 + 1e2*eps <= rga ) ) ) ];
end

if strcmp( strModel, 'P09' )
    
    a1 = -185*1e-3;
    a0 = -.9*a1;
    s = sqrt(abs(a1))*.2;
    R = 1.3;
    theta_0 = 0.3;
    
    initVal = 0;
    
    SPModelP09 = struct( 'a1', a1 , 'a0', a0, 's', s, 'R', R, 'theta_0', theta_0 );
    
    fnP09Post = @( theta, SPModel ) SPModel.R*cos( theta + SPModel.theta_0 );
    
    spanSm = 1;
    fSmooth = false;
    
    SParams = initParams( 'xErrMax', 5, 'nSamp', nSamp, ...
            'strModel', strModel, 'fSmooth', false, 'fnModel', @fnP09, ...
            'strSaveDir', strSaveDir, 'dt', dt, 'tAlpha', tAlpha, ...
            'fPost', true, 'fnPost', fnP09Post, 'initVal', initVal, ...
            'SPModel', SPModelP09, 'initPreVal', -36.7853 );
        
elseif strcmp( strModel, 'B13' )

    load( 'BruceB.mat' );
    load( 'Sf.mat' );
    SPModelB13 = struct( 'pD', pD , 'pv', pv, 'Sf', Sf );

    initVal = 0;

    SParams = initParams( 'tMax', tMax, 'xErrMax', 5, ...
                'strModel', 'B13', ...
                'strSaveDir', strSaveDir, 'spanSm', spanSm, ...
                'nReverse', nRev, 'fnModel', @fnB13, ...
                'fSmooth', fSmooth, 'initVal', initVal, 'SPModel', SPModelB13, ...
                'fPost', false, 'alpha', a, 'dt', dt, 'tAlpha', tAlpha );
end

if ~exist( 'strLoad', 'var' )
    strLoad = sprintf( './%salphavsCD2.mat', strModel );
end
if ~exist( strLoad, 'file' )
    error( 'file %s DNE', strLoad );
else
    SLoad = load( strLoad );
end
rgA = SLoad.rgAlpha;
rgCD = SLoad.rgSmMeans;
rgSD = min( SLoad.rgSmSDs, 2.5 );

X = zeros( nStep, nSamp );
W = zeros( nStep, nSamp );

% Modifiable, test these
s_s = 0.1;

load( 'GK2007Alpha250.mat' );
nStep = length( rgCDAvg );
z = rgCDAvg( 1 );

S = struct( 's_s', s_s, 's_z', fnCDtoSD( z, rgCD, rgSD ), ...
            'a_s', fnCDtoAlpha( z, rgA, rgCD ), ...
            'S', SParams, 'rgCD', rgCD, 'rgSD', rgSD, 'rgA', rgA, ...
            'nSamp', nSamp, 'fNormWeights', false ); 
S.s_0 = S.s_s;
S.a_0 = S.a_s;

S.S.nMaxSteps = rgSteps( find( rga < S.a_0, 1, 'last' ) );
    
tTot = tic;
for iStep = 1:nStep
    
    tStep = tic;
    z = rgCDAvg( iStep );
    % Calculate samples and part of weights at current time step for all
    % samples
    % for iSamp = 1:nSamp
    [ X( iStep, : ), W( iStep, : ) ] = fnSample( z, S );
    % end
    
    % Normalize the weights, and resample the Xs
    W( iStep, : ) = normalizeweights( W( iStep, : ) );
    X( iStep, : ) = resampling( W( iStep, : ), X( iStep, : ), nSamp, 1 );
    
    % Set the new values for the next iteration
    S.a_0 = X( iStep, : ) * W( iStep, : )';
    S.s_s = s_s/2;
    S.a_s = fnCDtoAlpha( z, rgA, rgCD );
    S.s_z = fnCDtoSD( z, rgCD, rgSD );
    
    iS = find( rga < min( X( iStep, : ) ), 1, 'last' );
    if isempty( iS )
        iS = 1;
    end
    S.S.nMaxSteps = rgSteps( iS );
    
    tStep = toc( tStep );
    fprintf( 'finished step %d in %.02f minutes\n', iStep, tStep/60 );
end
tTot = toc( tTot );
fprintf( 'finished all steps in %.02f hours \n', tTot/3600 );

if fPlot
    rgaData = zeros( size( rgCDAvg ) );

    for i = 1:length( rgCDAvg )
        rgaData( i ) = fnCDtoAlpha( rgCDAvg( i ), rgA, rgCD );
    end

    Xavg = sum( X .* W, 2 );

    figure; plot( rgtAvg, rgaData, rgtAvg( 1:length( Xavg ) ), Xavg );
    figure; plot( rgtAvg, rgaData, 'k' );
    hold( 'on' );
    lx = plot( rgtAvg( 1:length( X ) ), X );
    for i = 1:length( lx )
        lx(i).Color = [ 1 0 0 0.2 ];
    end
end

fTaken = true;
iFile = 0;
while fTaken
    iFile = iFile+1;
    strSaveFile = sprintf( '%s/%ssamps%04d.mat', strSaveDir, strModel, iFile );
    if ~exist( strSaveFile, 'file' )
        fTaken = false;
    end
end
save( strSaveFile, 'X', 'W', 'S' );