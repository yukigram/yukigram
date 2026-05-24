#!/usr/bin/env bash
set -x
git format-patch --zero-commit -N -o ../yukigram/tdesktop/cur --base HEAD^{/#flatten}{^,}
# `--zero-commit` is needed
# to make first line of `.patch` files
# (the `From ... Mon Sep 17 00:00:00 2001` line)
# stable across rebases and reapplies.
#
# `-N` disables patch numbering,
# making `[PATCH 45/67]` in subject line
# become `[PATCH]`,
# which allows patches to be
# more stable across reorders and patch additions.
#
# `--base HEAD^{/#flatten}{^,}` sets
# - base commit to `HEAD^{/#flatten}^`,
#     i.e. the commit immediately preceding the submodule flattening
# - formatted commits range to `HEAD^{/#flatten}`,
#     i.e. all commits reachable from `HEAD`,
#     but not from `HEAD^{/#flatten}`,
#     or, in plain words,
#     everything after the submodule flattening.
