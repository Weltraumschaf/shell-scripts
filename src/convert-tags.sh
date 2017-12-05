#!/usr/bin/env bash

#
# Converts the SVN tags.
#
# Technically SVN tags are branches and therefore must be converted to git tags.
#
# See https://stackoverflow.com/questions/2244252/how-to-import-svn-branches-and-tags-into-git-svn
#

set -e
set -u

# Update repo.
#git svn fetch
#git svn rebase

echo "Clean up the repo ..."
git reflog expire --expire=now --all && git gc --prune=now --aggressive

# Since tags in svn are real branches, create git tags from tag branches.
git for-each-ref --format="%(refname:short) %(objectname)" refs/remotes/origin/tags | cut -d / -f 3- | while read ref
do
    echo "Import tag for ${ref} ..."
    git tag -a ${ref} -m 'import tag from svn'
done
echo "Import done."

# Delete tag branches.
echo "Delete tag branches ..."
git for-each-ref --format="%(refname:short)" refs/remotes/origin/tags | cut -d / -f 1- | while read ref
do 
    echo "Delete tag branch ${ref} ..."
    git branch -rd "${ref}"
done
echo "Branch deletion done."

# Since tags marked in the previous step point to a commit "create tag", we need to derive "real" tags, i.e. parents of "create tag" commits.
echo "Derive tags ..."
git for-each-ref --format="%(refname:short)" refs/tags | while read ref
do
    echo "Derive \"real\" tags from \"create tag\" commits ..."
    tag=`echo ${ref} | sed 's/_/./g'` # give tags a new name
    echo "${ref} -> ${tag}"
    git tag -a "${tag}" `git rev-list -2 ${ref} | tail -1` -m "proper svn tag"
done

echo 'Done: All tags converted'
