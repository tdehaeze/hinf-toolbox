function [] = hinfUi(opts_param)

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

%% Create figure with the 3 buttons
figure( 'Name', 'H infinity',...
        'Color', 'w',...
        'Position', [20, 50, 340, 80]);

uicontrol('Style', 'Pushbutton', 'Position', [10  10  100 60], 'BackGroundColor', [1 0.74 0],     'Callback', 'hinfWeighting',  'String', '1 - Weighting Fct');
uicontrol('Style', 'Pushbutton', 'Position', [120 10  100 60], 'BackGroundColor', [0.9 0.4 0.05], 'Callback', 'hinfSynthesis', 'String', '2 - Synthesis');
uicontrol('Style', 'Pushbutton', 'Position', [230 10  100 60], 'BackGroundColor', [1 0 0],        'Callback', 'hinfAnalysis',  'String', '3 - Analysis');

%% Open Simulink systems
open_system(opts.simulink_name);
open_system('sim4');

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

end

