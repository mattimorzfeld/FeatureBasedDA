function z = f2( a, SParams )
    dt = SParams.dt;
    nMaxSteps = SParams.nMaxSteps;
    iBurnIn = ceil( 100 / dt );
    SParams.alpha = a;
    zSm = fnCRa( SParams );
    
    rgDiff = diff( sign( zSm( iBurnIn:end, : ) ) );
    cDiff = num2cell( rgDiff, 1 );
    cRev = cellfun( @( C ) iBurnIn - 1 + find( C ), cDiff, 'UniformOutput', false );
    idx = cellfun( @isempty, cRev );
    cRev( idx ) = { nMaxSteps };
    idx = ~idx;
    rgEnd = cellfun( @( c ) c( end ), cRev( idx ) );
    rgLength = cellfun( @length, cRev( idx ) );
    idx( idx ) = ( nMaxSteps - rgEnd ) >= ( rgEnd ./ rgLength );
    cRev( idx ) = cellfun( @( c ) [ c; nMaxSteps ], cRev( idx ), 'UniformOutput', false );
    z = cellfun( @( c ) c( end ), cRev ) ./ cellfun( @length, cRev ) * dt * 1e-3;
    
    
%     rgRev = iBurnIn - 1 + find( diff( sign( zSm( iBurnIn:end ) ) ) );
%     if ~isempty( rgRev )
%         tEnd = min( length( zSm ), SParams.nMaxSteps );
%         if rgRev( end ) < tEnd
%             if tEnd - rgRev( end ) >= rgRev( end ) / length( rgRev )
%                 rgRev = [ rgRev; tEnd ];
%             end
%         end
%     else
%         rgRev = length( zSm );
%     end
%
%     z = rgRev( end ) * dt / length( rgRev ) * 1e-3;