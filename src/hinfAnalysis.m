function [] = hinfAnalysis(ss_f_sys, ss_k, opts_param)
% hinfAnalysis -
%
% Syntax: hinfAnalysis(ss_f_sys, ss_k, opts_param)
%
% Inputs:
%    - ss_f_sys   - State space representation of the plant
%    - ss_k       - State space representation of the controller
%    - opts_param - Optionals parameters: structure with the following fields:
%        - simulink_name (default: test)        - Name of the Simulink System
%        - is_ss_k_prev (default: false)        - Is there any previously generated controller
%        - ss_k_prev                            - State space representation of the previously generated controller
%        - lsp (default: logspace(-4, 8, 1000)) - Pulsation vector (rad/s)

%% Default values for opts
opts = struct(  'simulink_name', 'test',...
                'is_ss_k_prev', false, ...
                'ss_k_prev', tf(1), ...
                'lsp', logspace(-4, 8, 1000));

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

%% Compute some size of the system
% Size of the controller
[n_outputs, n_inputs] = size(ss_k);

% Open loop system
ss_ol = ss_f_sys * ss_k;
% TODO - Use series
% ss_ol = series(ss_f_sys, ss_k, [3 4], [1 2])
[n_outputs_ol, n_inputs_ol] = size(ss_ol);

if opts.is_ss_k_prev
    ss_ol_prev = ss_f_sys * opts.ss_k_prev;
end

%% Bode of the controller
if opts.plot_bode_k
    figure(opts.fig_bode_k); clf;
    for i_output = (1:n_outputs)
        for i_input = (1:n_inputs)
            subplot(n_outputs, n_inputs, (i_output-1)*n_inputs+i_input);
            if opts.is_ss_k_prev
                bode(ss_k(i_output, i_input), 'r', opts.ss_k_prev(i_output, i_input), 'b', opts.lsp);
            else
                bode(ss_k(i_output, i_input), 'r', opts.lsp);
            end
            grid on;
            ylabel(['Y', num2str(i_input), ' -> U', num2str(i_output)]);
            xlabel('Frequency w (rad/s)');
            zoom on;
        end
    end
end


%% Open Loop Bode Plot
if opts.plot_bode_ol
    figure(fig_bode_ol); clf;
    for i_output_ol = 1:n_outputs_ol
        for i_input_ol = 1:n_inputs_ol
            subplot(n_outputs_ol, n_inputs_ol, (i_output_ol-1)*n_inputs_ol+i_input_ol);
            if opts.is_ss_k_prev
                bode(ss_ol(i_output_ol, i_input_ol), 'r', ss_ol_prev(i_output_ol, i_input_ol), 'b', opts.lsp);
            else
                bode(ss_ol(i_output_ol, i_input_ol), 'r', opts.lsp);
            end
            grid on;
            ylabel(['Y ' num2str(i_input_ol) ' --> Output ' num2str(i_output_ol)]);
            xlabel('Frequency w (rad/s)');
            zoom on;
        end
    end
end


%% Nichols Plot of the Open Loop system
if opts.plot_nichols
    figure(opts.fig_nichols); clf;
    for i_output_ol = 1:n_outputs_ol
        for i_input_ol = 1:n_inputs_ol
            subplot(n_outputs_ol, n_inputs_ol, (i_output_ol-1)*n_inputs_ol+i_input_ol);
            if opts.is_ss_k_prev
                nichols(ss_ol(i_output_ol, i_input_ol), 'r', ss_ol_prev(i_output_ol, i_input_ol), 'b', opts.lsp);
            else
                nichols(ss_ol(i_output_ol, i_input_ol), 'r', opts.lsp);
            end
            ylabel(['Y ' num2str(i_input_ol) ' --> Output ' num2str(i_output_ol)]);
            ngrid;
            grid on;
            zoom on;
        end
    end
end

end

