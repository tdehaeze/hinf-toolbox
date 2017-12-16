function [weighting_fct] = getWeightingFunctions(name, opts_param)
% getWeightingFunctions - From the simulink model, get the Weighting Functions
%
% Syntax: getWeightingFunctions(name)
%
% Inputs:
%    - name       - Possible value: 'input' or 'output'
%    - opts_param - Optionals parameters: structure with the following fields:
%        - simulink_name (default: test) - Name of the Simulink System
%
% Outputs:
%    - weighting_fct - Computed weighting functions for the input or output

opts = struct('simulink_name', 'test');

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

assert(name == 'input' | name == 'output', ...
    'name should be equal to input or output');

% name should be input or output
sys_names = find_system(opts.simulink_name, 'RegExp', 'on', ...
                        'Name', sprintf('^%s_weighting', name));

n = size(sys_names, 1);
weighting_fct = tf(n, 1);

% For each system, get the transfer function associated
for i = 1:n
    num = get_param(sys_names(i), 'Numerator');
    den = get_param(sys_names(i), 'Denominator');
    weighting_fct(i) = tf(eval([num{1}]), eval([den{1}]));
end
end

