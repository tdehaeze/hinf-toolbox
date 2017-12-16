function [] = setPortNumbers(opts_param)
% setParamPortNumber - Automatic Settings of the inputs and outputs numbers
%
% Syntax: setPortNumbers(opts_param)
%
% Inputs:
%    - opts_param - Optionals parameters: structure with the following fields:
%        - simulink_name (default: test) - Name of the Simulink System

%% TODO - Change variable names

%% Default values for opts
opts = struct('simulink_name', 'test');

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

    function [number_io] = setPortNumber(letter, offset, opts_param)
        
        nombre = find_system(opts_param.simulink_name, ...
            'RegExp', 'on', ...
            'Name', sprintf('^%s', letter));
        
        number_io = size(nombre, 1);
        
        for var = (1:number_io)
            for q = (1:number_io)
                nom = get_param(nombre{q}, 'name');
                taille = size(nom,2);
                if taille == 2
                    in_port = nom(2);
                elseif taille == 3
                    in_port = [nom(2) nom(3)];
                end
                num = str2num(in_port);
                if num == var
                    set_param(nombre{q}, 'port', num2str(num+offset));
                end
            end
        end
    end

number_w = setPortNumber('w', 0, opts); % Inputs
number_z = setPortNumber('z', 0, opts); % Outputs
setPortNumber('y', number_z, opts); % Inputs of the controller
setPortNumber('u', number_w, opts); % Output of the controller

end
