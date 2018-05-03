if ~exist( 'strModel', 'var' )
    strModel = 'B13';
end

if ~exist( 'strSaveDir', 'var' )
    strSaveDir = sprintf( './testDifDt%s', strModel );
end
if ~exist( strSaveDir, 'dir' )
    mkdir( strSaveDir );
end

if ~exist( 'nMaxSteps', 'var' )
    nMaxSteps = 1e6;
end

if ~exist( 'spanSm', 'var' )
    spanSm = 25;
end
if spanSm > 1
    fSmooth = true;
else
    fSmooth = false;
end

if ~exist( 'dt', 'var' )
    dt = 1;
end

if ~exist( 'fPlot', 'var' )
    fPlot = false;
end


if ~exist( 'rga', 'var' )
    rga = 0.4:0.05:2.4;
end

if ~exist( 'nSamp', 'var' )
    nSamp = 1e3;
end

tAlpha = 1;

if ~exist( 'rgSteps', 'var' )
    rgSteps = [ 3e5*ones( size( find( rga < 0.7 + 1e2*eps ) ) ), ...
                1e5*ones( size( find( 0.7 + 1e2*eps <= rga & rga < 1 + 1e2*eps ) ) ), ...
                5e4*ones( size( find( 1 + 1e2*eps <= rga & rga < 1.6 + 1e2*eps ) ) ), ...
                2e4*ones( size( find( 1.6 + 1e2*eps <= rga ) ) ) ];
end
        

initVal = 0;
    
if strcmp( strModel, 'B13' )

    load( 'BruceB.mat' );
    load( 'Sf.mat' );
    SPModelB13 = struct( 'pD', pD , 'pv', pv, 'Sf', Sf );
    
    SParams = initParams( 'xErrMax', 5, ...
                'strModel', strModel, ...
                'strSaveDir', strSaveDir, 'spanSm', spanSm, ...
                'fnModel', @fnB13, 'nSamp', nSamp, ...
                'fSmooth', fSmooth, 'initVal', initVal, 'SPModel', SPModelB13, ...
                'fPost', false, 'dt', dt, 'tAlpha', tAlpha );
            
elseif strcmp( strModel, 'P09' )
    
    a1 = -185*1e-3;
    a0 = -.9*a1;
    s = sqrt(abs(a1))*.2;
    R = 1.3;
    theta_0 = 0.3;
    
    SPModelP09 = struct( 'a1', a1 , 'a0', a0, 's', s, 'R', R, 'theta_0', theta_0 );
    
    fnP09Post = @( theta, SPModel ) SPModel.R*cos( theta + SPModel.theta_0 );
    
    spanSm = 1;
    fSmooth = false;
    
    SParams = initParams( 'xErrMax', 5, 'nSamp', nSamp, ...
            'strModel', strModel, 'fSmooth', false, 'fnModel', @fnP09, ...
            'strSaveDir', strSaveDir, 'dt', dt, 'tAlpha', tAlpha, ...
            'fPost', true, 'fnPost', fnP09Post, 'initVal', initVal, ...
            'SPModel', SPModelP09, 'initPreVal', -36.7853 );
        
else
    error( 'Model name %s not recognized', strModel )
end
    
for a = rga
    alpha = a * ones( 1, nSamp );
    iS = find( rga < a, 1, 'last' );
    if isempty( iS )
        iS = 1;
    end
    nMaxSteps = rgSteps( iS );
    
    SParams.alpha = alpha;
    SParams.nMaxSteps = nMaxSteps;

    if fSmooth
        tic;
        [ z, zSm ] = fnCRa( SParams );
        toc;
    else
        tic;
        zSm = fnCRa( SParams );
        toc;
    end
        
    
    % tAvg = 10;
    % rgAvgCD = fnGetAvgCD( zSm, iBurnIn, dt, tAvg );
    
    iBurnIn = ceil( 100 / dt );
    rgDiff = diff( sign( zSm( iBurnIn:end, : ) ) );
    cDiff = mat2cell( rgDiff, size( rgDiff, 1 ), ones( size( rgDiff, 2 ), 1 ) );
    cRev = cellfun( @( C ) iBurnIn - 1 + find( C ), cDiff, 'UniformOutput', false );
    idx = cellfun( @isempty, cRev );
    cRev( idx ) = { SParams.nMaxSteps };
    idx = ~idx;
    rgEnd = cellfun( @( c ) c( end ), cRev( idx ) );
    rgLength = cellfun( @length, cRev( idx ) );
    idx( idx ) = ( SParams.nMaxSteps - rgEnd ) >= ( rgEnd ./ rgLength );
    cRev( idx ) = cellfun( @( c ) [ c; SParams.nMaxSteps ], cRev( idx ), 'UniformOutput', false );
    rgCD = cellfun( @( c ) c( end ), cRev ) ./ cellfun( @length, cRev ) * dt * 1e-3;

    fTaken = true;
    iFile = 0;
    while fTaken
        iFile = iFile+1;
        strSaveFile = sprintf( '%s/%salpha%.02ftrial%04d.mat', strSaveDir, strModel, a, iFile );
        if ~exist( strSaveFile, 'file' )
            fTaken = false;
        end
    end
    save( strSaveFile, 'rgCD', 'cRev', 'dt', 'SParams', 'iBurnIn' );
    
end

