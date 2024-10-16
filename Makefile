install_lecture_tools:
	# for mkdocs
	pip install mkdocs

	pip install mkdocs_material
	pip install mkdocs_exclude
	pip install pymdown-extensions
	pip install python-markdown-math
	pip install mkdocs-section-index

	# for jupyter nb
	pip install nbconvert

	# extenstions
	pip install jupyter_contrib_nbextensions

extensions:
	# activate extensions
	jupyter nbextension enable splitcell/splitcell # allows to split in two cols

deploy_with_githubpages:
	mkdocs gh-deploy	

deploy_site_with_kinsta: 
	mkdocs build
	scp -r ./site user@host:/path/to/server/root


# ToDo : Create to target one for running slides server and one without
# notebook_file=$(current_notebook_name).ipynb
# update_lesson:
# 	echo "exporting notebook $(current_notebook_name) to slides"
# 	jupyter nbconvert --to slides $(notebook_file)
# 	cp "$(current_notebook_name).slides.html" /home/nico/pCloudDrive/Public\ Folder/lecons
# 	echo "slides were copied to server folder"

update_site:
	@echo "updating course web site"
	mkdocs build
	cp -r site /home/nico/pCloudDrive/Public\ Folder/cours/Game\ AI
	@echo "course copied to server"

