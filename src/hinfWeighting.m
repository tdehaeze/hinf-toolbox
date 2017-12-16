function [weight_input, weight_output] = hinfWeighting(weight_plot, weight_functions, opts_param)
% hinfWeighting - Function called when pushing the button Weighting Functions
%
% Syntax: hinfWeighting(weight_plot, lsp, opts_params)
%
% Inputs:
%    - weight_plot - Figure object for the weighting functions
%    - weight_functions -
%    - opts_param  - Optionals parameters: structure with the following fields:
%        - simulink_name (default: test)        - Name of the Simulink System
%        - prev_weight (default: false)         - Set to true if there is some previously computed weighting functions
%        - prev_weight_input                    - Previous weighting functions for the inputs
%        - prev_weight_output                   - Previous weighting functions for the outputs
%        - lsp (default: logspace(-4, 8, 1000)) - Pulsation vector (rad/s)
%
% Outputs:
%    - weight_input  - Computed weighting functions for the inputs
%    - weight_output - Computed weighting functions for the outputs

%% Default values for opts
opts = struct(  'simulink_name', 'test',...
                'prev_weight', false, ...
                'lsp', logspace(-4, 8, 1000));

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

%% Automatic Settings of the inputs and outputs
setParamPortNumber('w'); % Inputs
setParamPortNumber('z'); % Outputs
setParamPortNumber('u'); % Output of the controller
setParamPortNumber('y'); % Inputs of the controller

%% Computation of the Weighting Functions
weight_input  = getWeightingFunctions('input',  weight_functions, opts);
weight_output = getWeightingFunctions('output', weight_functions, opts);

%% Graphical Display of the Weighting Functions
updateWeightingPlot(weight_plot, weight_input, weight_output, opts);

end

