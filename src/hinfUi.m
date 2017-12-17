function [hinf_api] = hinfUi(weight_fct_param, opts_param)

% TODO - documentation

%% Default values for opts
opts = struct(  'simulink_name', 'test',...
                'ui', true,...
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
if opts.ui
    open_system(opts.simulink_name);
else
    open_system(opts.simulink_name, 'loadonly');
end

%open_system('sim4');

%% Create plots for Analysis
fig_weight = figure('Name', 'Weighting Functions', 'Position', [10, 100, 780, 450]);
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

%% Default Variables that will be shared
prev_weight        = false;            % Is already run weighting plot
prev_weight_input  = tf(1);            % Previous Weighting functions for the inputs
prev_weight_output = tf(1);            % Previous Weighting functions for the outputs
weight_functions   = weight_fct_param; %
ss_f_sys           = ss(tf(1));        %

is_ss_k_prev       = false;            %
ss_k               = ss(tf(1));        %

%% Automatic Settings of the inports and outports numbers
options = struct();
options.simulink_name = opts.simulink_name;
setPortNumbers(options);

%% Create functions callback to be called by the buttons
function [] = btnWeightingCallback(~, ~)
    options = struct('simulink_name',      opts.simulink_name, ...
                     'prev_weight',        prev_weight, ...
                     'prev_weight_input',  prev_weight_input, ...
                     'prev_weight_output', prev_weight_output, ...
                     'lsp',                opts.lsp);
    [prev_weight_input, prev_weight_output] = hinfWeighting(fig_weight, weight_functions, options);
    prev_weight = true;
end

function [] = btnSynthesisCallback(~, ~)
    options = struct('simulink_name', opts.simulink_name);
    [ss_k, ss_f_sys] = hinfSynthesis(options);
    options.prev_weight = is_ss_k_prev;
    options.lsp = opts.lsp;
    plotWeightingResult(fig_weight, ss_f_sys, ss_k, prev_weight_input, prev_weight_output, options)
    is_ss_k_prev = true;
end

function [] = btnAnalysisCallback(~, ~)
    options = opts;
    options.is_ss_k_prev = is_ss_k_prev;
    options.ss_k_prev = ss_k;
    hinfAnalysis(ss_f_sys, ss_k, options);
end

%% Create figure with the 3 buttons
if opts.ui
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
end

%% Create functions to be called outside this main function
function [] = updateWeightingFunctions(weight_fct_param)
    weight_functions = weight_fct_param;
end

function [generated_k] = getGeneratedController()
    generated_k = ss_k;
end


%% Create the API
hinf_api = struct();
hinf_api.updateWeightingFunctions = @updateWeightingFunctions;
hinf_api.displayWeightingFunctions = @btnWeightingCallback;
hinf_api.runSynthesis = @btnSynthesisCallback;
hinf_api.runAnalysis = @btnAnalysisCallback;
hinf_api.getGeneratedController = @getGeneratedController;

end

