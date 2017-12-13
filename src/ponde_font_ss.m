function objss = ponde_font_ss(G0, Ginf, wc, mode)
% function objss = ponde_font(G0, Ginf, wc, mode)
%
% Soit un gabarit defini 1/W par son gain statique G0, son gain direct Ginf et sa frequence de coupure
% a 0dB wc. Cree la concatenation des matrices de la representation d'etat de la ponderation
% correspondante W = (Ginf*sqrt(abs(G0^2-1))*s + G0*wc*sqrt(abs(Ginf^2-1))) / (sqrt(abs(G0^2-1))*s + wc*sqrt(abs(Ginf^2-1)))
% (voir Font 95).
%
% ATTENTION : ca marche pas des masses avec 0dB comme gain statique.
% Donne la représentation d'état de la pondération en fonction des
% paramètres du gabarit.
%
% Entrées :
%   - G0 : gain statique (en dB) du gabarit.
%   - Ginf : gain direct (en dB) du gabarit.
%   - wc : pulsation (en rad/s) de coupure du gabarit sous forme d'objet systeme.
%   - mode = 'dB' si G0 et Ginf sont donnees en dB. 'mode' = 'lin' si G0 et Ginf sont donnees en echelle lineaire.
%   - varargin = val_theta : [theta_min, theta_max, pas].
% Sorties :
%   - objss : représentation d'état de la pondération correspondant au gabarit.
%
% Seules les matrices A et C de la representation d'etat dependent du parametre. On peut faire en sorte
% que ce soient les matrices A et B qui dependent du parametre.


if isempty(wc)
    objss = Ginf;
else
    if strcmp(mode,'dB')
        G0 = 1/(10^(G0/20));
        Ginf = 1/(10^(Ginf/20));
    elseif strcmp(mode,'lin')
    else
        error('mode est mal definie');
    end

    poub = sqrt(abs(Ginf^2-1)/abs(G0^2-1));
    mat = [[-poub ; G0-Ginf]*wc [0 ; 0]] + [0 poub ; 0 Ginf];
    objss = ss(mat(1,1), mat(1,2), mat(2,1), mat(2,2));
end
