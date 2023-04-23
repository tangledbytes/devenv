#!/usr/bin/env python
import os
import sys
import argparse
import urllib.request

class Utils:
	@staticmethod
	def download(url):
		print("Downloading from %s" % url)

		# Download the file
		response = urllib.request.urlopen(url)
		content = response.read().decode("utf-8")

		return content

	@staticmethod
	def read_file(file):
		print("Reading from %s" % file)

		# Read the file
		f = open(file, "r")
		content = f.read()
		f.close()

		return content

	@staticmethod
	def write_file(file, content):
		print("Writing to %s" % file)

		# Write the file
		f = open(file, "w")
		f.write(content)
		f.close()

class ArgParser:
	def __init__(self, prog, description):
		self.commands = {}
		self.parser = argparse.ArgumentParser(prog=prog, description=description)
		self.subparsers = self.parser.add_subparsers(help='commands', dest='command')
	
	def register_command(self, name, command):
		command.setup(self.subparsers)
		self.commands[name] = command
	
	def parse(self):
		args = self.parser.parse_args()
		options = vars(args)
	
		command = self.commands[args.command]
		command.run(options)

class StartCmd:
	def parse_vars(self, options):
		vars = {}
		opt_vars = options["vars"] or []
		for var in opt_vars:
			key, value = var.split("=")
			vars[key] = value
		return vars

	def replace_vars(self, content, options):
		# Replace all the environment variables in the template that start with "DEVENV_"
		vars = self.parse_vars(options)
		for var in vars:
			content = content.replace("#{{" + var + "}}", vars[var])

		return content

	def setup(self, parser):
		start_parser = parser.add_parser('start', help='Start the environment')
		start_parser.add_argument('-f', '--file', type=str, help='devenv.yaml file')
		start_parser.add_argument('--vars', type=str, nargs="+", help='Variables to replace')
		self.setup_done = True

	def run(self, options):
		if not self.setup_done:
			raise Exception("Setup not done")
		
		file = options["file"] or "devenv.yaml"
		if file.startswith("http"):
			content = Utils.download(file)
		else:
			content = Utils.read_file(file)

		content = self.replace_vars(content, options)

		# Write the file to current directory
		Utils.write_file("devenv.final.yaml", content)


		# Show the file
		print("=======================================")
		print(content)
		print("=======================================")

		# Ask for confirmation to start
		confirm = input("Start? (y/n): ")
		if confirm != "y":
			return
		
		# Start the environment
		os.system("limactl start --tty=false --name=devenv devenv.final.yaml")

		# Restart the environment
		os.system("limactl stop devenv")
		os.system("limactl start devenv")

class CleanCmd:
	def setup(self, parser):
		clean_parser = parser.add_parser('clean', help='Clean the environment')
		self.setup_done = True

	def run(self, options):
		if not self.setup_done:
			raise Exception("Setup not done")
		
		# Ask for confirmation to clean
		confirm = input("Clean? (y/n): ")
		if confirm != "y":
			return
		
		# Confirm again
		confirm = input("Are you sure? (y/n): ")
		if confirm != "y":
			return
		
		# Confirm again
		confirm = input("Are you really sure? (y/n): ")
		if confirm != "y":
			return
		
		# Acknowledge that this cannot be undone
		print("This cannot be undone")
		confirm = input("Are you really really sure? (y/n): ")
		if confirm != "y":
			return

		# Clean the environment
		os.system("limactl stop devenv")
		os.system("limactl delete devenv")
		os.system("rm devenv.final.yaml")

class ShellCmd:
	def setup(self, parser):
		shell_parser = parser.add_parser('shell', help='Open shell in the environment')
		self.setup_done = True

	def run(self, options):
		if not self.setup_done:
			raise Exception("Setup not done")

		# Open shell in the environment
		os.system("limactl shell devenv")

class StopCmd:
	def setup(self, parser):
		stop_parser = parser.add_parser('stop', help='Stop the environment')
		self.setup_done = True

	def run(self, options):
		if not self.setup_done:
			raise Exception("Setup not done")

		# Stop the environment
		os.system("limactl stop devenv")

class StatusCmd:
	def setup(self, parser):
		status_parser = parser.add_parser('status', help='Show status of the environment')
		self.setup_done = True

	def run(self, options):
		if not self.setup_done:
			raise Exception("Setup not done")

		# Show status of the environment
		os.system("limactl list")

def main():
	parser = ArgParser(
		prog='devenv',
		description='Utkarsh\'s Linux development environment',
	)

	startcmd = StartCmd()
	parser.register_command("start", startcmd)

	cleancmd = CleanCmd()
	parser.register_command("clean", cleancmd)

	shellcmd = ShellCmd()
	parser.register_command("shell", shellcmd)

	stopcmd = StopCmd()
	parser.register_command("stop", stopcmd)

	statuscmd = StatusCmd()
	parser.register_command("status", statuscmd)

	parser.parse()

if __name__ == "__main__":
    main()
