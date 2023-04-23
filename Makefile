.PHONY: start
start:
	@echo "Starting the environment..."
	devcontainer up --workspace-folder runner $(ARGS)

.PHONY: stop
stop:
	@echo "Stopping the environment..."
	docker stop devenv

.PHONY: clean
clean: stop
	@echo "Cleaning the environment..."
	docker rm devenv

.PHONY: build
build:
	@echo "Building the environment..."
	devcontainer build --workspace-folder builder --image-name ghcr.io/utkarsh-pro/devenv:0.1 $(ARGS)

.PHONY: build-push
build-push:
	@echo "Building & Pushing the development environment..."
	devcontainer build --workspace-folder builder --image-name ghcr.io/utkarsh-pro/devenv:0.1 --platform linux/amd64,linux/arm64 --push $(ARGS)

.PHONY: alias
alias:
	@echo "Adding dssh alias..."
	@if ! grep -q "alias dssh=" ~/.zshrc; then \
		echo "alias dssh='docker exec -it -u utkarsh -w /home/utkarsh devenv zsh'" >> ~/.zshrc; \
	fi