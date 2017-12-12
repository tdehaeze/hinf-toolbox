% utilitaire de rajout de figures Matlab
% pour afficher sur une figure un sous ensemble connecte
% de bode de fonctions de transfert avec leur valeur singulière
% associée

fprintf('ceci permet de selectionner les fonctions de transfert en BF \n de la ligne i à la ligne j et de la colonne k à la colonne l \n afin de tracer sur une fenetre graphique les modules et les valeurs singulières de l''ensemble');

N_fig_add = input('\n Nombre de figure(s) à créer : ');

for i = 1:N_fig_add,
    fprintf('Création de la figure numéro %d\n', i);
    i_N_fig_add(i) = input('numéro de la premiere ligne  : ');
    j_N_fig_add(i) = input('numéro de la derniere ligne  : ');
    k_N_fig_add(i) = input('numéro de la premiere colonne: ');
    l_N_fig_add(i) = input('numéro de la derniere colonne: ');
end

for i = 1:N_fig_add,
    eval(['PONDERATION_add_', num2str(i), ' = figure(''Name'', ''Pondérations_', num2str(i), ''',''Position'',[10, 100, 780, 450]);' ]);

    if (exist('pond_e') & exist('pond_s')),
        var=1;
        compteur=1;
        counter=1;

        for counter=(i_N_fig_add(i):j_N_fig_add(i)),
            for compteur=(k_N_fig_add(i):l_N_fig_add(i)),
                subplot((j_N_fig_add(i)-i_N_fig_add(i))+2,(l_N_fig_add(i)-k_N_fig_add(i))+1,var);

                if (exist('pond_s_prec') & exist('pond_e_prec'))
                    pond=sigma((pond_s_prec(counter)*pond_e_prec(compteur)),lsp,1);
                    semilogx(lsp, 20*log10(pond),'b-.');
                    hold on;
                end

                pond=sigma((pond_s(counter)*pond_e(compteur)),lsp,1);
                semilogx(lsp, 20*log10(pond),'r-.');
                grid on;
                xlabel('pulsations w');
                ylabel(['T_{w_{' num2str(compteur) '}\rightarrow z_{'num2str(counter) '}}']);
                hold on;

                var=var+1;
            end
        end
    end
end

save test_config N_fig_add  i_N_fig_add  j_N_fig_add k_N_fig_add l_N_fig_add;

