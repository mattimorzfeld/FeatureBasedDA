function zNext = fnB13( z, varargin )
%% fnB13 - Performs one iteration of Bruce Buffett's 2013 model of the 
%          geomagnetic dipole.
%
% Inputs
%   z:          Value from previous step
% Optional inputs
%   alpha:      scaling parameter
%   dt:         time step
%   dw:         Random perterbation, usually N( 0, dt )
%   SPModel:    A data structure containing parameters for the model.
%               The B13 model requires:
%                   pD: a vector for use with polyval and
%                   pv: a struct for use with fnval.
%                   Sf: a struct for use with fnEval (instead of pv).
%   
%
% Outputs
%   zNext:      The next point in the time series based on the inputs
% 
% Written by:	Jesse Adams 	
% Last Edited:	2017.02.13
% 
% See also POLYVAL, FNVAL.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin < 2
        alpha = 1;
        dt = 1;
        dw = randn();
        load( 'BruceB.mat' );
    elseif nargin < 3
        alpha = varargin{1};
        dt = 1;
        dw = randn();
        load( 'BruceB.mat' );
    elseif nargin < 4
        alpha = varargin{1};
        dt = varargin{2};
        dw = randn() * sqrt( dt );
    elseif nargin < 5
        alpha = varargin{1};
        dt = varargin{2};
        dw = varargin{3};
        load( 'BruceB.mat' );
    elseif nargin >= 5
        alpha = varargin{1};
        dt = varargin{2};
        dw = varargin{3};
        SPModel = varargin{4};
        
        pD = SPModel.pD;
        pv = SPModel.pv;
    end
        

%     if nargin < 5
%         % if no SPModel was provided, load from file
%         load( 'BruceB.mat' );
%         
%         if nargin < 4
%             
%             if nargin < 3
%                 dt = 1;
%                 
%                 if nargin < 2
%                     alpha = 1;
%                 else
%                     alpha = varargin{1};
%                 end
%             else
%                 alpha = varargin{1};
%                 dt = varargin{2};
%             end
%             
%             dw = randn() * sqrt( dt );
%         else
%             alpha = varargin{1};
%             dt = varargin{2};
%             dw = varargin{3};
%         end
%     else
%         alpha = varargin{1};
%         dt = varargin{2};
%         dw = varargin{3};
%         SPModel = varargin{4};
%         
%         pD = SPModel.pD;
%         pv = SPmodel.pv;
%     end
    
    % RK4 implemented to help with stability
    k1 = arrayfun( @(z) fnEval( z, SPModel.Sf ), z );
    k2 = arrayfun( @(z) fnEval( z, SPModel.Sf ), z + k1 * dt/2 );
    k3 = arrayfun( @(z) fnEval( z, SPModel.Sf ), z + k2 * dt/2 );
    k4 = arrayfun( @(z) fnEval( z, SPModel.Sf ), z + k3 * dt/2 );
    
    zNext = z + ( k1 + 2*k2 + 2*k3 + k4 ) * dt/6 + alpha .* sqrt( polyval( pD, z ) ) .* dw;
    
end