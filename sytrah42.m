%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                     %
% sytrah4: analyser les fonctions de transfert en boucle fermee       %
%          (voir leur trace par rapport au gabarit)                   %
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tracé des 4 fonctions de transfert S, GS, KS et T.

[Atmp, Btmp, Ctmp, Dtmp] = unpck(BF);

ss_BF = ss(Atmp, Btmp, Ctmp, Dtmp);

for k=(1:siz2),
    Matrice1(k,k)=inv(pond_s(k));
end

for h=(1:siz1),
    Matrice2(h,h)=inv(pond_e(h));
end

% Suppression des ponderations des fonctions en BF

if exist('ss_t')
    ss_t_prec = ss_t;
end

ss_t =  minreal(Matrice1(1:siz2,1:siz2)*ss_BF*Matrice2(1:siz1,1:siz1));

% Modification du vecteur de pulsations pour l'affichage

% lsp = fgrid('bode', [], [], [], [], ss_BF);
% lsp = lsp{1}{1};                 % GG modif
% lsp = logspace(0,4,50);

% Affichage graphique des fonctions de sensibilite
figure(PONDERATION);

var=1;
compteur=1;
counter=1;
for counter=(1:siz2),

    for compteur=(1:siz1),

        subplot(siz2,siz1,var);

        if exist('ss_t_prec') %GGmodif
            if ( counter <= size(ss_t_prec,1) & compteur <= size(ss_t_prec,2))
                % tester si les ponderations existaient precedemment)
                sens=(sigma(ss_t_prec(counter,compteur),lsp));
                semilogx(lsp, 20*log10(sens),'b-');
                grid on;
                % axis([lsp(1),lsp(length(lsp)),-60, 60])

            end
        end

        sens=(sigma(ss_t(counter,compteur),lsp));
        semilogx(lsp, 20*log10(sens),'r-');
        % axis([lsp(1),lsp(length(lsp)),-60, 60])
        grid on;
        % xlabel('pulsations w');


        var=var+1;
    end

end



% affichage des fonctions de sensibilité sur les figures additionnelles, si elles exsitent

if N_fig_add,

    for i = 1:N_fig_add,
        eval(['figure(PONDERATION_add_', num2str(i), ')' ]);

        var=1;
        compteur=1;
        counter=1;

        for counter=(i_N_fig_add(i):j_N_fig_add(i)),
            for compteur=(k_N_fig_add(i):l_N_fig_add(i)),
                subplot((j_N_fig_add(i)-i_N_fig_add(i))+2,(l_N_fig_add(i)-k_N_fig_add(i))+1,var);

                % trace du module de la fonction BF precedente

                if exist('ss_t_prec') %GGmodif
                    if ( counter <= size(ss_t_prec,1) & compteur <= size(ss_t_prec,2))
                        % tester si les ponderations existaient precedemment)
                        sens=(sigma(ss_t_prec(counter,compteur),lsp));
                        semilogx(lsp, 20*log10(sens),'b-');
                        %   axis([lsp(1),lsp(length(lsp)),-60, 60])
                        grid on
                    end
                end

                % trace du module de la fonction BF courante

                sens=(sigma(ss_t(counter,compteur),lsp));
                semilogx(lsp, 20*log10(sens),'r-');
                %  axis([lsp(1),lsp(length(lsp)),-60, 60])
                grid on;
                %xlabel('pulsations w');

                var=var+1;
            end
        end


        if exist('ss_t_prec')
            subplot((j_N_fig_add(i)-i_N_fig_add(i))+2, (l_N_fig_add(i)-k_N_fig_add(i))+1, var);
            sens = sigma( ss_t_prec((i_N_fig_add(i):j_N_fig_add(i)),(k_N_fig_add(i):l_N_fig_add(i))), lsp );
            semilogx(lsp, 20*log10(sens(1,:)),'b-', lsp, 20*log10(sens(2,:)),'b-');
            % axis([lsp(1),lsp(length(lsp)),-60, 60]);
            hold on;
            grid on;
        end

        subplot((j_N_fig_add(i)-i_N_fig_add(i))+2,(l_N_fig_add(i)-k_N_fig_add(i))+1,var);
        sens = sigma( ss_t((i_N_fig_add(i):j_N_fig_add(i)),(k_N_fig_add(i):l_N_fig_add(i))), lsp );
        semilogx(lsp, 20*log10(sens(1,:)),'r-', lsp, 20*log10(sens(2,:)),'r-');
        % axis([lsp(1),lsp(length(lsp)),-60, 60]);
        grid on;

    end
end
