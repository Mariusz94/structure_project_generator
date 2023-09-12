# Set git local user
git_config:
	git config user.name "Mariusz94"
	git config user.email "lyszczarz.mariusz@gmail.com"

# Make docs with Sphinx
doc:
    make -C ./docs doc

# Method to remove folders
# Usage: make rm DIR=ec-files-proto
rm:
ifeq ($(OS), Windows_NT)
	rmdir /s /q $(DIR)
else
	rm -rf $(DIR)
endif

# Generate proto messages
gen_proto: clone_proto proto_generate
	make rm DIR=structure_project_generator

clone_structure_project_generator:
    git clone --branch dev https://github.com/Mariusz94/structure_project_generator.git

clone_proto: clone_structure_project_generator

proto_generate:
	@ECHO ---------------- Generate proto files ----------------
	python -m grpc_tools.protoc -I./structure_project_generator/grpc --python_out=./app/grpc_file --pyi_out=./app/grpc_file --grpc_python_out=./app/grpc_file ./structure_project_generator/grpc/default_msg/default.proto
	
	python -m grpc_tools.protoc -I./structure_project_generator/grpc --python_out=./tests/grpc_file --pyi_out=./tests/grpc_file --grpc_python_out=./tests/grpc_file ./structure_project_generator/grpc/default_msg/default.proto
	
make_venv:
    python3.8 -m venv venv
    source ./venv/bin/activate && pip install -r ./app/requirements.txt && pip install pytest
