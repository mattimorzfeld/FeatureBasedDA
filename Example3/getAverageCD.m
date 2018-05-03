rgt = csvread( 'GK2007.csv' );
rgt = rgt';
rgt = -rgt( end:-1:1 );
rgt = [ -157.53, rgt ];

rgy = repmat( [ -1 1 ], 1, floor( length( rgt ) / 2 ) );
rgy = [ 1, rgy ];

rgDiff = diff( rgt );

figure; 
hold( 'on' );
for tAvg = 10 % [ 1, 5, 10, 20, 50 ]
    rgtAvg = ( floor( rgt( 2 ) ) + tAvg ):ceil( rgt( end-1 ) );
    rgnRev = zeros( size( rgtAvg ) );

    for i = 1:length( rgtAvg )
        rgnRev( i ) = nnz( ( rgt( 2:end-1 ) < rgtAvg( i ) ) ...
                            .* ( rgt( 2:end-1 ) >= rgtAvg( i ) - tAvg ) );
    end

    rgCDAvg = min( tAvg ./ rgnRev, 250 );
    
    stairs( rgtAvg - tAvg/2, rgCDAvg );
end
hold( 'off' );

strSaveFile = './GK2007Alpha.mat';
save( strSaveFile, 'rgtAvg', 'rgnRev', 'rgCDAvg', 'tAvg' );

