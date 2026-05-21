#!/usr/bin/env bash
set -x
git rebase --autosquash HEAD^{/#flatten} "$@"
# Use of `HEAD^{/#flatten}` is needed
# to make commands version-independent,
# and to avoid rebasing over "submodule flattening"
# which, if done, yields weird warnings
# about submodule directories not being empty.
