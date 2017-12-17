function [weighting_fct] = getWeightingFunctions(name, weight_functions, opts_param)
% getWeightingFunctions - From the simulink model, get the Weighting Functions
%
% Syntax: getWeightingFunctions(name)
%
% Inputs:
%    - name       - Possible value: 'input' or 'output'
%    - opts_param - Optionals parameters: structure with the following fields:
%        - simulink_name (default: hinfModel) - Name of the Simulink System
%
% Outputs:
%    - weighting_fct - Computed weighting functions for the input or output

opts = struct('simulink_name', 'hinfModel');

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

assert(strcmp(name, 'input') | strcmp(name, 'output'), ...
    'name should be equal to input or output');

% name should be input or output
sys_names = find_system(opts.simulink_name, 'RegExp', 'on', ...
                        'Name', sprintf('^%s_weighting', name));

n = size(sys_names, 1);
weighting_fct = tf([n, 1]);

% For each system, get the transfer function associated
for i = 1:n
    block_name = sys_names(i);
    [tf_name, ~] = Simulink.Mask.get(block_name{1}).Parameters.Value;
    input_name = get_param(sys_names(i), 'InputSignalNames');
%     num = get_param(sys_names(i), 'Numerator');
%     tf_name = num{1}(1:end-7);
    weighting_fct(i) = weight_functions.(tf_name);
    weighting_fct(i).InputName = input_name{1}{1};
    weighting_fct.UserData{i} = tf_name;
end

end

