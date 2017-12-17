function [] = updateWeightingPlot(fig_weight, weight_input, weight_output, opts_param)
% updateWeightingPlot - Update the Weighting Plots
%
% Syntax: updateWeightingPlot(fig_weight, weight_input, weight_output, opts_param)
%
% Inputs:
%    - fig_weight - Figure object for the weighting functions
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

figure(fig_weight);
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
                pond = sigma((opts.prev_weight_output(output_i) * opts.prev_weight_input(input_i)), opts.lsp, 1);
                semilogx(opts.lsp, 20*log10(pond), 'b-.');
                grid on;
                hold on;
            end
        end

        % Plot new weighting functions
        pond = sigma((weight_output(output_i)*weight_input(input_i)), opts.lsp, 1);
        semilogx(opts.lsp, 20*log10(pond), 'r-.');
        grid on;
        title(sprintf('%s(%s) -> %s(%s) - %s %s', ...
            weight_input(input_i).InputName{1}, ...
            num2str(input_i), ...
            weight_output(output_i).InputName{1}, ...
            num2str(output_i), ...
            weight_input.UserData{input_i}, ...
            weight_output.UserData{output_i} ...
            ));
        hold on;
    end
end

end

