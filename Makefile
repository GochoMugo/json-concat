
# making distribution
dist:
	@- mkdir dist
	@ coffee --no-header --output dist --compile src/*.coffee
	@ cp README.md LICENSE package.json dist
	@ echo "Dist ready !"


# cleaning the dist files
clean:
	@ rm -rf dist
	@ echo "Cleaned !"


.PHONY: clean
