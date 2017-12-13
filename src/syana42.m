% trace des bode nyquist black de la boucle ouverte
% et du bode du correcteur.
% Dans la fenetre Matlab, s'affiche
% les poles et les zeros du correcteur obtenu ainsi que la marge de gain et
% la marge de phase.

% Représentation d'état du correcteur
ss_k  = ss(Ak, Bk, Ck, Dk);
ss_f_sys = ss(f_sys);

% Représentation d'etat de la boucle ouverte
ss_bo = ss_f_sys * ss_k;

if exist('ss_k_prec'),
    if ~isempty(ss_k_prec),
        ss_bo_prec = ss_f_sys * ss_k_prec;
    end
end

% Récupere le nombre d'entrées et de sorties du système en boucle ouverte
[nomb_sortie,nomb_entree]=size(ss_bo);

% Bode du correcteur
var=1;
figure(BOD); clf;
for o=(1:sizu)
    for m=(1:sizy)
        subplot(sizu,sizy,var);
        if exist('ss_k_prec'),
            if ~isempty(ss_k_prec),
                bode(ss_k(o,m),'r', ss_k_prec(o,m),'b', lsp);
            else
                bode(ss_k(o,m), 'r', lsp);
            end
        else
            bode(ss_k(o,m), 'r', lsp);
        end
        grid on;
        ylabel(['Y', num2str(m), '->U', num2str(o)]);
        xlabel('pulsations w');

        var=var+1;
        zoom on
    end
end

%Bode de la boucle ouverte
var=1;
figure(OUVERTE); clf;

for o=(1:nomb_sortie)
    for m=(1:nomb_entree)
        subplot(nomb_sortie,nomb_entree,var);
        if exist('ss_k_prec'),
            if ~isempty(ss_k_prec),
                bode(ss_bo(o,m), 'r', ss_bo_prec(o,m), 'b', lsp);
            else
                bode(ss_bo(o,m), 'r', lsp);
            end
        else
            bode(ss_bo(o,m), 'r', lsp);
        end
        grid on;
        ylabel(['Y' num2str(m) '--> sortie' num2str(o) 'systeme']);
        xlabel('pulsations w');
        var=var+1;
        zoom on
    end
end

if 0
    % Nyquist du système avec correcteur
    var=1;
    figure(NYQ); clf;

    for o=(1:nomb_sortie)
        for m=(1:nomb_entree)
            subplot(nomb_sortie,nomb_entree,var);
            nyquist(ss_bo(o,m), lsp);
            ylabel(['Y' num2str(m) '--> sortie' num2str(o) 'systeme']);
            axis([-5 5 -5 5]); grid on ;
            var=var+1;
            zoom on
        end
    end
end

% Nichols du système avec correcteur
var=1;
figure(NICH); clf;

for o=(1:nomb_sortie)
    for m=(1:nomb_entree)
        subplot(nomb_sortie,nomb_entree,var);
        if exist('ss_k_prec'),
            if ~isempty(ss_k_prec),
                nichols(ss_bo(o,m), 'r', ss_bo_prec(o,m), 'b', lsp);
            else
                nichols(ss_bo(o,m), 'r', lsp);
            end
        else
            nichols(ss_bo(o,m), 'r', lsp);
        end

        ylabel(['Y' num2str(m) '--> sortie' num2str(o) 'systeme']);
        ngrid;
        grid on;
        var=var+1;
        zoom on
        [Gm, Pm, Wcg, Wcp] = margin(ss_bo(o,m));
        fprintf('\n y%d -> sortie système %d :marge de gain de %f dB et de phase de %f degres \n',m,o,20*log10(Gm), Pm);
    end
end


% etude du correcteur K
disp('Fonction de transfert K');
zpk(ss_k)

return

% zpk du système en boucle ferme
var=1;
figure(FIGZPK); clf;

[aa,bb,cc,dd] = unpck(sys_hinf);
sys_zpk=ss(aa,bb,cc,dd);
pzmap(sys_zpk);
sgrid;
grid on;
zoom on



%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation temporelle%
%%%%%%%%%%%%%%%%%%%%%%%%


var=1;
compteur=1;
counter=1;
for counter=(1:siz2),
    for compteur=(1:siz1),
        ss_t(counter,compteur).InputName=['W', num2str(compteur)];
        ss_t(counter,compteur).OutputName=['Z', num2str(counter)];
    end
end
ltiview('step',ss_t);


fprintf('\a Analyse termine \n');
