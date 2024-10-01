# Les agents intelligents et leurs environnements
 <meta name="auteur" content="Nicolas Rochet">
 <meta name="date_creation" content="mardi, 05. novembre 2019">
 <meta name="date_modification" content="mercredi, 06. novembre 2019">

## Introduction 
Le terme d'**agent rationnel** interagissant avec un **environnement** est un concept central de l'intelligence artificielle, puisqu'il est sous-jacent à la plupart des concepts, théories et algorithmes que nous allons rencontrer dans cette discipline.
On peut définir un **agent** comme une entité capable de percevoir son environnement par l'intermédiaire de **capteurs sensoriels** et d'agir sur cet environnement par l'intermédiaire d'**effecteurs**. 
> Par exemple, un agent peut être incarné par un humain, un robot ou encore un programme informatique, il perçoit son environnement sous forme de **percepts** en recevant des entrées sensorielles (*appuis claviers, contenu de fichiers, ...*) et agissant sur son environnement (*en affichant des informations sur un écran, écrivant des fichiers, ...*)

<!--insérer ici une image illustrant l'interaction agent/environnement (inspiré de la figure 2.1)-->

### Description mathématique et implémentation
D'un point de vue mathématique, le comportement d'un agent est décrit par une **fonction d'agent** , une description mathématique qui relie un percept donné à une séquence d'actions. On modélise souvent cette fonction d'agent sous forme de tableau, dans lequel, pour un environnement donné, on référence **la séquence des percepts** et les séquences d'actions correspondantes.
On distingue la fonction d'agent de son implémentation, le **programme d'agent**, qui opère sur un système physique (*par exemple, un ordinateur*) et est souvent représentée par le **pseudo-code** d'un **algorithme**.

> Illustrons ces notions par l'exemple dessiné dans la figure 2.2 représentant un agent défini par un aspirateur dans un environnement simple content deux localisations A, contenant de la poussière et B, vide. Dans cet environnement, l'agent peut effectuer les actions de bouger à droite, à gauche, aspirer la poussière, ou ne rien faire. Une des plus simples fonction d'agent que l'on puisse définir serait : "Si l'endroit actuel est sale, alors aspire la poussière, sinon déplace toi vers l'autre localisation". Une modélisation tabulaire partielle pour cette fonction est représentée par la ***figure 2.3***.

 **Figure 2.2**: Exemple d'agent-aspirateur dans un environnement simple avec deux localisations.
![Exemple d'un simple agent aspirateur](https://filedn.eu/lefeldrXcsSFgCcgc48eaLY/images/cours_datascience_IA/agent_aspirateur.png "Figure 2.2")

**Séquence de percepts**| **Action**
 :-: | :-: 
[A, propre] | Se déplacer à droite
[A, sale] | Aspirer
[B, propre] | Se déplacer à gauche
[B, sale] | Aspirer
[A, propre], [A, propre]| Se déplacer à droite
[A, propre], [A, sale] | Aspirer
... | ...


**Figure 2.3**: Modélisation partielle sous forme de tableau de notre agent-aspirateur 

Avec cette implémentation simple, on peut définir le comportement de notre agent en remplissant le tableau. La question évidente qui se pose est de savoir comment remplir le tableau pour rendre notre agent intelligent ?

## Comportement optimal d'un agent: le concept de rationalité
Intuitivement, un agent rationnel est un agent qui accomplit *les bonnes actions*. Dans notre exemple précédent construire un agent rationnel reviendrait à pourvoir remplir la table de la figure 2.3 avec *les meilleurs choix d'actions possibles pour chaque séquence de percepts*. Afin de définir plus précisément le concept de rationalité, on examine les *conséquences du comportement de l'agent sur son environnement*: on recherche à obtenir la *séquence d'états de l'environnement la plus désirable*. Cette désirabilité est évaluée par une **mesure de la performance** que l'agent rationnel cherchera à maximiser par ses actions.
>Bien entendu, il n'y a typiquement pas de mesure de la performance idéale pour toutes les tâches et tous les agents, cela dépendra des caractéristiques du problème à résoudre. Par exemple, dans notre exemple précédent avec notre agent-aspirateur (figure 2.2), on pourrait proposer comme mesure de performance la quantité de poussière ramassée par l'aspirateur pendant une période donnée. Un tel agent 'rationnel' pourrait maximiser cet mesure en nettoyant la poussière, puis la laisser tomber sur le sol pour la nettoyer de nouveau. Si le problème consiste à simplement nettoyer l'environnement ce comportement ne parait pas optimal, une mesure plus appropriée de la performance serait plutôt de récompenser l'agent par un point à chaque endroit qu'il a nettoyé à chaque pas de temps.

### Définition de la rationalité pour un agent
Pour chaque séquence de percepts possible, un agent rationnel est celui qui va sélectionner l'action qui **maximise la mesure de la performance attendue**, indépendamment de la connaissance a priori que possède l'agent sur son environnement.

> Suivant cette définition, notre fonction d'agent définit plus tôt comme "Si l'endroit actuel est sale, alors aspire la poussière, sinon déplace toi vers l'autre localisation" caractérise t'elle un agent rationnel ? Cela dépend, il faut pour y répondre définir précisément la mesure de la performance, la connaissance à priori de l'agent de son environnement ainsi que ses percepts et actions possibles. Supposons que:
- la performance consiste à récompenser d'un point chaque position nettoyée à chaque pas de temps durant une période donnée
- la "géographie" de l'environnement est connue a priori mais la position initiale de la poussière et de l'aspirateur n'est pas forcément connue.
- l'agent perçoit toujours correctement sa localisation et si celle-ci contient de la poussière.
- dans l'environnement, à chaque pas de temps, chaque case reste propre une fois qu'elle à été nettoyée.
- chaque nettoyage de l'aspirateur nettoie toujours la case dans laquelle il se trouve.
- les actions "se déplacer à droite" et "se déplacer à gauche" déplacent toujours l'aspirateur sans qu'il sorte de son environnement.
- les seules actions possibles sont "se déplacer à droite", "se déplacer à gauche" et "nettoyer".

*Alors, suivant ces circonstances, un tel agent est rationnel, sa performance sera toujours aussi élevée que celle de n'importe quel autre agent*

#### Non-omniscience, apprentissage et autonomie: des conséquences de notre définition de la rationalité
- Il est important de remarquer que notre définition de la rationalité ne requiert pas pour l'agent de posséder une connaissance **omnisciente** des conséquences de ses actions, qui est impossible dans la réalité. Ainsi, l'agent rationnel  cherche à maximiser la performance *attendue* , qui dépend uniquement de la séquence de percepts connue au moment ou il agit.
- Notre définition implique qu'un agent rationnel soit capable, en général,  de **rassembler de l'information** et d'**apprendre** autant que possible à partir de ses percepts. Cet apprentissage lui permet de mettre a jour sa connaissance a priori de son environnement, excepté dans certains cas rare où son environnement est complètement connu a priori.
- Un agent rationnel devrait être **autonome**, c'est à dire que sa capacité à apprendre lui permette de compenser une connaissance partielle ou incorrecte de son environnement.

## Propriétés des environnements d'une tâche
On définit l'**environnement d'une tâche** (*task environnement*) comme l'ensemble englobant la performance d'un agent,  son environnement, ses effecteurs et ses capteurs sensoriels.
Dans la discipline de l'Intelligence Artificielle, il est possible de catégoriser un certain nombre d'environnements de tâches en fonction de leur caractéristiques:

-  L'environnement d'une tâche est **partiellement** versus **totalement** observable si les capteurs peuvent percevoir une **partie** versus la **totalité** de l'état de l’environnement à chaque point de temps. Dans certains cas plus extrêmes, lorsque l'agent ne possède pas de capteurs, l'environnement est **inobservable**.
>Par exemple au poker, les cartes sont cachées (ou partiellement observables) mais le fait de mémoriser les coups passés permet d’acquérir des informations supplémentaires sur l’environnement.

 - L'environnement d'une tâche peut être composé d'un **agent simple** versus un **système multi-agent**, c'est à dire un ensemble d'agents interagissant de manière **compétitive** ou **coopérative** dans un environnement pour accomplir une tâche donnée.

  - L'environnement d'une tâche est **bénin** versus **adverse** lorsque **l’environnement n’a pas d’objectif propre** à l'opposé d'un **environnement qui essaye de contrecarrer les actions de l’agent** 
  >Par exemple, dans la plupart des sports ou dans certains jeux l’adversaire est un environnement adverse.

- L'environnement d'une tâche est **déterministe** versus **stochastique** lorsque l'état futur de l'environnement est déterminé **uniquement par le résultat des actions de l'agent** on dit qu'il est déterministe; dans tous les autres cas il est stochastique. Lorsque l'environnement d'une tâche n'est pas totalement observable ou pas déterministe, on le qualifie d'**incertain**.

- L'environnement d'une tâche est **épisodique** lorsque les expériences (percepts et action) de l'agent peuvent être découpées en épisodes élémentaires. Dans chacun de ces épisodes, l'agent reçoit un percept et exécute une action sans que cette action ne dépende des expériences du précédent épisodes. A l'opposé un environnement de tâche est **séquentiel**, lorsque les expériences en cours peuvent affecter les actions futures de l'agent. 
>Dans ce type d'environnement de tâches assez courant, les actions à court terme on des conséquences à long terme, ce qui conduit généralement les créateurs d'agents à lui implémenter des stratégies de planification à long terme. La plupart des jeux de plateaux comme les échecs, sont des exemples d'environnements de tâches séquentiels 

- L'environnement d'une tâche est **dynamique** si l'environnement auquel est confronté l'agent peut changer pendant le temps ou l'agent prend une décision. Lorsque l'environnement ne change pas pendant le temps mais que la performance de l'agent change, on parle d'environnement **semi-dynamique**. Dans tous les autres cas on définit l'environnement de la tâche comme **statique**.

- L'environnement d'une tâche est **discret** versus **continu**  lorsque l’agent dispose d’un nombre **dénombrable** versus **indénombrable** de stimuli à percevoir et d'actions à exécuter.

- L'environnement d'une tâche est **connu** versus **inconnu** en référence à la connaissance que peut avoir l'agent (ou son créateur) des lois qui gouvernent l'environnement (par exemple les lois de la physique). Dans un environnement connu, les conséquences (ou leur probabilités) de toutes les actions sont connues. Dans un environnement inconnu l'agent devra apprendre "comment l'environnement fonctionne" pour prendre des bonnes décisions. 
>Par exemple un environnement physique est connu car soumis au lois de la physique par opposition à un environnement virtuel dans lequel son créateur peut choisir les règles qui régissent cet environnement et les maintenir cachées pour l'agent.

Comme vous pouvez vous en doutez, certains environnements de tâches constituent des problèmes plus compliqués à résoudre que d'autres, un des cas les plus durs étant un environnement de tâche partiellement observable, multi-agent, stochastique, séquentiel, dynamique continu, adverse et inconnu.

## Différents types d'agents
De manière générale en Intelligence Artificielle, on estime que les principes définissant la plupart des systèmes intelligents s'incarnent en quatre grandes catégories d'agents. Chacun d'entre eux combine des composants particulier pour prendre des décisions et générer des actions.  

- les *simple-reflex agents*: ce type d'agent répondent directement aux percepts qu'ils reçoit en se basant sur des règles **condition-action** pré déterminées.
> Par exemple pour un agent de conduite autonome, une règle simple de condiction-action peut être "**si** le véhicule qui est situé devant freine **alors** freine.

- les *model-based reflex agents*: ce type agent possède un **modèle de l'environnement** (de simple règles logiques à de complexes théories scientifiques) qui leur permette de *maintenir une trace de l'état interne de l'environnement* à un instant ***t*** pour mettre à jour sa représentation de l'environnement et en conséquence exécuter des actions plus performantes. Ce genre d'agent est environnement est particulièrement adapté dans les environnements partiellement observables.
> Par exemple, notre agent de conduite autonome doit pouvoir détecter, à un instant ***t***, sur le véhicule le précédant les lumières rouges indiquant un appui sur le frein et stocker cette information , pour pouvoir mettre a jour sa représentation de l'environnement à un instant ***t+1*** et "décider" de freiner.

- les *goal-based agents*: ce type d'agent possède les même composants que les *model-based reflex agents* avec un composant supplémentaire, un **but** qui lui permette de décider si une situation est "désirable" pour choisir une action à effectuer. Généralement les comportement de ce type d'agents sont plus flexible que ceux des deux types précédents en contrepartie de performances parfois moins importantes.

- les *utility-based agents*:  ce type d'agents intègrent, en plus des autres composants présents chez les autres types d'agents, une **fonction d'utilité** qui agit comme une mesure de la performance, interne à l'agent . Si cette mesure interne s'accorde avec la mesure externe de la performance, alors un agent qui maximise sa fonction d'utilité adoptera un comportement rationnel (puisqu'il maximisera aussi la performance externe).

Pour plus de détails concernant la construction et le fonctionnement de ces agents référez vous au chapitre 2.4 du livre cité en source.

***
## Lexique du chapitre
### Termes généraux
- Un [algorithme](https://fr.wikipedia.org/wiki/Algorithme) est une suite finie et non ambiguë d’opérations ou d'instructions permettant de résoudre une classe de problèmes.
- Le [pseudo-code](https://fr.wikipedia.org/wiki/Pseudo-code) est une façon de décrire un algorithme en langage presque naturel, sans référence à un langage de programmation en particulier. 

### Les agents
- Un **percept** désigne l'ensemble des entrée sensorielles reçues par un agent. Une **séquence de percepts** désigne l'historique complet de tous les percepts de l'agent.

## Sources
Chapitre 2 du livre [Artificial Intelligence, A modern approach, 3ème édtition. Sutart Russel & Peter Norwig, *Pearson*.](http://aima.cs.berkeley.edu/)  

