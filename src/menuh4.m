% menu de selection 4 boutons pour le cours H infini
% menuh4 propose un menu et ouvre les fenetres Simulink et de dessin necessaires

clear

% vecteur de frequence utilise pour tracer le bode et le nyquist
lsp = logspace(-4, 8, 1000);

% creation du menu de selection 4 boutons
Menu = figure('Name', 'H infini 4 blocs', 'Color','b','Position',[1, 10, 460, 120]); figure(Menu);

Men = uicontrol('Style', 'Pushbutton', 'Position', [10  20  100 100], 'BackGroundColor', 'y', 'Callback', 'sypond42', 'String','Pondérations');
Men = uicontrol('Style', 'Pushbutton', 'Position', [120 20  100 100], 'BackGroundColor', 'r', 'Callback', 'syhinf4', 'String', 'Synthèse');
Men = uicontrol('Style', 'Pushbutton', 'Position', [230 20  100 100], 'BackGroundColor', 'y', 'Callback', 'syana42', 'String', 'Analyse');
%Men = uicontrol('Style', 'Pushbutton', 'Position', [340 20  100 100], 'BackGroundColor', 'g', 'Callback', 'syfig', 'String','Configure');

% ouvrir les fenetres Simulink
open_system('test');
open_system('sim4');
% open_system('librairie');

% ouvrir les fenetres Matlab de dessin
PONDERATION= figure('Name', 'Pondérations','Position',[10, 100, 780, 450]);
BOD= figure('Name', 'Bode du correcteur','Position',[10, 100, 780, 450]);
OUVERTE= figure('Name', 'Bode de la boucle ouverte','Position',[10, 100, 780, 450]);
% NYQ= figure('Name', 'Nyquist du systeme avec correcteur','Position',[10, 100, 780, 450]);
NICH= figure('Name', 'Nichols du système avec correcteur','Position',[10, 100, 780, 450]);
% FIGZPK= figure('Name', 'zpk du système en boucle fermée','Position',[10, 100, 780, 450]);

FIG_SIM = figure('Name', 'Simulation temporelle système BF', 'Position',[10, 100, 780, 450]);

% Nombre de figures supplémentaire initialement

if exist('test_config.mat','file'),
    load test_config.mat;

    for i = 1:N_fig_add,
        eval(['PONDERATION_add_', num2str(i), ' = figure(''Name'', ''Pondérations_', num2str(i), ''',''Position'',[10, 100, 780, 450]);' ]);
    end

else
    N_fig_add = 0;
end
