function varargout = fnCRa( SParams )
%% fnCRa - This function outputs a chron run based on the provided input values.
%
% Inputs
%   SParams:    A data structure containing 
%   
%
% Outputs
% 
% Written by:	Jesse Adams 	
% Last Edited:	2017.03.14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Begin by saving local copies of some of variables in SParams for the
    % sake of readability.
    % tMax = SParams.tMax;
    nMaxSteps = SParams.nMaxSteps;
    zInit = SParams.initVal;
    fnModel = SParams.fnModel;
    SPModel = SParams.SPModel;
    fSmooth = SParams.fSmooth;
    fPost = SParams.fPost;
    errMax = SParams.xErrMax;
    dt = SParams.dt;
    nSamp = SParams.nSamp;
    tAlpha = SParams.tAlpha(:);
    
%     if nMaxSteps ~= 1e3 * ceil( tMax / dt )
%         warning( 'Setting nMaxSteps = 1e3 * ceil( tMax / dt )' );
%         nMaxSteps = 1e3 * ceil( tMax / dt );
%     end
    
    nAlpha = size( SParams.alpha, 1 );
    % Make sure tAlpha won't break any conditions, i.e. sorted, no
    % negatives, and nothing past the max step number
    if ~issorted( tAlpha )
        warning( 'tAlpha must be sorted ascending, sorting tAlpha' );
        tAlpha = sort( tAlpha(:) );
    end
    if any( mod( tAlpha, 1 ) )
        warning( 'tAlpha must contain positive integers, rounding tAlpha' );
        tAlpha = round( tAlpha );
    end
    if any( tAlpha < 0 ) || any( tAlpha > nMaxSteps )
        warning( 'tAlpha must contain values at least 1 and at most nMaxSteps, ' );
        tAlpha = tAlpha( tAlpha > 0 && tAlpha <= nMaxSteps );
    end
    if tAlpha( 1 ) ~= 1
        warning( 'expecting tAlpha(1) = 1; adding this' );
        tAlpha = [ 1; tAlpha ];
    end
    if length( tAlpha ) > nAlpha
        warning( 'length( tAlpha ) must be at most size( alpha, 1 ), truncating' );
        tAlpha = tAlpha( 1:nAlpha );
    end
        
    % Make the output vector as small as is allowed based on the number of
    % iterations that will occur in the loop.
    zLen = 1 + nMaxSteps;
    z = zeros( zLen, nSamp );
    z( 1, : ) = zInit;
    
    % if needed, make a random vector of appropriate size
    if ~isfield( SParams, 'dw' )
        dw = randn( zLen, nSamp ) * sqrt( dt );
    else
        dw = SParams.dw;
    end
    
    if fSmooth
        spanSm = max( 3, 2*floor( SParams.spanSm/( 2*dt ) ) + 1 );
        zSm = z;
    end
    if fPost
        zPreInit = SParams.initPreVal;
        fnPost = SParams.fnPost;
        zPre = z;
        zPre( 1, : ) = zPreInit;
    end
    
    iAlpha = 1;
    % Terminate when max steps have been reached
    for iStep = 1:nMaxSteps
        if iAlpha <= nAlpha
            if iStep == tAlpha( iAlpha )
                alpha = SParams.alpha( iAlpha, : );
                iAlpha = iAlpha + 1;
            end
        end
        
        % Check if there is a post processing step necessary.
        if fPost
            zPre( iStep+1, : ) = fnModel( zPre( iStep, : ), alpha, dt, dw( iStep, : ), SPModel );
            z( iStep+1, : ) = fnPost( zPre( iStep+1, : ), SPModel );
        else
            % apply the model to get the next 
            z( iStep+1, : ) = fnModel( z( iStep, : ), alpha, dt, dw( iStep, : ), SPModel );
        end
        
        % Check that the value is in the expected range
        if any( abs( z( iStep+1, : ) ) > errMax )
            iBad = abs( z( iStep+1, : ) ) > errMax;
            z( iStep+1, iBad ) = z( iStep, iBad );
            % warning( 'The output became unstable, aborting' );
            % break;
        end
    end
    
    % finish smoothing the tails, and check for reversals in the tails
    if fSmooth
        
        zSm = cell2mat( cellfun( @( z ) smooth( z, spanSm ), num2cell( z, 1 ), ...
                        'UniformOutput', false ) );
        
        if nargout == 1
            varargout{1} = zSm;
        elseif nargout >= 2
            varargout{1} = z;
            varargout{2} = zSm;
        end
    else
        varargout{1} = z;
    end        

end