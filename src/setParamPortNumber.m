function [] = setParamPortNumber(letter, opts_param)
% setParamPortNumber -
%
% Syntax: setParamPortNumber(letter)
%
% Inputs:
%    - letter     - Letter corresponding to the input or output of the simulink file
%    - opts_param - Optionals parameters: structure with the following fields:
%        - simulink_name (default: test) - Name of the Simulink System

opts = struct('simulink_name', 'test');

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

nombre = find_system(opts.simulink_name, 'RegExp', 'on', ...
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

