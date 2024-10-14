# Cours Game AI

## Description

Ce dépôt contient les composants pour la fabrication du contenu et du site web de tous les cours de data science & IA en français. 
Le contenu est organisé sous forme de chapitres thématiques, chaque chapitre étant un fichier `markdown` et contenant éventuellement des diapos fabriquées à partir du logiciel `slides.com`ou  de`jupyter notebook`.

Le site est ensuite généré en utilisant le package `mkdocs` (et quelques plugins additonnels) à partir du fichier de configuration `mkdocs.yml`

## Structure 

**`docs`** : contient les chapitres de thématiques de cours qui sera utilisé par mkdocs pour générer les pages pour chaque chapitre.  
**`code`**: contient le code utilisés dans les chapitres: notebooks pour les leçons, exercices et démos.  
**`site`**: contient les fichiers du site généré par mkdocs, dossier qui sera utilisé pour mettre le site en ligne.  
**`mkdocs.yml`** : sert à construire le squelette du site web (onglets, table des matières, chapitres) à partir des documents de contenu.  
**`Makefile`** : sert à lancer des commandes raccourcies pour l'installation, la gestion et la mise en ligne du contenu.  

## Méthodologie pour la production de contenu

- Chaque chapitre correspond à un document rédigé en markdown. Une fois édité, ajoutez le chapitre au fichier `mkdocs.yml` dont le builder se servira pour générer les pages du site.

- Les chapitres peuvent contenir plusieurs leçons, démos ou synthèse qui seront présentés sous forme de slides :
  - soit intégrées en tant qu'iframe depuis `slides.com`
  - soit transformées à partir de notebooks et hébergé sur un stockage distant partagé ( *à mettre en place*)
  
- Les images à intégrer sont hébergé sur un stockage distant partagé (*à mettre en place*)

## Installation 

1. Créer un environnement virtuel pour installer les paquets spécifiques à ce projet (préférentiellement avec conda)

2. Installer `mkdocs` et tous les plugins nécessaires, via la commande **make** du `Makefile`:

   ```bash
   make install_lecture_tools
   ```
A ce stade tous les composants pour la conception du site devraient être installés.  

## Utilisation
1. Mettre à jour le contenu en fonction des besoin pour préparer de nouveaux chapitres (fichiers markdown, notebooks)

   Vous pouvez tester le site généré en local via la commande : `mkdocs serve`

2. Mettre le site en ligne : 
	- transformer les notebooks de leçons et les déployer sur stockage en ligne  : 
	```bash
   sh .code/deploy_lesson.sh <nom-du-notebook>
   ```
	- déployer le site via github pages à partir de la branche `gh-pages`: 
	```bash
   git checkout gh-pages
   mkdocs gh-deploy
   ```
   
   
