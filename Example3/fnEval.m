function f = fnEval( z, Sf )
%% fnEval - This function evaluates a piecewise function defined in the structure Sf 
%           at the value z.
%
% Inputs
%   z:  point to evaluate the function at.
%   Sf: A data structure containing the following:
%           rgx: range of x values where the rule changes
%           CPoly: Cell array of polynomial coefficients
%   
%
% Outputs: 
%   f:  f(z).
% 
% Written by:	Jesse Adams 	
% Last Edited:	2017.02.14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    iMin = find( Sf.rgx > z, 1 );
    if isempty( iMin )
        iMin = length( Sf.rgx ) + 1;
    end
    f = polyval( Sf.CPoly{ iMin }, z );
    % f = dot( Sf.CPoly{ iMin }, z.^( length( Sf.CPoly{ iMin } )-1:-1:0 ) );
    
    