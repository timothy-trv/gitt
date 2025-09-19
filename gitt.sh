#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

branch_ls() {
  local counter=0

  git branch | grep "$1" | while read -r branch_name; do
    echo -e "$((counter+1))) ${GREEN}${branch_name}${NC}"
    counter=$((counter+1))
  done
}

branch_rm() {
  if [ -z "$1" ]; then
    echo -e "${RED}ERROR${NC}: Please provide the pattern."
    exit 1
  fi

  local pattern="$1"
  branch_ls "$pattern"
  read -r -p "Do you want to delete above branches? [y/N] " delete_all

  if [[ "$delete_all" == "y" ]]; then

    git branch | grep "$pattern" | while read -r branch_name; do
      git branch -D "$branch_name"
      echo -e "${RED}${branch_name}${NC} Deleted!"
    done

  else
    echo "Skipped!"
  fi
}

checkout_remote() {
  local changes_count=$(echo $(git status -s | wc -l))

  if [ "$changes_count" != "0" ]; then
    echo -e "${RED}ERROR${NC}: Please commit your local changes first."
    exit 1
  fi

  local branch_name="$2"
  git fetch "$1" "$branch_name" && git checkout "$branch_name"
}

case $1 in
  "ls")
    branch_ls "${@:2}"
    ;;
  "rm")
    branch_rm "${@:2}"
    ;;
  "cr")
    checkout_remote "${@:2}"
    ;;
  *)
    git "$@"
    ;;
esac
