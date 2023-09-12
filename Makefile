# Set git local user
git_config:
	git config user.name "Mariusz94"
	git config user.email "lyszczarz.mariusz@gmail.com"

# Method to remove folders
# Usage: make rm DIR=ec-files-proto
rm:
ifeq ($(OS), Windows_NT)
	rmdir /s /q $(DIR)
else
	rm -rf $(DIR)
endif

# Generate microservice structure
gen_ms:
	git clone --branch main https://github.com/Mariusz94/structure_project_generator.git
	cp -a ./structure_project_generator/python/microservice/. ./.
	make rm DIR=structure_project_generator
