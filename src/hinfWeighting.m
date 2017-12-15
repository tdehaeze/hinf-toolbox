function [weight_input, weight_output] = hinfWeighting(weight_plot, lsp, opts_params)
% hinfWeighting - 
%
% Syntax: hinfWeighting(weight_plot, lsp, opts_params)
%
% Inputs:
%    weight_plot  - Figure object for the weighting functions
%    opts_param - Optionals parameters: structure with the following fields:
%        - prev_weight (default: false)         - Set to true if there is some previously computed weighting functions
%        - prev_weight_input                    - Previous weighting functions for the inputs
%        - prev_weight_output                   - Previous weighting functions for the outputs
%        - lsp (default: logspace(-4, 8, 1000)) - Pulsation vector (rad/s)
%
% Outputs:
%    - weight_input  - Computed weighting functions for the inputs
%    - weight_output - Computed weighting functions for the outputs

%% Default values for opts
opts = struct('prev_weight', false, ...
              'lsp', logspace(-4, 8, 1000));

%% Populate opts with input parameters
if exist('opts_param','var')
  for opt = fieldnames(opts_param)'
    opts.(opt{1}) = opts_param.(opt{1});
  end
end

function [] = setParamPortNumber(letter)
     % setParamPortNumber -
     %
     % Syntax: setParamPortNumber(letter)
     %
     % Inputs:
     %    - letter - Letter corresponding to the input or output of the simulink file

    nombre = find_system('test', 'RegExp', 'on', ...
                         'Name', sprintf('^%s', letter));

    siz = size(nombre, 1);

    for var = (1:siz)
        for q = (1:siz)
            nom = get_param(nombre{q}, 'name');
            taille = size(nom,2);
            if taille == 2
                in_port = nom(2);
            end
            if taille == 3
                in_port = [nom(2) nom(3)];
            end
            num = str2num(in_port);
            if(num == var)
                num = num2str(num)  ;
                set_param(nombre{q}, 'port', (num));
            end
        end
    end
end

function [weighting_fct] = getWeightingFunctions(name)
  % getWeightingFunctions - 
  %
  % Syntax: getWeightingFunctions(name)
  %
  % Inputs:
  %    - name - Possible value: 'input' or 'output'
  %
  % Outputs:
  %    - weighting_fct - Computed weighting functions for the input or output

  assert(name == 'input' | name == 'output', ...
         'name should be equal to input or output');

  % name should be input or output
  sys_names = find_system('test', 'RegExp', 'on', ...
                          'Name', sprintf('^%s_weighting', name));

  n = size(sys_names, 1);
  weighing_fct = tf(n, 1);

  % For each system, get the transfer function associated
  for i = 1:n
    num = get_param(sys_names(i), 'Numerator');
    den = get_param(sys_names(i), 'Denominator');
    weighting_fct(i) = tf(eval([num{1}]), eval([den{1}]));
  end
end

function [] = updateWeightingPlot(weight_plot, weight_input, weight_output, opts_param)
  % updateWeightingPlot - 
  %
  % Syntax: updateWeightingPlot(weight_plot, weight_input, weight_output, opts_param)
  %
  % Inputs:
  %    weight_plot - Figure object for the weighting functions
  %    opts_param  - Optionals parameters: structure with the following fields:
  %        - prev_weight (default: false)         - Set to true if there is some previously computed weighting functions
  %        - prev_weight_input                    - Previous weighting functions for the inputs
  %        - prev_weight_output                   - Previous weighting functions for the outputs
  %        - lsp (default: logspace(-4, 8, 1000)) - Pulsation vector (rad/s)

  %% Default values for opts
  opts = struct('prev_weight', false, ...
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
      subplot(weight_output_number, weight_input_number, (output_i-1)*3+(input_i-1));

      % Test if there is any previous weighting functions()
      if (opts.prev_weight)
        if (output_i <= size(prev_weight_output, 2) & input_i <= size(prev_weight_input, 2))
          pond = sigma((prev_weight_output(output_i) * prev_weight_input(input_i)), lsp, 1);
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

%% Automatic Settings of the inputs and outputs
setParamPortNumber('w'); % Inputs
setParamPortNumber('z'); % Outputs
setParamPortNumber('u'); % Output of the controller
setParamPortNumber('y'); % Inputs of the controller

%% Computation of the Weighting Functions
weight_input  = getWeightingFunctions('input');
weight_output = getWeightingFunctions('output');

%% Graphical Display of the Weighting Functions
updateWeightingPlot(weight_plot, weight_input, weight_output, lsp, opts);

end

