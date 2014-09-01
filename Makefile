
# making distribution
dist:
	@ make js
	@ cp README.md LICENSE package.json dist
	@ echo "Dist ready !"


# compiling coffee to js
js:
	@- mkdir dist
	@ coffee --no-header --output dist --compile *.coffee
	@ echo "Coffee compiled !"


# cleaning the dist files
clean:
	@ rm -rf dist
	@ echo "Cleaned !"


.PHONY: dist js clean
