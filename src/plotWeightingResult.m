function [] = plotWeightingResult(fig_weight, ss_sys, ss_k, weight_input, weight_output, opts_param)
% hinfSynthesis -
%
% Syntax: hinfSynthesis(opts_params)
%
% Inputs:
%    - opts_param - Optionals parameters: structure with the following fields:
%

%% Default values for opts
opts = struct('prev_weight', false, ...
              'lsp', logspace(-4, 8, 1000));

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end
            
%% Redheffer star-product: connect the plant with the controller
[n_outputs, n_inputs] = size(ss_k);
closed_loop_sys = lft(ss_sys, ss_k, n_outputs, n_inputs);

weight_input_number  = length(weight_input);
weight_output_number = length(weight_output);

output_weight_mat = tf(zeros(weight_output_number));
for output_i = 1:weight_output_number
    output_weight_mat(output_i,output_i) = inv(weight_output(output_i));
end

intput_weight_mat = tf(zeros(weight_input_number));
for input_i = 1:weight_input_number
    intput_weight_mat(input_i,input_i) = inv(weight_input(input_i));
end

% % Suppression des ponderations des fonctions en BF
% if exist('ss_t')
%     ss_t_prec = ss_t;
% end

ss_t = minreal(output_weight_mat*closed_loop_sys*intput_weight_mat);

%%
figure(fig_weight);

for output_i = (1:weight_output_number)
    for input_i = (1:weight_input_number)
        subplot(weight_output_number, weight_input_number, (output_i-1)*weight_input_number+input_i);

        % TODO
        % if exist('ss_t_prec')
        %     if ( counter <= size(ss_t_prec,1) & compteur <= size(ss_t_prec,2))
        %         % tester si les ponderations existaient precedemment)
        %         sens=(sigma(ss_t_prec(counter,compteur),lsp));
        %         semilogx(lsp, 20*log10(sens),'b-');
        %         grid on;
        %         % axis([lsp(1),lsp(length(lsp)),-60, 60])
        %     end
        % end

        sens = (sigma(ss_t(output_i, input_i), opts.lsp));
        semilogx(opts.lsp, 20*log10(sens), 'r-');
        grid on;
    end
end

end

