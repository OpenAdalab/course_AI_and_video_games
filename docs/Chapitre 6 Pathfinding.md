# Chapitre 6 : Pathfinding (déterminer une trajectoire)

## Rappels

### Graphes

Un graphe est une structure mathématique constituée de deux éléments :

* les nœuds (ou sommets)
* les connexions (ou arêtes), chacune associée à une paire de sommets

Dans le cas du pathfinding qui nous intéresse, chaque nœud sera associé à un lieu où se déplacer, et les connexions comment ces lieux sont reliés. 

Un déplacement peut être direct entre deux lieux (nœuds), et n’emprunter qu’une connexion, ou nécessiter d’emprunter plusieurs connexions (trajets indirects). 

### Graphes pondérés

On peut associer une valeur à chaque connexion, ce que l’on appelle un _poids_. Dans le contexte du pathfinding, ces poids représentent souvent la difficulté ou le _coût_ du déplacement (la distance, ou le temps qu’il prend, ou encore l’énergie, la consommation de carburant par exemple). Rien n’interdit d’avoir des poids négatifs, mais si cela peut avoir un sens mathématiquement dans certains problèmes, ce n’est pas le cas du pathfinding. D’autant que les algorithmes qui gèrent ce genre de situation sont plus compliqués à mettre au point, et ceux qu’on utilise couramment dans les jeux vidéo partent  dans la plupart des cas dans des boucles infinies s’il y a des poids négatifs (car il n’y a pas de solution). Les poids seront donc toujours positifs.

On peut calculer le coût total d’un déplacement à travers un graphe en ajoutant les coûts.

### Graphes orientés

Jusqu’à présent nous n’avons pas spécifié qu’il y avait un sens dans les connexions, nous avons implicitement admis qu’une même connexion conduisait de A à B et de B à A : elle est bidirectionnelle. On peut définir des graphes où les connexions sont orientées : s’il y a une connexion de A vers B, elle ne permet pas d’aller de B à A, il faudrait pour cela qu’existe une seconde connexion qui elle va de B vers A. 

On peut imaginer des situations de jeu où cela fait sens : s’il y a une différence de hauteur raisonnable entre A et B, le personnage pourrait glisser ou chuter de A vers B, mais n’aurait pas forcément la capacité de remonter (trop pour l’atteindre en sautant par exemple, ou le mur n’offre pas de prise d’escalade). Par ailleurs remonter de B vers A peut être possible, mais le coût est très différent : il est facile, rapide et peu coûteux en énergie de se laisser glisser de A vers B, mais il est plus compliqué, long et coûteux en énergie de remonter.

### Implémentation

Par exemple : 

* Une classe graphe qui retourne une liste (array) de connexions (objets) liées à un nœud passé en argument
* Une classe connexion qui contient 2 attributs : le nœud vers lequel va cette connexion et le nœud depuis lequel cette connexion provient et enfin une méthode qui renvoie le coût ou poids de cette connexion

On remarque qu’on passe les nœuds sous silence (pas d’interface). Dans la plupart des cas, on leur affecte juste un entier pour les identifier (on leur donne juste un numéro). Pour éviter la confusion avec les poids nous leur attribuerons des lettres dans nos exemples.

## Algorithme de Dijkstra ou algorithme du plus court chemin (1959)

Note : en néerlandais « dij » se prononce « dèï » et non « dij » à la française. « ij » est une diphtongue : « j » se prononce « y » ou « ï » (comme en allemand), et le « i » qui précède un « j » devient un « è ». 

Cet algorithme a été créé pour résoudre un problème en théorie des graphes, « trouver le plus court chemin vers n’importe quel autre point depuis un nœud en particulier », que l’on va lister. Si notre problème dans un jeu est de trouver le plus court chemin entre un point de départ et un point d’arrivée, alors la solution que nous recherchons est de fait incluse dans la solution « du plus court chemin » (en général). C’est absolument idiot et inefficace de procéder ainsi dans le cadre d’un jeu, mais comprendre cet algorithme permet de comprendre **A*** qui est bien plus efficace.

![Graphe pondéré](/media/jean/T7 Shield/Formation/course_AI_and_video_games/docs/pix/Graphe_pondéré.png)

 

Notre objectif est pour chaque nœud de lister les plus courts chemins vers tous les autres nœuds. Par exemple, considérant A, déterminer le plus court chemin entre A et B, entre A et C, entre A et D et entre A et E. Puis, considérant B, déterminer le plus court chemin entre B et A, entre B et C, entre B et D, etc.

Pour cela nous allons déclarer deux listes : la liste des nœuds visités (vous pourrez trouver dans la littérature le terme « closed », en opposition avec une liste « open » qui concerne les nœuds évalués lors du traitement d’autres nœud, nous n’utiliserons pas une telle liste ici), et la liste des nœuds qui n’ont pas encore été visités (non-visités). Au départ, la liste des nœuds visités est vide, et celle des nœuds non visités contient tous les nœuds :

```
lst_visités = []
lst_non-visités = [A, B, C, D, E]
```

Nous déclarerons également une table qui contiendra pour chaque nœud la distance la plus courte entre ce nœud et le nœud « d’origine » considéré à cet instant. D’un point de vue mathématique les distances sont initialisées à « infini », car on n’inscrit dans la table qu’une valeur si celle-ci est inférieure à la valeur déjà présente dans la table. En pratique on initialisera avec la valeur `null`

| Nœud | Distance la plus courte |
| ---- | ----------------------- |
| A    | « infini »              |
| B    | « infini »              |
| C    | « infini »              |
| D    | « infini »              |
| E    | « infini »              |

L’idée va être de se positionner sur chaque nœud, et de là, parcourir toutes les connexions vers ses voisins (et ainsi de suite), calculer le poids du chemin parcouru et abandonner les chemins les plus longs : par comparaison et abandons successifs, on ne retiendra au final que les chemins les plus courts.

Pour cela quelques règles :

* on ne pourra pas repasser par un nœud déjà visité (cela voudrait dire que le chemin boucle ce qui d’office signifierait qu’on n’est pas sur le chemin le plus court)
* corollaire : une fois qu’un nœud a été visité, il ne pourra plus être parcouru depuis le nœud courant – comme s’il n’était plus considéré comme connecté – (cela reviendrait à repartir en arrière, et donc à rallonger le chemin)

#### Itération 1

#### Étape 1 : point de départ

On choisit un nœud non-visité. Admettons que nous démarrons de A : on va chercher les chemins les plus courtes entre A et tous les autres points. 

Quelle est la distance entre A et A ? 0.  Mettons à jour la table des plus courtes distances :

| Nœud | Distance la plus courte |
| ---- | ----------------------- |
| A    | 0                       |
| B    | « infini »              |
| C    | « infini »              |
| D    | « infini »              |
| E    | « infini »              |

#### Étape 2 : distance des voisins

Quels sont les nœuds non-visités qui sont voisins de A ? B et D.

Quelle est la distance entre A et B ? 0 + 3 = 3

Entre A et D ? 0 + 1 = 1

#### Étape 3 : mise à jour de la table

| Nœud | Distance la plus courte |
| ---- | ----------------------- |
| A    | 0                       |
| B    | 3                       |
| C    | « infini »              |
| D    | 1                       |
| E    | « infini »              |

#### Étape 4 : mise à jour des listes

Nous avons visité le premier nœud (A) :

```lst_visité
lst_visités = [A]
lst_non-visités = [B, C, D, E]
```

#### Itération 2

#### Étape 1 : point de départ

À cette étape nous devons choisir un nœud non visité dans la liste des non-visités. Lequel ? Nous choisirons celui qui a la distance la plus courte. C’est D avec comme distance 1.

![Graphe pondéré A visité D nœud courant](/media/jean/T7 Shield/Formation/course_AI_and_video_games/docs/pix/Graphe pondéré_2A-D.png)



#### Étape 2 : distance des voisins

Quels sont les nœuds qui sont voisins de D ? A, B et E. Mais A a été visité, il n’est donc plus réputé connecté à D.

Quelle est la distance entre D et B ? 1 + 1 = 2 (rappel : D a la distance 1)

Entre D et E ? 1 + 6 = 7

#### Étape 3 : mise à jour de la table

La distance à B en passant par D (=2) est inférieure à la distance entre A et B directement (=3). On peut donc mettre à jour la distance B, et par la même occasion on a donc trouvé la distance la plus courte entre A et B.

| Nœud | Distance la plus courte |
| ---- | ----------------------- |
| A    | 0                       |
| B    | 2                       |
| C    | « infini »              |
| D    | 1                       |
| E    | 7                       |

#### Étape 4 : mise à jour des listes

Nous avons visité le nœud D :

```lst_visité
lst_visités = [A, D]
lst_non-visités = [B, C, E]
```

#### Itération 3

#### Étape 1 : point de départ

Ici c’est B le nœud non-visité qui a la distance la plus courte. Ce sera notre point de départ.

![Graphe pondéré A et D visités, B nœud courant](/media/jean/T7 Shield/Formation/course_AI_and_video_games/docs/pix/Graphe pondéré_3AD-B.png)



#### Étape 2 : distance des voisins

Quels sont les nœuds qui sont voisins de B ? A, C, D et E. Le nœuds non-visités sont C et E.

Quelle est la distance entre B et C ? 2 + 2 = 4 (rappel : B a la distance 2)

Entre B et E ? 2 + 4 = 6

#### Étape 3 : mise à jour de la table

On peut mettre la nouvelle valeur pour C, et la distance de E en passant par B est inférieure à la précédente, on peut la mettre à jour :

| Nœud | Distance la plus courte |
| ---- | ----------------------- |
| A    | 0                       |
| B    | 2                       |
| C    | 4                       |
| D    | 1                       |
| E    | 6                       |

#### Étape 4 : mise à jour des listes

Nous avons visité le premier nœud (A) :

```lst_visité
lst_visités = [A, D, B]
lst_non-visités = [C, E]
```

#### Itération 4

#### Étape 1 : point de départ

Ici c’est C le nœud non-visité qui a la distance la plus courte. Ce sera notre point de départ.

![Graphe pondéré A, B, C, D visités E nœud courant](/media/jean/T7 Shield/Formation/course_AI_and_video_games/docs/pix/Graphe pondéré_4ADB-C.png)

#### Étape 2 : distance des voisins

Quels sont les nœuds qui sont voisins de C ? B et E. Le seul nœud non-visités est E.

Quelle est la distance entre C et E ? 4 + 1 = 5 (rappel : C a la distance 4)

#### Étape 3 : mise à jour de la table

On peut mettre la nouvelle valeur pour E

| Nœud | Distance la plus courte |
| ---- | ----------------------- |
| A    | 0                       |
| B    | 2                       |
| C    | 4                       |
| D    | 1                       |
| E    | 5                       |

#### Étape 4 : mise à jour des listes

Nous avons visité le premier nœud (A) :

```lst_visité
lst_visités = [A, D, B, C]
lst_non-visités = [E]
```

#### Itération

#### Étape 1 : point de départ

Ne reste plus que E dans la liste des nœuds non-visités.

![Graphe pondéré A, B, C, D visités E nœud courant](/media/jean/T7 Shield/Formation/course_AI_and_video_games/docs/pix/Graphe pondéré_5ADBC-E.png)

#### Étape 2 : distance des voisins

Tous les autres nœuds ayant été visités, E n’a virtuellement plus aucun voisin.

#### Étape 3 : mise à jour de la table

Il n‘y a aucune mise à jour à faire

| Nœud | Distance la plus courte |
| ---- | ----------------------- |
| A    | 0                       |
| B    | 2                       |
| C    | 4                       |
| D    | 1                       |
| E    | 5                       |

#### Étape 4 : mise à jour des listes

Nous avons visité le premier nœud (E) :

```lst_visité
lst_visités = [A, D, B, C, E]
lst_non-visités = []
```

Nous avons donc trouvé tous les plus courts chemin depuis A vers tous les autres nœuds. 

Note : La liste lst_visités contient dans l’ordre les nœuds correspondant au parcours. Dans de nombreuses implémentation on parle de liste des prédécesseurs (on stocke les nœuds qui précèdent au fur et à mesure le nœuds qui est sélectionné avec la plus courte distance, ce qui permet de reconstruire les parcours).

### Dijkstra : pseudo-code

On peut décrire le cœur du fonctionnement de l’algorithme avec le pseudo code suivant 

Pour comprendre ce pseudo-code, considérons les définitions suivantes :

* G est le graphe pondéré dans lequel nous cherchons les plus courts chemins
* n<sub>départ</sub> est le nœud fixe (le point de départ, ou nœud de début) 
* v sont les voisins d’un nœud
* N est la liste (l’ensemble) des nœuds non visités 
* distance la liste/table des distances
* on ajoute une liste prédécesseur pour reconstruire le parcours si besoin

```
Fonction Dijkstra(G, n_départ):
    Pour chaque sommet n dans G:
        distance[n] ← ∞          # Distance initiale qu’on va minimiser, on part donc de l’infini
        prédécesseur[n] ← null       # il n‘y a forcément aucun prédécesseur au départ
    distance[n_départ] ← 0          # La distance du point de départ (premier nœud à lui-même est 0)

    Créer un ensemble N pour les nœuds non visités

    Ajouter tous les nœuds de G à N

    Tant que N n'est pas vide:
        n_courant ← sommet dans N avec distance minimale
        Retirer n_courant de S

        Pour chaque voisin v de n_courant:
            Si v est dans N:
                test_dist ← distance[n_courant] + poids(n_courant, v)
                Si test_dist < distance[v]:
                    distance[v] ← test_dist
                    prédécesseurs[v] ← n_courant

    Retourner distance, prédécesseurs

```

Attention ! Comme beaucoup de pseudo code, pour être implémenté il demande l’exécutions d’autres algorithmes ou de fonction annexes pour différentes tâches : initialisation, recherche de la distance minimale, mise à jour des distances…  voir par exemple [l’article Wikipédia sur le sujet](https://fr.wikipedia.org/wiki/Algorithme_de_Dijkstra). 

Si l’on cherche le plus court chemin entre deux nœuds en particulier, il suffit d’intégrer une condition d’arrêt dès que le nœud courant correspond au nœud final recherché. Il faut ensuite de manière itérative parcourir le chemin inverse pour isoler un parcours unique. Attention, si un tel chemin n’existe pas entre les deux nœuds, l’algorithme va s’engager dans une boucle infinie.

L’implémentation complète de cet algorithme demande plus que quelques lignes de code. Ce n’est pas l’objet de ce cours, nous avons juste besoin de créer une intuition sur le fonctionnement de cet algorithme, pour faciliter la compréhension de l’algorithme A* ou « A star ».

## A* (Art, Nilsson & Raphael, 1968)

L’algorithme de Dijkstra possède une limitation importante pour un usage dans les jeux vidéos : il réalise un inventaire exhaustif des chemins possibles (il a été conçu pour ça) afin de retrouver les chemins les plus courts de _tous_ les nœuds envisageables. Alors que dans le cas d’un jeu vidéo ce qui nous intéresse c’est la plupart du temps de trouver une trajectoire ou un chemin qui fonctionne entre deux points. Dijkstra gaspille donc du temps de calcul : des nœuds auront été évalués même s’ils sont très éloignés et n’ont rien à voir avec le parcours trouvé comme solution à la fin. On  dit que l’algorithme a un _fill_ important, il a pris en compte un nombre important de nœuds qui pourtant ne font pas partie de la solution (même si parfois il peut trouver des solutions rapidement, avec un _fill_ faible). C’est pour cela qu’il est n’est pratiquement jamais utilisé dans le domaine du jeu vidéo pour faire du pathfinding.  Néanmoins nous verrons plus loin que dans certains cas très particuliers, Dijkstra peut avoir son utilité.

Par contre l’algorithme A* (on dit *A star*) est un algorithme de référence pour le pathfinding dans les jeux vidéos. Son fonctionnement est proche de celui de Dijkstra, mais il est beaucoup plus efficace grâce à une approche dite *heuristique*.

Une heuristique est une méthode qui ne garantie pas d’atteindre le résultat optimum, mais dont on a de bonnes raisons de penser qu’elle nous amènera *grosso modo* à un résultat acceptable. C’est y aller *au feeling*. Par exemple les bâtisseurs de cathédrales ne savait pas calculer les contraintes avec précision et pas vraiment de formation en mécanique des matériaux, mais leur expérience pouvaient très bien les guider pour savoir qu’en empilant des pierres d’une certaine façon, ça tiendrait. Tout dépend du choix de l’heuristique : si celle-ci est mauvaise ou pas adaptée à la situation, le résultat peut-être catastrophique.

L’heuristique dans A* va intervenir au niveau du calcul des poids (distances). On ne va pas comme dans l’algorithme de Dijkstra calculer avec exactitude la somme des poids avec une exploration systématique de toutes les connexion possibles, mais au contraire faire intervenir une fonction heuristique dans le calcul qui va nous permettre de favoriser le chemin le plus *probable* et ainsi d’économiser beaucoup de temps de calcul et d’exploration.

Reprenons le fonctionnement dans un contexte de jeux vidéo, par exemple les déplacement sur une grille (*tileset* ou *bitmap*).

![Grille de jeu](/media/jean/T7 Shield/Formation/course_AI_and_video_games/docs/pix/Jeu_grille.png)

Imaginons un personnage qui doit être déplacé de la case verte à la case rouge. Les cases blanches sont infranchissables (murs), le déplacement est libre sur les cases noires.

Comment va se dérouler l‘algorithme A* ? 

![Départ algorithme A*](/media/jean/T7 Shield/Formation/course_AI_and_video_games/docs/pix/Jeu_grille_départ.png)

* On va créer en premier une liste où l’on va stocker toutes les cases pour lesquelles on va déterminer si le chemin est susceptible de passer, ou pas : ce sera le but de l’algorithme de le calculer. Cette liste est souvent appelée la liste *open*.

* La case de départ sera ajoutée à la liste. Ensuite on va ajouter à cette liste (on les marque d’un point jaune sur l’image) toutes les cases adjacentes où le personnage peut se déplacer, tout en notant bien depuis quelle case on arrive (case prédécesseur comme vu dans la section précédente sur l’algorithme de Dijkstra, appelée aussi case parent), sur l’image on indique la direction vers la case parent. On a vu précédemment que pour reconstituer un parcours il n’était pas idiot de sauver la succession de case empruntées. Bien sûr on ignore les cases infranchissables ou interdites. On voir qu’on est dans un cas très similaire à ce que l’on faisait avec l’algorithme de Dijkstra, si on imagine que les cases sont les nœuds adjacents d’un graphe.
* Vu que le personnage est déjà sur la case de départ, une fois qu’on l’a traitée en enregistrant ses cases adjacentes dans la liste *open*, on peut la déplacer dans la liste des cases déjà visitée (comme dans Dijkstra) ou liste *closed*. Sur l’image on marque alors la case d’un point bleu.

On se doute que comme dans Dijkstra l’étape suivante va être de sélectionner une des cases de la liste *open* en fonction de son *coût*, et qu’on répétera le processus jusqu’à trouver la case d’arrivée. C’est là que la grosse différence avec Dijkstra va apparaître.

Dans Dijkstra, la fonction de coût qui permet de sélectionner un chemin est simplement la somme de tous les poids (ou distance) le long du chemin depuis le point de départ jusqu’au nœud considéré. Sur notre grille on va faire simple : pour passer d’une case à une autre horizontalement ou verticalement on va dire que la distance (poids) est de 1. Ce qui implique que pour les déplacement en diagonale, la distance étant plus longue, le théorème de Pythagore nous indique que la distance sera alors de 1,4 (racine de 2). Pour simplifier les calculs de tête, multiplions le tout par 10 : coût de 10 pour les déplacements en ligne droite, et de 14 pour les déplacement en diagonale.

Dans le cas de A* on va ajouter un terme qui correspond à la fonction heuristique :
$$
\displaystyle coût= \sum poids + H
$$
Comment est définie H ? C’est l’estimation du coût du déplacement depuis le nœud considéré jusqu’au nœud de destination. Cette estimation est une heuristique : on n’est pas sûr du coût, mais on a de bonne raison de penser qu’il sera de tel ou tel ordre de grandeur.

Comment déterminer cette heuristique ? Plusieurs choix sont possibles, des articles sont écrits sur le sujet… vous trouverez ici une [comparaison entre heuristiques](http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html). Une heuristique dans notre cas sera une manière de calculer la distance entre la case ou le nœud considéré, et le point d’arrivée. Il y a plusieurs manière de calculer une [distance](https://fr.wikipedia.org/wiki/Norme_(math%C3%A9matiques)). La plus familière est la distance euclidienne qui donne la distance « à vol d’oiseau », elle fonctionne plutôt bien car on est presque certain qu’elle sous estime toujours la distance du chemin à parcourir ce qui est une condition d’efficacité de A* (vu qu’on cherche à se rapprocher au maximum de cette distance sous-évaluée, donc la plus courte possible). Mais on peut aussi utiliser ce que l’on appelle la distance de Manhattan, où l’on mesure les distances en ne se déplaçant qu’en ligne droite (imaginer le quadrillage que forment les rues de Manhattan). Pédagogiquement cette méthode a l’avantage d’être facile à visualiser sur une grille, et est aussi très facile à calculer (il suffit de compter le nombre de case parcourues) donc c’est celle-ci que l’on va employer ici. Malheureusement elle a tendance à surestimer la distance à parcourir (vu qu’on ne coupe pas à travers les diagonales), ce qui n’est pas très bon pour l’efficacité de A*, mais on s’en accommodera vu l’avantage pédagogique.

![Exemple distance de Manhattan](/media/jean/T7 Shield/Formation/course_AI_and_video_games/docs/pix/Jeu_grille_Manhattan.png)

On compte 14 cases pour parvenir à l’arrivée en ligne droite, donc une distance de Manhattan de 140.

Voici la somme des poids et les distances de Manhattan (donc les valeurs de H) pour chaque case adjacente au point de départ, qui permettent de calculer la fonction de coût pour chacune de ces cases :

![Calcul poids et heuristique](/media/jean/T7 Shield/Formation/course_AI_and_video_games/docs/pix/Jeu_grille_calcul_poids.png)

* L’étape suivante de l’algorithme est de choisir dans la liste *open* le nœud avec la plus petite fonction de coût (somme des poids + distance Manhattan). Nous constatons que nous avons deux cases dont les fonctions de coût sont identiques. Cela n’est pas bien grave : il est d’usage dans ce cas de choisir le dernier nœud qui a été ajouté à la liste *open*, cela est parfois un meilleur choix surtout quand on approche la fin du parcours, mais ce n’est pas obligatoire (on peut choisir au hasard).
* On place ce nœud/case dans la liste *closed*
* On inspecte les nœuds voisins / cases adjacentes et on ajoute à la liste *open* les cases qui ne sont ni dans la liste *closed*, ni interdites (murs, etc.), ni déjà dans la liste *open*.
* Si une case adjacente est déjà dans la liste *open*, il faut alors vérifier que la somme des poids en allant sur cette case depuis la case courante (donc compter un déplacement) n’est pas meilleure qu’en restant sur la case courante (on vérifie si le chemin passant par la case adjacente n’est pas un meilleur chemin). Si oui, alors modifier le parent de la case adjacente : c’est désormais la case où l’on se situe, et recalculer sa fonction de coût, ce qui permet d’actualiser le chemin que nous sommes en train de calculer. Si non par contre, on ne fait rien.

Un exemple pour expliciter ces étapes :

Sur l’image ci-dessus les cases avec la plus basse fonction de coût sont la case à gauche du personnage et la case au-dessus avec toute deux le même score : 140 (130 + 10). Choisissons la case de gauche. Plaçons donc cette case dans la liste *closed* (on la marque d’un point bleu sur l’image), et ajoutons à la liste *open* les nouvelles cases adjacentes, en indiquant que leur parent est la case courante : il y en a 2 (à gauche et en haut-à gauche de la case courante), les autres étant des cases interdites, ou la case de départ déja dans la liste *closed*. Trois cases adjacentes appartenaient déjà à la liste *open* : les cases au-dessus et en dessous du personnage, et la case en bas à gauche du personnage. Il faut donc voir si réévaluer la somme des poids avec un déplacement depuis la case courante permet de trouver un meilleur parcours :

* pour la case au-dessus du personnage, sa somme de poids actuel est de 10. Si on se déplaçait sur cette case en venant de la case courante, cette somme passerait à 10 (poids de la case courante) + 14 (déplacement en diagonale pour aller sur la case adjacente), on aurait donc une somme de poids égale à 24, il n‘y a donc aucun gain. On ne fait rien.
* pour la case en dessous du personnage, sa somme de poids actuel est de 10. Idem, si on se déplaçait sur cette case depuis la case courante, la somme de poids serait alors égale à 24 (10 + 14), aucun gain, on ne fait rien non plus.
* pour la case en bas à gauche du personnage, sa somme de poids est égale à 14 cette fois. Mais si on s‘y déplaçait depuis la case courante, cette somme de poids passerait à 24 aussi ( toujours 10 + 14), on ne fait toujours rien.

![Grille jeu, déplacement étape 2](/media/jean/T7 Shield/Formation/course_AI_and_video_games/docs/pix/Jeu_grille_Etape2.png)

Pour les deux cases nouvellement introduites, la case en diagonale haut gauche à une fonction de poids égale à 134 en tout, contre 140 pour la case immédiatement à gauche. Nous nous déplaçons donc sur la première case, en reprenant tout le processus, tout en remarquant à cette occasion que l’on est en train de contourner l’obstacle que constitue la case interdite en haut à gauche du point de départ !

On poursuit nos itération jusqu’à ce que la case d’arrivée soit ajoutée à la liste *closed*. Dans ce cas, il suffit de remonter la liste des parents pour chaque case de la liste *closed*, et on aura notre chemin.

### Pseudo code

```
Fonction A*(G, start, goal):
    Ouvrir une liste ouverte (liste des nœuds à explorer)
    Ouvrir une liste fermée (liste des nœuds déjà explorés)

    Coût[start] ← 0                       // Coût de la source
    Heuristique[start] ← h(start, goal)   // Heuristique de la source
    f[start] ← Coût[start] + Heuristique[start]

    Ajouter start à la liste ouverte

    Tant que la liste ouverte n'est pas vide:
        u ← nœud dans la liste ouverte avec le f minimal
        Si u est goal:
            Retourner reconstruire le chemin depuis start à goal

        Retirer u de la liste ouverte
        Ajouter u à la liste fermée

        Pour chaque voisin v de u:
            Si v est dans la liste fermée:
                Continuer                   // Ignorez ce nœud

            coût_temp ← Coût[u] + poids(u, v)

            Si v n'est pas dans la liste ouverte:
                Ajouter v à la liste ouverte
            Sinon si coût_temp ≥ Coût[v]:
                Continuer                   // Ignorez ce nœud

            // Mettre à jour les coûts
            Coût[v] ← coût_temp
            Heuristique[v] ← h(v, goal)
            f[v] ← Coût[v] + Heuristique[v]
            Précédent[v] ← u

    Retourner "Aucun chemin trouvé"
```

Un exemple d’implémentation en Python, par un jeune et brillant participant à un atelier que j’anime bénévolement (n’oubliez pas de lui donner une étoile) : https://github.com/elliott005/A_star

## Pour aller plus loin

Ce n’est qu’une présentation très simple de l’algorithme A*

À  l’usage, de nombreux problèmes peuvent se poser : 

* lorsque l’on déplace plusieurs sprites à la fois. Il faut gérer les collisions, et empêcher les sprites de se superposer. Dans ce dernier cas, des problèmes peuvent survenir si les sprites se déplacent simultanément et que la position interdite pour que les sprites ne se chevauchent pas n’est pas mise à jour aussi rapidement (un sprite peu alors éviter un autre sprite qui pourtant n’est plus là).

  Deux articles de Dave Pottinger (Age of Empire) sur les problèmes que posent le pathfinding pour les mouvement coordonnés de groupe (problème récurrent dans les RTS) : 

  https://www.gamedeveloper.com/programming/coordinated-unit-movement

  https://www.gamedeveloper.com/programming/implementing-coordinated-movement

  Un article qui récapitule les problèmes qui peuvent se poser dans ce contexte :

  https://www.gamedeveloper.com/programming/group-pathfinding-movement-in-rts-style-games

* on peut faire des fonctions de coûts plus élaborées, notamment au niveau de la somme des poids. Par exemple ajouter des bonus ou des malus en fonction de la nature du terrain (dénivelé, maris, eau, route…). L’algorithme A* s’adapte très bien à cela, de manière « réaliste » car dans ce cas le chemin le plus « court » sera le chemin le plus « facile » (avec le moindre coût).

* en manipulant les poids, on peut aussi modifier le comportement des PNJ (une forme d’IA). Imaginons un secteur de la carte où le joueur s’est mis en embuscade. Si beaucoup de PNJ meurent à cet endroit, pour empêcher que les PNJ continuent mécaniquement de s’y ruer, il suffit d’augmenter les poids de ces zones où la mortalité est élevée (une manière de la notifier comme zone « dangereuse ») et les PNJ  auront tendance à l’éviter dans leurs déplacement. Augmenter les poids peut-être un moyen d’éviter les problèmes de chevauchement de sprites (en augmentant les poids le long d’un chemin emprunté par un sprite - à utiliser avec parcimonie, attention à la synchronisation et aux effets de bord).

* les chemins trouvés par A* ne sont pas forcément les chemins les plus harmonieux, il peut y avoir des changement de direction assez abrupts. voir cet article sur le sujet : https://www.gamedeveloper.com/programming/toward-more-realistic-pathfinding

* pensez à trier ou optimiser la recherche dans vos listes *open* ! Accéder le plus rapidement possible au nœud avec la plus petite fonction de coût est crucial pour économiser du temps de calcul (surtout si les chemins sont longs). Il y a de nombreuses techniques pour optimiser cela : lisez des articles, perfectionnez-vous en algorithmique. 

* l’algorithme A* est efficace… quand on sait où l’on va ! Si l’on doit explorer une zone de manière extensive, où que l’on sait seulement approximativement où est situé notre but (par exemple une équipe de PNJ à la recherche de ressources dans une zone) Dijkstra peut-être plus performant que lancer répétitivement A* sur des objectifs au hasard… 





