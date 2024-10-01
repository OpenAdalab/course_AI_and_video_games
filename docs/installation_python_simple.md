# Installation et gestion du langage python et de ses librairies

## Installation de vos composants pour python

Dans ce cours, vous allez utiliser des  **gestionnaires de paquets et environnements virtuels** et y installer python et ses principaux packages pour la data science.    

Référez vous à la [leçon sur la gestion de paquets en python](https://filedn.eu/lefeldrXcsSFgCcgc48eaLY/lecons/lecon_environnements_virtuels.slides.html) pour plus de détails

!!! warning "Installez une version de python >= 3.10"

???+ tip "Utilisez la distribution miniconda"
	Vous pouvez installer python par de nombreux moyen, mais je vous conseille d'utiliser le gestionnaire de paquets et d'environnements virtuels [miniconda](https://docs.anaconda.com/miniconda/) afin de vous faciliter la gestion des paquets en python.

### Via miniconda

Suivez la [documentation d'installation officielle de miniconda](https://docs.conda.io/en/latest/miniconda.html). Installez la version la plus récente de la distribution miniconda, dans laquelle python et quelques paquets essentiels seront pré-installé

### Installation de modules python

Si vous avez installé python via anaconda ou miniconda, la plupart des modules qui nous seront nécessaires devraient déja être installés. 

Sinon vous pouvez les installer facilement en utilisant, au choix `pip` (l'installateur officiel de paquets en python) ou `conda`:
```zsh
pip install <package_name> 
conda install <package_name>
```