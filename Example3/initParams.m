function SParams = initParams( varargin )
%% initParams - initializes a structure of parameters for input to 
%               fnChronDurration function.
%				The input must be formated as pairs of the form 
%					'variableName', variableValue
%				e.g. to set the parameter delta to 1, and all other 
%               parameters to the default, call
%					initParams( 'delta', 1 );
%               You can also optionally include an initial SParams as the
%               first argument, if most inputs have been set but you'd like
%               to update a small number of them. e.g.
%                   initParams( SParams, 'delta', 1 );
%               will set delta to 1, but preserve all existing parameter
%               values.
%
% Possible Inputs:
%   alpha:      Either scalar or vector of alpha values to use during the
%               computation. Alpha is the coefficient of the stochastic
%               term in the SDE.
%   alphaMax:   Largest alpha value allowed for the model.
%   alphaMin:   Smallest alpha value allowed for the model.
%   alphaStep:  ????
%   dt:         Time step to use for computations.
%   dw:         Random vector, stochastic component.
%   fDisp:      Whether or not to display progress information.
%   fnModel:    Function handle for the model.
%   fSave:      Whether or not to save results within the function.
%   initVal:    Initial value to seed the SDE with.
%   nMaxSteps:  Maximum number of dt steps taken before breaking, even if
%               the number of reversals wanted was not achieved.
%   nReverse:   Number of reversals wanted.
%   nTrials:    Number of seperate iterated trials to perform.
%   spanSize:   ????
%   SPModel:    Structure of parameters necessary for the chosen model.
%   Steps:      ????
%   stepSize:   ????
%   strModel:   String for the name of the model to use.
%   strSaveDir: String name of directory to save results in.
%   tAlpha:     ????
%   tMax:       Maximum time allowed to simulate for.
%   xErrMax:    Maximum allowable absolute value of the SDE, otherwise
%               assume the SDE has become unstable.
%   
%
% Outputs
%   SParams:	A data structure containing all of the paramaters, either 
%               set to the input value given or a default value.
% 
% Written by:	Jesse Adams 	
% Last Edited:	2016.03.14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	% The number of inputs must be even, as they are given as pairs
	if ~mod( nargin, 2 ) 
        % initialize with 
        SParams = struct( 'alphaMin', 1, 'alphaMax', 1, 'alphaStep', 1, 'nTrials', 10, ...
                          'tMax', 200, 'xErrMax', 2, 'Steps', 2e5, 'stepSize', 2e3, ...
                          'strModel', 'B13', 'strSaveDir', './ChronRunsB13dt1', ...
                          'dt', 1, 'spanSize', 200, 'alpha', 1, 'tAlpha', 1, ...
                          'fSave', false, 'fDisp', false, 'fPost', false, 'nSamp', 1 );
                      
        iAdj = 0;
	else
        if ~isa( varargin{1}, 'struct' )
            error( 'With an odd number of arguments, the first argument must be a struct' );
        end
        
        SParams = varargin{1};
        
        iAdj = 1;
	end
	
	for iVar = 1:( nargin / 2 )
		switch varargin{ 2*iVar + iAdj - 1 }
                
            case 'alpha'
                SParams.alpha = varargin{ 2*iVar + iAdj };
				
			case 'alphaMax'
				SParams.alphaMax = varargin{ 2*iVar + iAdj };
                
			case 'alphaMin'
				SParams.alphaMin = varargin{ 2*iVar + iAdj };
			
			case 'alphaStep'
				SParams.alphaStep = varargin{ 2*iVar + iAdj };
			
			case 'dt'
				SParams.dt = varargin{ 2*iVar + iAdj };
			
			case 'dw'
				SParams.dw = varargin{ 2*iVar + iAdj };
                
            case 'fDisp'
                SParams.fDisp = varargin{ 2*iVar + iAdj };
                
            case 'fnModel'
                SParams.fnModel = varargin{ 2*iVar + iAdj };
                
            case 'fnPost'
                SParams.fnPost = varargin{ 2*iVar + iAdj };
                
            case 'fPost'
                SParams.fPost = varargin{ 2*iVar + iAdj };
                
            case 'fSave'
                SParams.fSave = varargin{ 2*iVar + iAdj };
                
            case 'fSmooth'
                SParams.fSmooth = varargin{ 2*iVar + iAdj };
                
            case 'initVal'
                SParams.initVal = varargin{ 2*iVar + iAdj };
                
            case 'initPreVal'
                SParams.initPreVal = varargin{ 2*iVar + iAdj };
                
            case 'nMaxSteps'
                SParams.nMaxSteps = varargin{ 2*iVar + iAdj };
                
            case 'nReverse'
                SParams.nReverse = varargin{ 2*iVar + iAdj };
                
            case 'nSamp'
                SParams.nSamp = varargin{ 2*iVar + iAdj };
                
            case 'nTrials'
                SParams.nTrials = varargin{ 2*iVar + iAdj };
                
            case 'spanSize'
                SParams.spanSize = varargin{ 2*iVar + iAdj };
                
            case 'spanSm'
                SParams.spanSm = varargin{ 2*iVar + iAdj };
                
            case 'SPModel'
                SParams.SPModel = varargin{ 2*iVar + iAdj };
                
            case 'Steps' 
                SParams.Steps = varargin{ 2*iVar + iAdj };
                
            case 'stepSize'
                SParams.stepSize = varargin{ 2*iVar + iAdj };
                
            case 'strModel'
                SParams.strModel = varargin{ 2*iVar + iAdj };
                
            case 'strSaveDir'
				SParams.strSaveDir = varargin{ 2*iVar + iAdj };
                
            case 'tAlpha'
                SParams.tAlpha = varargin{ 2*iVar + iAdj };
                
			case 'tMax'
				SParams.tMax = varargin{ 2*iVar + iAdj };
			
			case 'xErrMax'
				SParams.xErrMax = varargin{ 2*iVar + iAdj };
                
			otherwise
				if isa( varargin{ 2*iVar + iAdj - 1 }, 'char' )
					warning( sprintf( 'input %d: %s was not a recognized input', 2*iVar + iAdj-1, ...
							varargin{ 2*iVar + iAdj - 1 } ) );
				else
					warnnig( sprintf( 'input %d expected to be a variable name as a string', ...
							varargin{ 2*iVar + iAdj - 1 } ) );
				end 
			
		end 
	end 