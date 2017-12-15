function objss = ponde_ramp(G0, Ginf, wc, mode)
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

tf1 = tf(ponde_font_ss(G0/2, Ginf/2, wc, mode));

objss = tf1*tf1;

