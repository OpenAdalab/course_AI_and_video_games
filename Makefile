install_lecture_tools:
	# for mkdocs
	pip install mkdocs

	pip install mkdocs_material
	pip install mkdocs_exclude
	pip install pymdown-extensions
	pip install python-markdown-math

	# for jupyter nb
	pip install nbconvert

	# extenstions
	pip install jupyter_contrib_nbextensions

extensions:
	# activate extensions
	jupyter nbextension enable splitcell/splitcell # allows to split in two cols

# update_evaluation:
# 	# copy to server evaluations for code exercices folders
# 	cp  ./code/data_science/evaluations /home/nico/pCloudDrive/Public\ Folder/evaluations
# 	cp  ./code/machine_learning/evaluations/etude_de_cas /home/nico/pCloudDrive/Public\ Folder/evaluations
# 	echo "exercises copied to server"

# ToDo : Create to target one for running slides server and one without
# notebook_file=$(current_notebook_name).ipynb
# update_lesson:
# 	echo "exporting notebook $(current_notebook_name) to slides"
# 	jupyter nbconvert --to slides $(notebook_file)
# 	cp "$(current_notebook_name).slides.html" /home/nico/pCloudDrive/Public\ Folder/lecons
# 	echo "slides were copied to server folder"

# clean_evaluation:
# 	echo "clean evaluation folder on server"
# 	rm /home/nico/pCloudDrive/Public\ Folder/evaluations/.*

update_site:
	@echo "updating course web site"
	mkdocs build
	cp -r site /home/nico/pCloudDrive/Public\ Folder/cours/Game\ AI
	@echo "course copied to server"

# clean site folder while saving a backup
# clean_site:
# 	# backup current site version
# 	cp -r /home/nico/pCloudDrive/Public\ Folder/cours/general/site/ /home/nico/pCloudDrive/Sauvegarde/tmp/site/

# 	echo "remove site folder locally and on server"
# 	rm -r /home/nico/Ma Bibliothèque/Mes\ cours/général/site/
# 	rm -r /home/nico/pCloudDrive/Public\ Folder/cours/general/site/

# 	mkdocs build
# 	cp -r site /home/nico/pCloudDrive/Public\ Folder/cours/general/
# 	echo "site cleaned and updated"