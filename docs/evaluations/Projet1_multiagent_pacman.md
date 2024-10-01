# Projet 1: Réalisation d'un pac-man multi agent

## Description du projet
Dans ce projet votre défi va consister à implémenter différents agents (de plus en plus intelligents) incarnant pac-man dans sa version classique. La description du projet détaillée est accessible dans [ce module de cours](https://stanford.edu/~cpiech/cs221/homework/prog/pacman/pacman.html) de Standford. 

## Notions théoriques nécessaires
Pour travailler sur ce projet vous aurez besoin de connaître les notions ci dessous. Si nous vous n'avons pas eu encore l'occasion de voir en détail certaines d'entre elles vous pouvez déja commencer à les appréhender en faisant vos propres recherches !

- les notions de graphes et d'arbres
- les algorithmes de recherche du plus court chemin
- les algorithmes [minimax](https://en.wikipedia.org/wiki/Minimax) et sa variation [Expectiminimax](https://en.wikipedia.org/wiki/Expectiminimax) utilisés dans la théorie des jeux et l'IA comme règle de décision.
- l'algorithme [d'élagage alpha-beta](https://fr.wikipedia.org/wiki/%C3%89lagage_alpha-b%C3%AAta) qui vous permettra de réduire le nombre de noeuds évalués lors du parcours de graphe
- la notion de [fonction d'évaluation](https://en.wikipedia.org/wiki/Evaluation_function)
<!-- Citer aussi les cours youtube de Berkley 6 et 7 pour les prochaines iterations https://www.youtube.com/channel/UCB4_W1V-KfwpTLxH9jG1_iA -->

## Environnement nécessaire
Au cours de ce projet vous aurez besoin de programmer votre agent pacman en python 3.

??? warning "Si vous n'avez pas installé python"
    Si vous n'avez pas installé python sur votre machine, référez vous à     la section Pré-requis de ce cours, en installant un **environnement virtuel dédié pour ce projet**. Notez que vous n'aurez pas besoin pour ce projet de packages supplémentaires à python.

### Code du projet

Clonez ce [dépot git](https://github.com/HerySon/course_pacman_project)  pour installer le code python nécessaire au projet:
```zsh
git clone git@github.com:HerySon/course_pacman_project.git
```
Le code contient différents modules permettant d'afficher le labyrinthe, de renvoyer chaque état de la partie, les actions des agents ainsi que leur intelligence artificielle. Vous n'aurez besoin de modifier dans le code que les parties concernant leur IA en implémentant dans le module `multiAgentsSolution` à minima la classe `MinimaxAgent` ainsi que les classes `AlphaBetaAgent` et `ExpectimaxAgent` si elle vous paraissent pertinentes pour modéliser votre agent.

<!--ToDo: ajouter sur le github une description détaillé des différentes parties du code -->

### Implémenter le code de mon agent en python
??? tip "Si vous n'êtes pas familier avec python"
    Si vous n'êtes pas familier avec python, ca n'est pas très grave: les concepts présentés dans le cours ne dépendent pas d'un langage particulier. Vous trouverez de nombreuses ressources en ligne ainsi que dans la section **Ressources additionnelles** de ce cours.  

L'algorithme minimax et ses variantes étant des sujets bien traités, vous trouverez facilement du code sur internet pour vous aider. N'hésitez pas à vous en servir, mais surtout en essayant de bien comprendre et tester le code que vous trouverez : je vous invite en particulier à examiner les valeurs attribuées aux noeuds de votre graphe lors du calcul du minimax !


## ***Vous être maintenant prêt à commencer à programmer vos agents !***