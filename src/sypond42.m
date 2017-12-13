%****************************************************
% renumerotation automatique des inport et outport  *
%****************************************************

% Renumérotation des pondérations en entrée

nombre_w=find_system('test','RegExp','on','Name','^w');
sizw=size(nombre_w,1);

for var=(1:sizw)
    for q=(1:sizw)
        nom_w = get_param(nombre_w{q},'name');
        taille_w=size(nom_w,2);
        if taille_w==2
            in_port_w=nom_w(2);
        end
        if taille_w==3
            in_port_w=[nom_w(2) nom_w(3)];
        end
        numw=str2num(in_port_w );
        if( numw==var)
            numw=num2str(numw)  ;
            set_param(nombre_w{q},'port',(numw));
        end
    end
end

% Renumérotation des sorties u du regulateur

nombre_u=find_system('test','RegExp','on','Name','^u');
sizu=size(nombre_u,1);

for var=(1:sizu),
    for q=(1:sizu)
        nom_u = get_param(nombre_u{q},'name');
        taille_u=size(nom_u,2);
        if taille_u==2
            in_port_u=nom_u(2);
        end
        if taille_u==3
            in_port_u=[nom_u(2) nom_u(3)];
        end
        numu=str2num(in_port_u );
        if( numu==var)
            numu=numu+sizw;
            numu=num2str(numu)  ;
            set_param(nombre_u{q},'port',(numu));
        end
    end
end


% Renumérotation des pondérations en sortie

nombre_z=find_system('test','RegExp','on','Name','^z');
sizz=size(nombre_z,1);

for var=(1:sizz),
    for q=(1:sizz)
        nom_z = get_param(nombre_z{q},'name');
        taille_z=size(nom_z,2);
        if taille_z==2
            in_port_z=nom_z(2);
        end
        if taille_z==3
            in_port_z=[nom_z(2) nom_z(3)];
        end
        numz=str2num(in_port_z );
        if( numz==var)
            numz=num2str(numz)  ;
            set_param(nombre_z{q},'port',(numz));
        end
    end
end

% Renumérotation des entrees y du regulateur

nombre_y=find_system('test','RegExp','on','Name','^y');
sizy=size(nombre_y,1);
for var=(1:sizy),
    for q=(1:sizy)
        nom_y = get_param(nombre_y{q},'name');
        taille_y=size(nom_y,2);
        if taille_y==2
            in_port_y=nom_y(2);
        end
        if taille_y==3
            in_port_y=[nom_y(2) nom_y(3)];
        end
        numy=str2num(in_port_y );
        if( numy==var)
            numy=numy+sizz;
            numy=num2str(numy)  ;
            set_param(nombre_y{q},'port',(numy));
        end
    end
end



%*****************************
%   calcul des pondérations  *
%*****************************

% stockage des ponderations precedentes (si elles existent)

if exist('pond_s')
    pond_s_prec = pond_s;
end
if exist('pond_e')
    pond_e_prec = pond_e;
end

% chercher la fonction de transfert du systeme
d=find_system('test','RegExp','on','Name','systeme');
disp([' fonction de transfert du systeme a commander '])
toto = get_param(d,'sys');
f_sys = eval( toto{1} );

% chercher les fonctions de transfert des ponderations en entree
a=find_system('test','RegExp','on','Name','ponderation_entree');
siz1=size(a,1); %nombre de ponderation en entree

for n =(1:siz1)
    num=get_param(a(n),'Numerator');
    den=get_param(a(n),'Denominator');
    disp([' fonction de transfert de la ponderation en entree' num2str(n)]);
    pond_e(n)=tf(eval( [num{1}]) ,eval( [den{1}]) );
    pond_e(n)
end

% chercher les fonctions de transfert des ponderations en sortie
c=find_system('test','RegExp','on','Name','ponderation_sortie');
siz2=size(c,1); %nombre de ponderation en sortie

for n =(1:siz2)
    num=get_param(c(n),'Numerator');
    den=get_param(c(n),'Denominator');
    disp([' fonction de transfert de la ponderation en sortie' num2str(n)]);
    pond_s(n)=tf(eval( [num{1}]) ,eval( [den{1}]) );

    pond_s(n)=tf(eval( [num{1}]) ,eval( [den{1}]) );
    pond_s(n)
end

nbr_u=find_system('test','RegExp','on','Name','^u');
sizu=size(nbr_u,1); %nombre de ponderation en entree

nbr_y=find_system('test','RegExp','on','Name','^y');
sizy=size(nbr_y,1); %nombre de ponderation en entree

%calcul du nombre de fonctions de sensibilite
nbre=siz1*siz2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Affichage graphique des pondérations   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generation des pulsations lsp pour l'affichage

if ~exist('lsp')
    %  lsp = fgrid('bode', [], [], [], [], [pond_e;pond_s]);
    lsp = logspace(0,4,100);
end

% Creation d'une fenetre graphique divisée en 'siz' verticalement qui va etre titré POND
% Le troisième 1 (un) veut dire qu'on ne s'intèresse qu'à la premiere partie, c-à-d celle du haut.

figure(PONDERATION);
clf;

var=1;
compteur=1;
counter=1;


for counter=(1:siz2),
    for compteur=(1:siz1),
        subplot(siz2,siz1,var);

        if (exist('pond_s_prec') & exist('pond_e_prec')) %GGmodif
            if (counter <= size(pond_s_prec,2) & compteur <= size(pond_e_prec,2))
                % tester si ces ponderations existaient precedemment)
                pond=sigma((pond_s_prec(counter)*pond_e_prec(compteur)),lsp,1);
                semilogx(lsp, 20*log10(pond),'b-.');
                grid on;
                %axis([lsp(1),lsp(length(lsp)),-60, 60]);
                hold on;
            end
        end

        pond=sigma((pond_s(counter)*pond_e(compteur)),lsp,1);
        semilogx(lsp, 20*log10(pond),'r-.');
        %axis([lsp(1),lsp(length(lsp)),-60, 60]);
        grid on;
        %xlabel('pulsations w');
        xlabel([num2str(compteur), '->', num2str(counter)]);
        hold on;



        %  subplot(siz2,siz1,var);
        var=var+1;
    end
end


% affichage des gabarits sur les figures additionnelles, si elles exsitent

if N_fig_add,

    for i = 1:N_fig_add,
        eval(['figure(PONDERATION_add_', num2str(i), ')' ]);
        clf;

        if (exist('pond_e') & exist('pond_s')),
            var=1;
            compteur=1;
            counter=1;

            for counter=(i_N_fig_add(i):j_N_fig_add(i)),
                for compteur=(k_N_fig_add(i):l_N_fig_add(i)),
                    subplot((j_N_fig_add(i)-i_N_fig_add(i))+2,(l_N_fig_add(i)-k_N_fig_add(i))+1,var);

                    if (exist('pond_s_prec') & exist('pond_e_prec'))
                        %GGmodif
                        if (counter <= size(pond_s_prec,2) & compteur <= size(pond_e_prec,2))
                            % tester si les ponderations existaient precedemment)

                            pond=sigma((pond_s_prec(counter)*pond_e_prec(compteur)),lsp,1);
                            semilogx(lsp, 20*log10(pond),'b-.');
                            %axis([lsp(1),lsp(length(lsp)),-60, 60])
                            hold on;
                        end
                    end

                    pond=sigma((pond_s(counter)*pond_e(compteur)),lsp,1);
                    semilogx(lsp, 20*log10(pond),'r-.');
                    %axis([lsp(1),lsp(length(lsp)),-20, 60])
                    grid on;
                    % xlabel('pulsations w');
                    xlabel([num2str(compteur), '->', num2str(counter)]);
                    hold on;

                    var=var+1;
                end
            end
        end
    end
end

fprintf('\a Ponderations terminees \n');
