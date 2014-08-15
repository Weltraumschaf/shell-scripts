#!/bin/bash

LIST_FILE="${1}"

if [ "${LIST_FILE}" = "" ] ; then
  echo "Pleas give path to commit list file!"
  echo "Usage: cherry-pick-list <file/to/picklist>"
  exit 1
fi

echo "Cherry-picking all commits from file ${LIST_FILE} ..."

COUNT=1
IFS=$'\n'
for commit in $(cat "${LIST_FILE}") ; do
  hash=$(echo ${commit} | cut -d$'\t' -f 1)
  echo -n "cherry picking ${hash} ... "
  git cherry-pick "${hash}"

  if [ $? -eq 0 ] ; then
    echo "done."
  else
    echo "There are conflicts to resolve!"
    read -p "Press [ENTER] key if you have resolved the conflicts and to continue ..."
  fi

  COUNT=$((COUNT+1))
done

echo "Maybe you want to rebase: git rebase -i HEAD~${COUNT}"
