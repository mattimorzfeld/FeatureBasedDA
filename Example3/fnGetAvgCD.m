function rgAvgCD = fnGetAvgCD( rgCR, iBurnIn, dt, tAvg )
    rgDiff = diff( sign( rgCR( iBurnIn:end, : ) ) );
    [ nMaxSteps, nSamp ] = size( rgCR );
    tMax = ceil( nMaxSteps * dt * 1e-3 );
    rgAvgCD = zeros( tMax-tAvg+1, nSamp );
    
    for iSamp = 1:nSamp
        rgRev = iBurnIn - 1 + find( rgDiff( :, iSamp ) );
        if ~isempty( rgRev )
            if rgRev( end ) < nMaxSteps
                if nMaxSteps - rgRev( end ) >= rgRev( end ) / length( rgRev )
                    rgRev = [ rgRev; nMaxSteps ];
                end
            end
        else
            rgRev = nMaxSteps;
        end
        
        rgnRev = zeros( tMax-tAvg+1, 1 );

        for iRev = tAvg:tMax
            rgnRev( iRev-tAvg+1 ) = nnz( ( rgRev < 1e3 * iRev ) ...
                                .* ( rgRev >= 1e3 * ( iRev - tAvg ) ) );
        end

        rgAvgCD( :, iSamp ) = min( tAvg ./ rgnRev, 250 );

    end
end