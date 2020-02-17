
REPOS_DIR=repos
DIST_DIR=dist

clean:
	rm -rf $(REPOS_DIR)
	rm -rf $(DIST_DIR)

full_clean: clean
	rm -rf node_modules

requirements:
	npm install
