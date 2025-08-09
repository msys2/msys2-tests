#!/bin/bash

set -e

export GIT_COMMITTER_NAME="Test User"
export GIT_COMMITTER_EMAIL="test@example.com"
export GIT_AUTHOR_NAME="Test User"
export GIT_AUTHOR_EMAIL="test@example.com"

git --version

# some random git actions to smoketest git
rm -rf _tmp_repo _tmp_cloned
mkdir _tmp_repo
cd _tmp_repo
git init --initial-branch=main
echo "Test content" > test.txt
git add test.txt
git commit -m "Add test.txt"
git branch test_branch
git checkout test_branch
echo "New content" >> test.txt
git commit -am "Modify test.txt in test_branch"
git checkout main
git merge test_branch -m "Merge test_branch to main"
git log
git tag v1.0
cd ..
git clone _tmp_repo _tmp_cloned
cd _tmp_cloned
git fetch origin
git checkout -b new_feature
git push origin new_feature
git rebase main
echo "Amended content" >> test.txt
git commit --amend --no-edit
git checkout main
cd ..
rm -rf _tmp_repo _tmp_cloned
