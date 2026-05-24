#!/usr/bin/env bash
set -exuo pipefail
# sanity check
test -f .gitmodules
test -d .git
# delete submodule traces
find -type f -\( -name .git -o -name .gitmodules -\) -delete
# delete config leftovers
<.git/config awk '/^\[/{s=0;} /^\[submodule/{s=1;} //{if (!s) print;}' | sponge .git/config
# force git to update index
rm .git/index
# commit the flattening
git add .
GIT_COMMITTER_NAME='Yukigram Automation' \
GIT_COMMITTER_EMAIL='github.com/yukigram' \
GIT_COMMITTER_DATE='1970-01-01T00:00:00Z' \
GIT_AUTHOR_NAME='Yukigram Automation' \
GIT_AUTHOR_EMAIL='github.com/yukigram' \
GIT_AUTHOR_DATE='1970-01-01T00:00:00Z' \
git commit --no-gpg-sign --no-verify --message '#flatten submodules'
