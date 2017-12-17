function [] = setPortNumbers(opts_param)
% setParamPortNumber - Automatic settings of the inports and outports numbers on Simulink
%
% Syntax: setPortNumbers(opts_param)
%
% Inputs:
%    - opts_param - Optionals parameters: structure with the following fields:
%        - simulink_name (default: test) - Name of the Simulink System

%% Default values for opts
opts = struct('simulink_name', 'test');

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

    function [largest_port_num] = setPortNumber(letter, offset)
        ports_names = find_system(opts_param.simulink_name, ...
                                  'RegExp', 'on', ...
                                  'Name', sprintf('^%s', letter));

        ports_n = size(ports_names, 1);

        largest_port_num = 0;

        for port_i = 1:ports_n
            port_name = get_param(ports_names{port_i}, 'name');
            port_name_num = str2double(port_name(2:end));
            port_number = num2str(port_name_num + offset);
            set_param(ports_names{port_i}, 'port', port_number);
            if str2double(port_number) > largest_port_num
                largest_port_num = str2double(port_number);
            end
        end
    end

number_w = setPortNumber('w', 0); % Inputs
number_z = setPortNumber('z', 0); % Outputs
setPortNumber('y', number_z); % Inputs of the controller
setPortNumber('u', number_w); % Output of the controller

end
