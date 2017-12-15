function [] = hinfSynthesis()

%% Get the state space model of the test simulink system
[Ah4, Bh4, Ch4, Dh4] = linmod('test');
%open_system('test')

%% From the state-space model of the simulink, only use wanted inputs and ouputs
% Inputs: w and u
% Ouputs: z and y
sys_hinf = ss(Ah4, Bh4(:,1:(siz1+sizu)), Ch4(1:(siz2+sizy),:), Dh4(1:(siz2+sizy),1:(siz1+sizu)));

%% Make some numerical conditioning on sys_hinf to improve the accuracy of the H-infinity synthesis
sys_hinf = ssbal(sys_hinf);
sys_hinf = pck(sys_hinf.a, sys_hinf.b, sys_hinf.c, sys_hinf.d);

%% Save the last controller if it exist
if exist('ss_k')
    if ~isempty(ss_k),
        ss_k_prec = ss_k;
    end
end

%% H-Infinity Synthesis using LMI Optimization
p   = sys_hinf;     % Plant
r   = [sizy, sizu]; % System dimension
g   = 0.9;          % Target for the closed loop performance
tol = [0, 0, 0];    % Relative accuracy required on g
[gamma_opt, sys_k] = hinflmi(p, r, g, tol);
% gamma_opt = best H-Infinity performance
% sys_k     = Controller for gamma=gamma_opt

%% Redheffer star-product: connect the plant with the controller
BF = starp(sys_hinf, sys_k, sizy, sizu);

%% Export the controller as a state-space object
clear Ak Bk Ck Dk;
[Ak, Bk, Ck, Dk] = unpck(sys_k);
ss_k = ss(Ak, Bk, Ck, Dk);

end

