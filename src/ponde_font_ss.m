function objss = ponde_font_ss(G0, Ginf, wc, mode)
% Soit un gabarit defini 1/W par son gain statique G0, son gain direct Ginf et sa frequence de coupure
% a 0dB wc.
% W = (Ginf*sqrt(abs(G0^2-1))*s + G0*wc*sqrt(abs(Ginf^2-1))) / (sqrt(abs(G0^2-1))*s + wc*sqrt(abs(Ginf^2-1)))
%
% Entrées :
%   - G0 : gain statique (en dB) du gabarit.
%   - Ginf : gain direct (en dB) du gabarit.
%   - wc : pulsation (en rad/s) de coupure du gabarit sous forme d'objet systeme.
%   - mode = 'dB' si G0 et Ginf sont donnees en dB. 'mode' = 'lin' si G0 et Ginf sont donnees en echelle lineaire.
% Sorties :
%   - objss : représentation d'état de la pondération correspondant au gabarit.

% TODO - ajouter des parametres optionnels avec notemment la pente
%      - Proposer de definir le temps de reponse plutot que la freq de coupure?
%      - Proposer de donner la frequence en Hz ou en Rad/s

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

