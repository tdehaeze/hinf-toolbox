/* Copyright G. Scorletti et E. Magarotto 2002

INTRODUCTION

L'ensemble des fichiers contenus dans ce r?pertoire (Projet_CAO_2001) 
forment un utilitaire de conception assist?e par ordinateur pour la 
synth?se de r?gulateur sous l'environnement Simulink de Matlab. 
L'utilitaire permet ? l'utilisateur de trouver une loi de commande 
pour un syst?me quelconque utilisant comme crit?re de synth?se un 
cahier des charges particulier. Ce crit?re de synth?se est entr? 
dans l'utilitaire sous forme de pond?rations traduites math?matiquement 
? partir du cahier des charges. Ce dernier point, met en ?vidence 
la limitation de l'assistance de la part du logiciel en concevant 
le r?gulateur,.


LES FICHIERS

L'utilitaire est constitu? de 4 fichiers  principaux, un fichier 
charg? de lancer le logiciel, et un fichier (instructions.m) 
mis en place pour l'affichage d'une fen?tre de texte d?s 
le premier lancement. Tous ces fichiers sont du type Matlab 
files et ont comme extension .m. Comme le fichier intructions.m 
n'est d'aucune importance au niveau du fonctionnement 
informatique de l'utilitaire, il ne sera pas plus d?taill?. 
Voici une bref explication des fichiers principaux en ordre 
d?termin? par l'ex?cution correct du logiciel.

menuh4: Fichier contenant le programme ex?cut? pour le 
lancement de l'utilitaire. 

Le programme sert ? ouvrir une librairie de blocs 
Simulink particuli?re ? la construction du sch?ma 
en question, la fen?tre texte mentionn?e pr?c?demment, 
un fichier Simulink vide dans lequel sera cr?? 
le sch?ma bloc, et finalement une fen?tre de boutons 
accessible par la souris (interface graphique). 
Cette derni?re fen?tre permet ? l'utilisateur d'acc?der 
aux autres modules de l'utilitaire facilement et 
s?quentiellement en cliquant sur les boutons. 
Les quatre boutons correspondent chacun au lancement 
d'un des 4 fichiers principaux. 

Voici les relations:
Bouton Pond--> Fichier sypond42.m
Bouton Synth?se--> Fichier syhinf4.m
Bouton Analyse--> Fichier syana.42


spond42.m: Fichier qui s'occupe essentiellement d'extraire les donn?es contenus dans le sch?ma bloc construit par l'utilisateur. 

Dans un premier temps, une renum?rotation des blocs est effectu?e en cas ou l'utilisateur ne fait pas attention en modifiant les param?tres/?tiquettes des blocs utilis?s. Bien que ceci est n?cessaire pour le bon fonctionnement du logiciel, d'autres fautes de param?trisation qui peuvent ?tre commis de la part de l'utilisateur ne sont pas corrigeable, et donc voici la motivation pour l'inclusion du fichier instructions.m qui donne les consignes de construction du sch?ma bloc. Le reste de ce fichier consiste ? trouver les fonctions de transferts du syst?me et des pond?rations en entr?e ou en sortie, qui serviront comme param?tres d'entr?es dans la synth?se algorithmique du correcteur. Le fichier se termine par l'affichage graphique fr?quentielle de l'inverse des modules de pond?rations.

syhinf4: Ce fichier est le plus complexe de l'ensemble et le plus intensive algorithmiquement.

La fonction "linmod" est utilis?e pour obtenir une repr?sentation d'?tat du sch?ma bloc, et en utilisant certaines lignes et colonnes des matrices de cette d?composition d'?tat, le probl?me est mis sous forme standard en construisant la Matrice P. Cette matrice est produit en concat?nant certaines lignes et colonnes des matrices d'?tat en utilisant la fonction pck. Cette matrice P est pass?e comme param?tre d'entr?e de la fonction "hinfsyn" qui calcule algorithmiquement le correcteur que l'on recherche, ? condition que le syst?me soit commandable.

syana4.m: Fichier utilis? pour l'analyse du correcteur propos?, afin d'en d?duire sa forme. Ceci est fait par les affichages graphiques suivants:

Bode du correcteur
Bode de la boucle ouverte
Nyquist du syst?me avec le correcteur
Nychols du syst?me avec correcteur.
Zmap du syst?me en boucle ferm?.



EXECUTION DU SOFT

Comme l'utilitaire nous fournit avec une fen?tre de boutons accessibles avec la souris, la bonne ex?cution du soft n'exige qu'un certain respect de certaines r?gles en construisant le sch?ma bloc (introduction.m). Il faut soulign? que l'utilitaire peut ?tre ex?cut? m?me si certaines r?gles ne sont pas respect?, mais les r?sultats obtenus pourraient ?tre mauvais. Pour r?sum?, l'ex?cution du soft se fait de la mani?re suivante:

1. Lancement du fichier menuh4 dans la commande Matlab.
2. Construction du sch?ma bloc tout en respectant les r?gles mentionn?es.
3 Cliquer sur chaques boutons dans l'ordre suivant (en se laissant une intervalle entre chaque    
   boutons permettant d'admirer les r?sultats, bien ?videmment!)
   pond -> synth?se -> crit?re -> analyse


BUGS ET AMELIORATIONS POSSIBLES

Le plus grand probl?me avec ce logiciel est le fait que l'utilisateur doit adh?rer ? certaines r?gles quant ? la construction de son sch?ma bloc et les ?tiquettes donn?es aux blocs pour assurer le bon fonctionnement. Une piste que l'on pourrait recommander pour trouver une solution viable est de trouver un moyen de d?terminer ? quoi ou ? quel(s) bloc(s) sont connect?s chaques blocs du sch?ma. Ceci est une question que l'on pourrait poser au Mathworks Inc.  
             
NOTATIONS A RESPECTER
Les blocs de ponderation en entr?e devront ?tre nomm?s: ponderation_entree1, 2, ...
Les blocs de ponderation en sortie devront ?tre nomm?s: ponderation_sortie1, 2, ...
Le bloc du syst?me a commander sera nomm?: systeme
Les entr?es de pond?rations (in ports) seront nomm?es: w1, w2, ...
Les sorties de pond?rations (out ports) seront nomm?es: z1, z2, ...
Les entr?es du correcteur (in ports) seront nomm?es: y1, y2, ...
Les sorties du correcteur (out ports) seront nomm?es: u1, u2, ...

Les ?tiquettes des blocs de pond?rations et entr?es, sorties devront ?tre num?rot?es chronologiquement
Chaque entr?e w et sortie z doit ?tre associ?e ? un bloc de pond?ration et le num?ro contenu dans l'?tiquette du bloc de pond?ration doit correspondre au num?ro contenu dans l'etiquette de l'entr?e ou de la sortie de pond?ration

  
