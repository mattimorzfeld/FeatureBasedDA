nIter = 10;

rgtMax = [ 500 200 100 80 50 20 ];
tMax = 100; % rgtMax( 1 );
alpha = 1;
nRev = 2e2;
nMaxSteps = 1e8;
dt = 1;
fSmooth = true;

if ~exist( 'spanSm', 'var' )
    spanSm = 1e2;
end
if spanSm <= 1
    fSmooth = false;
end

mina = 1;
maxa = 1;
stepa = 1;

if ~exist( 'strSaveDir', 'var' )
    strSaveDir = './test';
end

if ~exist( strSaveDir, 'dir' )
    mkdir( strSaveDir );
end

nTrials = 1;
tAlpha = tMax;
strModel = 'B13';


load( 'BruceB.mat' );
load( 'Sf.mat' );
SPModelB13 = struct( 'pD', pD , 'pv', pv, 'Sf', Sf );

initVal = 0;

SParams = initParams( 'tMax', tMax, 'xErrMax', 50, ...
            'nMaxSteps', nMaxSteps, 'strModel', 'B13', ...
            'strSaveDir', strSaveDir, 'spanSm', spanSm, ...
            'nReverse', nRev, 'fnModel', @fnB13, ...
            'fSmooth', fSmooth, 'initVal', initVal, 'SPModel', SPModelB13, ...
            'fPost', false, 'alpha', mina );
        
rga = 0.4:0.02:2;
rgdt = 2 .^ ( 3:-1:-2 );

rgMeans = zeros( nIter, 1 );
idt = 1;
    
ia = 1;
msf = 5;
nsf = 1;
isf = 0;

if ~exist( 'a', 'var' )
    a = 1;
else
    a = a(1);
end

if a < 0.6
    dt = 10;
    tMax = 500;
elseif a < 1.2
    dt = 2;
    tMax = 100;
elseif a < 1.6
    dt = 1;
    tMax = 50;
else
    dt = 0.5;
    tMax = 50;
end
iBurnIn = max( 10, ceil( 100 / dt ) );
SParams = rmfield( SParams, 'dt' );
        
tTot = tic;
SParams.alpha = a;
SParams.nSamp = 100;

for iIter = 1:nIter
    tic;
    % SParams.dw = randn( 1, nMaxSteps ) * sqrt( dt );
    if fSmooth
        [ ~, zSm ] = fnCR( SParams );
    else
        zSm = fnCR( SParams );
    end
    
    rgRev = iBurnIn - 1 + find( diff( sign( zSm( iBurnIn:end ) ) ) );
    
    if ~isempty( rgRev )
        tEnd = min( length( zSm ), SParams.nMaxSteps );
        if rgRev( end ) < tEnd
            if tEnd - rgRev( end ) >= rgRev( end ) / length( rgRev )
                rgRev = [ rgRev; tEnd ];
            end
        end
    else
        rgRev = length( zSm );
    end
    
    toc;

    tMCD = rgRev( end ) * dt / length( rgRev );


    rgMeans( iIter ) = tMCD;
end

tTot = toc( tTot );

fprintf( 'Total time: %.0f seconds (%.2f hours)\n\n', tTot, tTot/3600 );

rgM = mean( rgMeans );
rgSD = std( rgMeans );
% figure; errorbar( rga, rgM, rgSD );

iFile = 1;
strSaveFile = sprintf( '%s/testa%.02fspan%03dtrial%04d.mat', strSaveDir, a, spanSm, iFile );

while exist( strSaveFile, 'file' )
    strSaveFile = sprintf( '%s/testa%.02fspan%03dtrial%04d.mat', strSaveDir, a, spanSm, iFile );
    iFile = iFile + 1;
    
    if iFile == 1e4
        break;
    end
end

save( strSaveFile, 'rgMeans', 'rgM', 'rgSD', 'a', 'SParams' );