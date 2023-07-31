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
	devcontainer build --workspace-folder builder --image-name ghcr.io/utkarsh-pro/devenv:latest $(ARGS)

.PHONY: build-push
build-push:
	@echo "Building & Pushing the development environment..."
	devcontainer build --workspace-folder builder --image-name ghcr.io/utkarsh-pro/devenv:latest --platform linux/amd64,linux/arm64 --push $(ARGS)

.PHONY: alias
alias:
	@echo "Adding dssh alias..."
	@if ! grep -q "alias dssh=" ~/.zshrc; then \
		echo "alias dssh='docker exec -it -u utkarsh -w /home/utkarsh devenv zsh'" >> ~/.zshrc; \
	fi

.PHONY: vm-start
vm-start:
	@echo "Starting the VM environment..."
	@sed 's/#{{/$${/g; s/}}/}/g' ./vm/devenv.yml | envsubst | sed 's/$${/#{{/g; s/}/}}/g' | limactl start --name devenv $(ARGS) -
	@echo "Restarting the VM environment..."
	@limactl stop devenv
	@limactl start devenv

.PHOINY: vm-restart
vm-restart:
	@echo "Restarting the VM environment..."
	@limactl stop devenv
	@limactl start devenv

.PHONY: vm-stop
vm-stop:
	@echo "Stopping the VM environment..."
	@limactl stop devenv

.PHONY: vm-clean
vm-clean: vm-stop
	@echo "Cleaning the VM environment..."
	@limactl delete devenv

.PHONY: vm-alias
vm-alias:
	@echo "Adding vdssh alias..."
	@if ! grep -q "alias vdssh=" ~/.zshrc; then \
		echo "alias vdssh='limactl shell --workdir /home/${USER}.linux devenv'" >> ~/.zshrc; \
	fi

.PHONY: vm-ssh
vm-ssh:
	@echo "SSHing into the VM environment..."
	@limactl shell --workdir /home/${USER}.linux devenv

.PHONY: vm-vscode-alias
vm-vscode-alias:
	@echo "Adding VSCode alias in the VM environment..."
	@if ! grep -q "alias vmc=" ~/.zshrc; then \
		echo "alias vmc='code --remote ssh-remote+localhost'" >> ~/.zshrc; \
	fi
