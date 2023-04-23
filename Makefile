.PHONY: start
start:
	@echo "Starting the environment..."
	devcontainer up

.PHONY: stop
stop:
	@echo "Stopping the environment..."
	docker stom devenv

.PHONY: clean
clean:
	@echo "Cleaning the environment..."
	docker rm devenv

.PHONY: build
build:
	@echo "Building the environment..."
	devcontainer build --image-name utkarsh23/devenv $(ARGS)

.PHONY: alias
alias:
	@echo "Adding dssh alias..."
	@if ! grep -q "alias dssh=" ~/.zshrc; then \
		echo "alias dssh='docker exec -it devenv -u utkarsh -w /home/utkarsh zsh'" >> ~/.zshrc; \
	fi