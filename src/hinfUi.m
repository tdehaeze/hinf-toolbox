function [] = hinfUi()
% TODO - add optional parameters
% menu de selection 4 boutons pour le cours H infini
% menuh4 propose un menu et ouvre les fenetres Simulink et de dessin necessaires

% vecteur de frequence utilise pour tracer le bode et le nyquist
lsp = logspace(-4, 8, 1000);

%% creation du menu de selection 4 boutons
figure('Name', 'H infinity',...
       'Color', 'w',...
       'Position', [20, 50, 340, 80]);

uicontrol('Style', 'Pushbutton', 'Position', [10  10  100 60], 'BackGroundColor', [1 0.74 0],     'Callback', 'hinfWeighting',  'String', '1 - Weighting Fct');
uicontrol('Style', 'Pushbutton', 'Position', [120 10  100 60], 'BackGroundColor', [0.9 0.4 0.05], 'Callback', 'hinfSynthesis', 'String', '2 - Synthesis');
uicontrol('Style', 'Pushbutton', 'Position', [230 10  100 60], 'BackGroundColor', [1 0 0],        'Callback', 'hinfAnalysis',  'String', '3 - Analysis');

%% ouvrir les fenetres Simulink
open_system('test');
open_system('sim4');

%% ouvrir les fenetres Matlab de dessin
plot_weighing        = figure('Name', 'Weighting Functions',   'Position', [10, 100, 780, 450]);
plot_bode_controller = figure('Name', 'Bode - Controller',     'Position', [10, 100, 780, 450]);
plot_bode_open_loop  = figure('Name', 'Bode - Open Loop',      'Position', [10, 100, 780, 450]);
plot_nichols         = figure('Name', 'Nichols - Closed loop', 'Position', [10, 100, 780, 450]);
plot_time_simulation = figure('Name', 'Time simulation',       'Position', [10, 100, 780, 450]);

N_fig_add = 0;

end

