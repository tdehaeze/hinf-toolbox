%%
clear;
close all;

%%
menuh4

%% Weighting functions
W1 = tf(ponde_ramp(-120, 6, 2000, 'dB'));
W2 = tf(1e-6);
W3 = tf(1e-6);

%% System to control
a = [-291.1 -6143.5 3600;...
     3564.8 -755.4  4195;...
     -275.8 -2578.7 -639.3];
b = [-4.5424 ; 0 ; 0];
c = [37.4411 47.1767 -59.3637];
d = [0];

f_sys = ss(a, b, c, d);

%%
sisotool(f_sys, ss_k)

