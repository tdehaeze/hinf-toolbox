function [ss_k, gamma_opt] = hinfSynthesis(opts_param)
% hinfSynthesis -
%
% Syntax: hinfSynthesis(opts_params)
%
% Inputs:
%    - opts_param - Optionals parameters: structure with the following fields:
%        - simulink_name (default: test) - Name of the Simulink System
%
% Outputs:
%    - ss_k - State space representation of the generated controller

%% Default values for opts
opts = struct('simulink_name', 'test');

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

%% Get the state space model of the simulink system
[Ah4, Bh4, Ch4, Dh4] = linmod(opts.simulink_name);
%open_system(opts.simulink_name)

% TODO - Compute siz1 siz2 sizy sizu

%% From the state-space model of the simulink, only use wanted inputs and ouputs
% Inputs: w and u
% Ouputs: z and y
sys_hinf = ss(  Ah4,...
                Bh4(:,             1:(siz1+sizu)),...
                Ch4(1:(siz2+sizy), :),...
                Dh4(1:(siz2+sizy), 1:(siz1+sizu))...
                );

%% Make some numerical conditioning on sys_hinf to improve the accuracy of the H-infinity synthesis
sys_hinf = ssbal(sys_hinf);
sys_hinf = pck(sys_hinf.a, sys_hinf.b, sys_hinf.c, sys_hinf.d);

%% H-Infinity Synthesis using LMI Optimization
p   = sys_hinf;     % Plant
r   = [sizy, sizu]; % System dimension
g   = 0.9;          % Target for the closed loop performance
tol = [0, 0, 0];    % Relative accuracy required on g
[gamma_opt, sys_k] = hinflmi(p, r, g, tol);
% gamma_opt = best H-Infinity performance
% sys_k     = Controller for gamma=gamma_opt

%% Redheffer star-product: connect the plant with the controller
%closed_loop_sys = starp(sys_hinf, sys_k, sizy, sizu);

%% Export the controller as a state-space object
[Ak, Bk, Ck, Dk] = unpck(sys_k);
ss_k = ss(Ak, Bk, Ck, Dk);

end

