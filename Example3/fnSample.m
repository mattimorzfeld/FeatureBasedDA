function [ a, F ] = fnSample( z, SPar )
    

    % Make sure we have all the necessary pieces
    if ~isfield( SPar, 's_z' )
        s_z = fnCDtoSD( z, SPar.rgCD, SPar.rgSD );
    else
        s_z = SPar.s_z;
    end
    if ~isfield( SPar, 's_0' )
        s_0 = 0.1;
    else
        s_0 = SPar.s_0;
    end
    if ~isfield( SPar, 's_s' )
        s_s = s_0 / 2;
    else
        s_s = SPar.s_s;
    end
    if ~isfield( SPar, 'a_s' )
        a_s = fnCDtoAlpha( z, SPar.rgA, SPar.rgCD );
    else
        a_s = SPar.a_s;
    end
    if ~isfield( SPar, 'a_0' )
        a_0 = a_s;
    else
        a_0 = SPar.a_0;
    end
    if ~isfield( SPar, 'nSamp' )
        nSamp = 1;
    else
        nSamp = SPar.nSamp;
    end
    if ~isfield( SPar, 'fNormWeights' )
        fNormWeights = false;
    else
        fNormWeights = SPar.fNormWeights;
    end
    
    SPar.S.nSamp = nSamp;
    % Generate random samples of p, q, and calculate w
    a = a_s + s_s * randn( 1, nSamp );
    F = ( z - f2( a, SPar.S ) ).^ 2 / ( 2 * s_z^2 ) ...
        + ( a - a_0 ).^2 / ( 2 * s_0^2 ) ...
        - ( a - a_s ).^2 / ( 2 * s_s^2 );
    %p = a_0 + s_0 * randn( nSamp, 1 ) + exp( - ( z - f2( a, SPar.S ) ).^2 / ( 2 * s_z^2 ) ) / ( sqrt( 2*pi ) * s_z ); 
    %q = a_s + s_s * randn( nSamp, 1 );
    %w = p ./ q;
    
    %if fNormWeights
    %    w = w / sum( w );
    %end
end