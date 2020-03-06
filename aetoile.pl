%*******************************************************************************
%                                    AETOILE
%*******************************************************************************

/*
Rappels sur l'algorithme
 
- structures de donnees principales = 2 ensembles : P (etat pendants) et Q (etats clos)
- P est dedouble en 2 arbres binaires de recherche equilibres (AVL) : Pf et Pu
 
   Pf est l'ensemble des etats pendants (pending states), ordonnes selon
   f croissante (h croissante en cas d'egalite de f). Il permet de trouver
   rapidement le prochain etat a developper (celui qui a f(U) minimum).
   
   Pu est le meme ensemble mais ordonne lexicographiquement (selon la donnee de
   l'etat). Il permet de retrouver facilement n'importe quel etat pendant

   On gere les 2 ensembles de fa�on synchronisee : chaque fois qu'on modifie
   (ajout ou retrait d'un etat dans Pf) on fait la meme chose dans Pu.

   Q est l'ensemble des etats deja developpes. Comme Pu, il permet de retrouver
   facilement un etat par la donnee de sa situation.
   Q est modelise par un seul arbre binaire de recherche equilibre.

Predicat principal de l'algorithme :

   aetoile(Pf,Pu,Q)

   - reussit si Pf est vide ou bien contient un etat minimum terminal
   - sinon on prend un etat minimum U, on genere chaque successeur S et les valeurs g(S) et h(S)
	 et pour chacun
		si S appartient a Q, on l'oublie
		si S appartient a Ps (etat deja rencontre), on compare
			g(S)+h(S) avec la valeur deja calculee pour f(S)
			si g(S)+h(S) < f(S) on reclasse S dans Pf avec les nouvelles valeurs
				g et f 
			sinon on ne touche pas a Pf
		si S est entierement nouveau on l'insere dans Pf et dans Ps
	- appelle recursivement etoile avec les nouvelles valeurs NewPF, NewPs, NewQs

*/

:- ['avl.pl'].       % predicats pour gerer des arbres bin. de recherche   
:- ['taquin.pl'].    % predicats definissant le systeme a etudier

%*******************************************************************************

main :-

    initial_state(S0),
    
    heuristique1(S0,F0),
    heuristique1(S0,H0),
    G0 is 0,
    
    empty(Pf),
    empty(Pu),
    empty(Q),
    
    insert([ [F0,H0,G0], S0 ] , Pf, Pfa),
    insert([S0, [F0,H0,G0], nil, nil], Pu, Pua),
    
    aetoile(Pfa, Pua, Q).



%*******************************************************************************
affiche_solution(F) :- write_state(F).

%simule les 4 regles de deplacement (right,up,down,left)
%pour trouver les combinaisons voisines (renvoi les possibilités)

%On doit appeler ca sur la combinaison avec le pf minimum


%%%LOOP SUCCESSORS _____
%CAS 1 : si une combinaison n'est pas dans pu ou pf, on l'ajoute 
% (par exemple la combinaison "right") : simple

%CAS 2 : si elle est deja dans pu/pf, on verifie les F,G et H de celle ci
%si le F est plus petit que le F qui était deja prévu, on enleve l'ancien F,
% et on ajoute le nouveau 

%CAS 3 :si la case appartient a QU (deja traité), je fais rien : simple
%_____________

%on appel le loopsuccessors sur le retour du expand (les 4 possibilités).

%On recupere le Pf minimal grace a ca, on trouve dnc un etat suivant, 
% et on rappel le expand sur celui la

% Qu = elements traité par le loop successors
% On a Pu et Pf pour le suppressmin
% Pu pour avoir F,H,G
% Pf pour recuperer celui avec le f min
% Pu recherche par etat au lieu de rechercher par f
% expand --> 
%       utiliser findall([U,[F,H,G],pere,A], (rule(Pere,1,U,A)), ListSuccessors)
% on peut ensuite appeler loopsuccessors avec le resultat ListSuccessors
% 
% conseil de commence par :
% expand, facile a tester, on donne un etat on calcul les suivants
% TESTER LE EXPAND AVANT DE PASSER AU LOOPSUCCESSORS

% ensuite
% le corps principal de A*, quand pf et pu sont vides, pas de solution,
% et le cas ou Pf min est l'etat final, c'est la solution, 
% 

expand().

loop_successors().

aetoile(Pf, Ps, _) :- empty(Pf),
    empty(Ps),
    writeln("PAS DE SOLUTION!").


atoile(Pf,_,_) :- suppress_min(F,Pf,_), final_state(F),
	affiche_solution(F).
	
atoile(Pf,_,_) :- 
    suppress_min(U,Pf,_),
    writeln(U).
