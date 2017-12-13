%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Calcul du correcteur   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% On récupére la représentation du schéma simulink
[Ah4, Bh4, Ch4, Dh4] = linmod('test');
open_system('test')
% On selectionne ds la representation d'etat les sorties et entrees que nous avons besoin
% pour construire la matrice P (sorties: z et y, entrees: w et u)

sys_hinf = ss(Ah4, Bh4(:,1:(siz1+sizu)), Ch4(1:(siz2+sizy),:), Dh4(1:(siz2+sizy),1:(siz1+sizu)));

sys_hinf = ssbal(sys_hinf);
sys_hinf = pck(sys_hinf.a, sys_hinf.b, sys_hinf.c, sys_hinf.d);

% S'il existe un correcteur ss_k on le sauvegarde
if exist('ss_k')
    if ~isempty(ss_k),
        ss_k_prec = ss_k;
    end
end

% recherche du correcteur H infini
% on recupere le correcteur K et la valeur final gamma
%[sys_k, BF, gfin] =  hinfsyn(sys_hinf, sizy, sizu, .9, 50, 1e-4);
%[sys_k, BF, gfin] = hinfsyn(sys_hinf,sizy,sizu,'GMIN',0.8,'GMAX',50,'TOLGAM',1e-4,'METHOD','lmi','DISPLAY','on')
%[gfin, sys_k] =  hinfric(sys_hinf, [sizy, sizu], .9, 50, 1e-5);
[gfin, sys_k] = hinflmi(sys_hinf, [sizy, sizu],0.9,1e-5,[0,0,0]);


BF = starp(sys_hinf, sys_k, sizy, sizu);


clear Ak Bk Ck Dk;
[Ak, Bk, Ck, Dk] = unpck(sys_k);
ss_k = ss(Ak, Bk, Ck, Dk);

fprintf('\a Synthese terminee \n');

if ~isempty(sys_k),
    sytrah42;
end
