Il y a 4 dossiers :  - Puissance 4 (contient le code pour le puissance 4)
			   - Tic Tac Toe (contient le code pour le Tic Tac Toe)
			   - Resultats Alpha Beta (contient les resultats pour le Puissance 4 et le Tic Tac Toe lorsque le
				graphe des solutions est donné par l'alpha beta)
			   - Resultats Minimax (contient les resultats pour le Puissance 4 et le Tic Tac Toe lorsque le
				graphe des solutions est donné par le Minimax)


Pour lancer le puissance 4, il faut lancer le fichier Puissance4Display.py qui lancera une partie dans laquelle
l'ordinateur jouera contre lui-même.

Le dossier contient les fichiers : - games.py qui contient les algorithmes Minimax et Alpha-Beta qui renvoient 
						 le graphe des solutions.

					     - P4Representation.py qui contient la représentation d'un état du Puissance 4

					     - utils.py qui contient des petites fonctions utilisées par games.py

					     - MyAIPlayer.py qui contient toutes les fonctions pour trouver les 
						 successeurs, les valeurs d'utilités, ...Il contient également
						 la fonction getAction() qui implémente l'algorithme Rminimax.

					     - resultP4.txt et resultP4Cop.txt contiendront les resultats des parties


Pour lancer le Tic Tac Toe, il faut lancer le fichier TicTacToeDisplay.py qui lancera une partie dans laquelle
l'ordinateur jouera contre lui-même.

Le dossier contient les fichiers : - games.py qui contient les algorithmes Minimax et Alpha-Beta qui renvoient 
						 le graphe des solutions.

					     - TicTacToeRepresentation.py qui contient la représentation d'un état du
						 Tic Tac Toe

					     - utils.py qui contient des petites fonctions utilisées par games.py

					     - MyAIPlayer.py qui contient toutes les fonctions pour trouver les 
						 successeurs, les valeurs d'utilités, ...Il contient également
						 la fonction getAction() qui implémente l'algorithme Rminimax.

					     - resultTicTacToe.txt et resultTicTacToeCop.txt contiendront 
						 les resultats des parties