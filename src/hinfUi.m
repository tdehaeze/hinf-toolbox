function [hinf_api] = hinfUi(weight_fct_param, opts_param)

%% Default values for opts
opts = struct(  'simulink_name', 'test',...
                'lsp', logspace(-4, 8, 1000),...
                'plot_bode_k',   true,...
                'plot_bode_ol',  true,...
                'plot_nichols',  true ...
                );

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

%% Open Simulink systems
open_system(opts.simulink_name);
%open_system('sim4');

%% Create plots for Analysis
plot_weighting = figure('Name', 'Weighting Functions', 'Position', [10, 100, 780, 450]);
if opts.plot_bode_k
  fig_bode_k      = figure('Name', 'Bode - Controller', 'Position', [10, 100, 780, 450]);
  opts.fig_bode_k = fig_bode_k;
end
if opts.plot_bode_ol
  fig_bode_ol      = figure('Name', 'Bode - Open Loop', 'Position', [10, 100, 780, 450]);
  opts.fig_bode_ol = fig_bode_ol;
end
if opts.plot_nichols
  fig_nichols      = figure('Name', 'Nichols - Closed loop', 'Position', [10, 100, 780, 450]);
  opts.fig_nichols = fig_nichols;
end

%% Variables
is_ss_k_prev = false;
ss_k = ss(tf(1));
prev_weight = false;
prev_weight_input = tf(1);
prev_weight_output = tf(1);
weight_functions = weight_fct_param;

%% Create functions callback
function [] = btnWeightingCallback(~, ~)
    options = struct('simulink_name',      opts.simulink_name, ...
                     'prev_weight',        prev_weight, ...
                     'prev_weight_input',  prev_weight_input, ...
                     'prev_weight_output', prev_weight_output, ...
                     'lsp',                opts.lsp);
    [prev_weight_input, prev_weight_output] = hinfWeighting(plot_weighting, weight_functions, options);
    prev_weight = true;
end

function [] = btnSynthesisCallback(~, ~)
    options = struct('simulink_name', opts.simulink_name);
    [ss_k, ~] = hinfSynthesis(options);
    is_ss_k_prev = true;
end

function [] = btnAnalysisCallback(~, ~)
    options = struct('simulink_name', opts.simulink_name, ...
                     'is_ss_k_prev',  is_ss_k_prev, ...
                     'ss_k_prev',     ss_k, ...
                     'lsp',           opts.lsp);
    hinfAnalysis(ss_f_sys, ss_k, options);
end

%% Create figure with the 3 buttons
figure( 'Name', 'H infinity',...
        'Color', 'w',...
        'Position', [20, 50, 340, 80]);

uicontrol('Style', 'Pushbutton',  'String', '1 - Weighting Fct', ...
          'Position', [10  10  100 60], 'BackGroundColor', [1 0.74 0], ...
          'Callback', @btnWeightingCallback);
uicontrol('Style', 'Pushbutton', 'String', '2 - Synthesis', ...
          'Position', [120 10  100 60], 'BackGroundColor', [0.9 0.4 0.05], ...
          'Callback', @btnSynthesisCallback);
uicontrol('Style', 'Pushbutton',  'String', '3 - Analysis', ...
          'Position', [230 10  100 60], 'BackGroundColor', [1 0 0], ...
          'Callback', @btnAnalysisCallback);

%% Create functions to be called outside this main function
hinf_api = struct();
function [] = updateWeightingFunctions(weight_fct_param)
    weight_functions = weight_fct_param;
end
hinf_api.updateWeightingFunctions = @updateWeightingFunctions;

end

