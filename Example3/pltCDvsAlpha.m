if ~exist( 'rga', 'var' )
    rga = 0.4:0.05:2.4;
end

if ~exist( 'strModel', 'var' )
    strModel = 'B13';
end

if ~exist( 'strSaveDir', 'var' )
    strSaveDir = sprintf( 'C:/Users/Jesse/Documents/MATLAB/Geomagnetics/testDiffDt%s', strModel );
end

if ~exist( 'iTrial', 'var' )
    iTrial = 1;
end

rgM = zeros( size( rga ) );
rgSD = zeros( size( rga ) );
rgAlpha = zeros( size( rga ) );

i = 1;
for a = rga
    strLoad = sprintf( '%s/%salpha%.02ftrial%04d.mat', strSaveDir, strModel, a, iTrial );
    if exist( strLoad, 'file' )
        load( strLoad, 'rgCD' );
        
        rgM( i ) = mean( rgCD );
        rgSD( i ) = std( rgCD );
        rgAlpha( i ) = a;
        i = i+1;
    end
end

rgM = rgM( 1:i-1 );
rgSD = rgSD( 1:i-1 );
rgAlpha = rgAlpha( 1:i-1 );

figure;
errorbar( rgAlpha, rgM, 2*rgSD );