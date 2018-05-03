function thetaNext = fnP09( theta, varargin )
%% fnP09 - Performs one iteration of Petrellis' 2009 model of the geomagnetic 
%          dipole.
%
% Inputs
%   theta:      Previous step's angle
% Optional inputs
%   alpha:      scaling parameter
%   dt:         time step
%   dw:         Random perterbation, usually N( 0, dt )
%   SPModel:    A data structure containing parameters for the model.
%               The P09 model requires:
%                   a1:         some sort of scaling parameter for the angle
%                   a0:         another angle parameter, shifts
%                   R:          scaling factor for actual z output value
%                   s:          scaling parameter of stochastic component
%                   theta_0:    some sort of additive parameter for the angle
%   
%
% Outputs
%   zNext:      The next point in the time series based on the inputs
% 
% Written by:	Jesse Adams 	
% Last Edited:	2016.09.22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin < 5
        % if no SPModel was provided, load from file
        load( 'P09.mat' );
        
        if nargin < 4
            if nargin < 3
                dt = 1;
                
                if nargin < 2
                    alpha = 1;
                else
                    alpha = varargin{1};
                end
            else
                alpha = varargin{1};
                dt = varargin{2};
            end
            dw = randn() * sqrt( dt );
        else
            alpha = varargin{1};
            dt = varargin{2};
            dw = varargin{3};
        end
    else
        alpha = varargin{1};
        dt = varargin{2};
        dw = varargin{3};
        SPModel = varargin{4};
    end
    
    theta = theta + dt*( SPModel.a0 + SPModel.a1*sin( 2*theta ) );
    thetaNext = real( theta + SPModel.s*alpha.*dw );
    
    % dx/d\tau = 1/\alpha f(x) d\tau + \sigma(x) dw
end