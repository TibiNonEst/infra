#!/usr/bin/env bash
set -eou pipefail

version=0.1.0

# Changelog:
# v0.1.0 - active development

# Current exit modes:
# 0 - success
# 1 - no verb specified

me=$(basename $0)
sudo=${NUH_SUDO:-sudo}
dir=${NUH_DIR:-~/infra}

verb=$1
shift

function help() {
	cat 1>&2 <<EOF
nuh v$version - the NixOS Update Helper
Usage: $me <verb> [arguments]

Current infrastructure directory: $dir

Verbs:
  search [query] - find a package by keyword(s)
  update         - update the system flake
  upgrade        - update the system flake and rebuild the system
  clean          - clean up unused and cached files
  shrink         - save space by hard-linking files
  try [package]  - try out a new package in an ephemral shell
  show           - show a tree view of your current infra directory
  edit [module]  - edit a file in your infra directory
  help           - print this help
  version        - print the version number

EOF
}

# Meta
case "$verb" in
	'')
		help
		echo "$me: a verb is required" 1>&2
		exit 1
		;;
	help|h|\?|-\?|-h|-help|--help)
		help
		exit 0
		;;
	version|v|-v|-version|--version)
		echo "nuh v$version"
		exit 0
		;;
esac

# Acions
case "$verb" in
	search|query)
		exec nix search "nixpkgs#legacyPackages.x86_64-linux" "$@"
		;;
	update)
		cd $dir
		exec $sudo nix flake update --no-warn-dirty "$@"
		;;
	switch|s)
		cd $dir
		rm -f ~/.cache/tofi-drun # Grrrrr Tofi needs this to be cleared
		exec nh os switch /home/tibs/infra "$@"
		;;
	upgrade|up|u)
		exec $0 switch --update
		;;
	clean|gc)
		exec nh clean all "$@"
		;;
	shrink|optimise|optimize)
		exec $sudo nix store optimise "$@"
		;;
	try|t)
		str=""
		for package in "$@"; do
			str+="nixpkgs#$package "
		done
		exec nix shell $str
		;;
	show)
		exec eza --tree $dir "$@"
		;;
	edit|e)
		exec $EDITOR "$dir/$@"
		;;

	# Easter eggs
	uh)
		echo "yuh-uh !"
		exit 0
		;;

	# Catch-all
	*)
		echo "$me: unknown verb: $verb" 1>&2
		exit 1
		;;
esac
