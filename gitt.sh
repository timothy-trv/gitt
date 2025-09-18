#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

branch_ls() {
  COUNTER=0

  git branch | grep "$1" | while read -r BRANCH_NAME; do
    echo -e "$((COUNTER+1))) ${GREEN}${BRANCH_NAME}${NC}"
    COUNTER=$((COUNTER+1))
  done
}

branch_rm() {
  BRANCH_PATTERN="$1"
  branch_ls "$BRANCH_PATTERN"
  read -r -p "Do you want to delete above branches? [y/N] " DELETE_ALL

  if [[ "$DELETE_ALL" == "y" ]]; then

    git branch | grep "$BRANCH_PATTERN" | while read -r BRANCH_NAME; do
      git branch -D "$BRANCH_NAME"
      echo -e "${RED}${BRANCH_NAME}${NC} Deleted!"
    done

  else
    echo "Skipped!"
  fi
}

case $1 in
  "ls")
    branch_ls $2
    ;;
  "rm")
    branch_rm $2
    ;;
  *)
    echo "Unknown operation: $1"
    exit 1
    ;;
esac
