function [] = updateWeightingPlot(weight_plot, weight_input, weight_output, opts_param)
% updateWeightingPlot - Update the Weighting Plots
%
% Syntax: updateWeightingPlot(weight_plot, weight_input, weight_output, opts_param)
%
% Inputs:
%    - weight_plot - Figure object for the weighting functions
%    - opts_param  - Optionals parameters: structure with the following fields:
%        - prev_weight (default: false)         - Set to true if there is some previously computed weighting functions
%        - prev_weight_input                    - Previous weighting functions for the inputs
%        - prev_weight_output                   - Previous weighting functions for the outputs
%        - lsp (default: logspace(-4, 8, 1000)) - Pulsation vector (rad/s)

%% Default values for opts
opts = struct(  'prev_weight', false, ...
                'lsp', logspace(-4, 8, 1000));

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

figure(weight_plot);
clf;

weight_input_number  = length(weight_input);
weight_output_number = length(weight_output);

for output_i = (1:weight_output_number)
    for input_i = (1:weight_input_number)
        % Get the subplot with the good index
        subplot(weight_output_number, weight_input_number, (output_i-1)*weight_input_number+input_i);
        
        % Test if there is any previous weighting functions()
        if (opts.prev_weight)
            if (output_i <= size(opts.prev_weight_output, 2) & input_i <= size(opts.prev_weight_input, 2))
                pond = sigma((opts.prev_weight_output(output_i) * opts.prev_weight_input(input_i)), lsp, 1);
                semilogx(lsp, 20*log10(pond), 'b-.');
                grid on;
                hold on;
            end
        end
        
        % Plot new weighting functions
        pond = sigma((weight_output(output_i)*weight_input(input_i)), lsp, 1);
        semilogx(lsp, 20*log10(pond), 'r-.');
        grid on;
        xlabel([num2str(input_i), '->', num2str(output_i)]);
        hold on;
    end
end

end

