#!/bin/bash -e

# use as `./util.sh 'commit msg'`
git commit -m "$@";git commit --amend --reuse-message=HEAD;
