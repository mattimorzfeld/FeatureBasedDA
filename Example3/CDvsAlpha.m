% Need to make the CD vs alpha curve.
% Goal: 100 iterations per alpha, with at least
% 10 reversals per iteration.

% Ideally, alpha and the maximum number of iterations should already be
% defined. 
if ~exist( 'mina', 'var' )
    mina = 1;
end
if ~exist( 'maxa', 'var' )
    maxa = 1;
end
if ~exist( 'stepa', 'var' )
    stepa = 1;
end
if ~exist( 'nMaxSteps', 'var' )
    nMaxSteps = 1e6;
end
if ~exist( 'dt', 'var' )
    dt = 1;
end
if ~exist( 'strSaveDir', 'var' )
    strSaveDir = './alphavsCD';
end
if ~exist( 'nRev', 'var' ) 
    nRev = 1e2;
end
if ~exist( 'spanSm', 'var' )
    spanSm = ceil( 8e2 / dt );
end
if ~exist( 'nIter', 'var' )
    nIter = 1e2;
end

tMax = dt * nMaxSteps;
if ~exist( strSaveDir, 'dir' )
    mkdir( strSaveDir );
end

load( 'BruceB.mat' );
SPModelB13 = struct( 'pD', pD , 'pv', pv );

initVal = 0;

SParamsB13 = initParams( 'tMax', tMax, 'xErrMax', 5, ...
            'nMaxSteps', nMaxSteps, 'strModel', 'B13', ...
            'strSaveDir', strSaveDir, 'spanSm', spanSm, ...
            'nReverse', nRev, 'fnModel', @fnB13, ...
            'fSmooth', true, 'initVal', initVal, 'SPModel', SPModelB13, ...
            'fPost', false, 'alpha', mina, 'dt', dt );
       

for alpha = mina:stepa:maxa
    cz = {};
    czSm = {};
    czRev = {};
    rgCD = zeros( nIter, 1 );
    SParamsB13.alpha = alpha;
    
    for iIter = 1:nIter
        SParamsB13.dw = randn( 1, nMaxSteps ) * sqrt( dt );

        tic;
        [ zB13, zSmB13, rgRevB13 ] = fnCR( SParamsB13 );
        toc;

        % Save the raw data
        cz{ iIter } = zB13;
        czSm{ iIter } = zSmB13;
        czRev{ iIter } = rgRevB13;

        % Calculate the mean chron duration for the run
        if ~isempty( rgRevB13 )
            rgCD( iIter ) = rgRevB13( end ) * dt / length( rgRevB13 );
        else
            rgCD( iIter ) = tMax;
        end
    end
    % Calculate the overall mean CD and sd for the runs
    meanCD = mean( rgCD );
    sdCD = std( rgCD );

    strSaveFile = sprintf( '%s/B13alpha%fdt%f.mat', strSaveDir, ...
                    alpha, dt );
    save( strSaveFile, 'cz', 'czSm', 'czRev', 'alpha', 'dt', 'rgCD', 'meanCD', ...
        'sdCD', 'SParamsB13' );
end


