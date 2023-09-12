# Method to remove folders
# Usage: make rm DIR=ec-files-proto
rm:
ifeq ($(OS), Windows_NT)
	rmdir /s /q $(DIR)
else
	rm -rf $(DIR)
endif

# 
gen_struct:
	git clone --branch main https://github.com/Mariusz94/structure_project_generator.git
# cp ./structure_project_generator/python/create.sh ./bs-authentication-ms/create.sh
	cp -r ./python/microservice/* /ala/.

# make rm DIR=structure_project_generator
# cd ./bs-authentication-ms && bash ./create.sh
# make rm DIR=./bs-authentication-ms/create.sh