#!/bin/bash -e

# use as `./util.sh 'commit msg'`
git commit -m "$@"; git commit --amend --reuse-message=HEAD;

#git reset $(git commit-tree HEAD^{tree} -m $2);
