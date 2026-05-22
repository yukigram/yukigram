#!/usr/bin/env bash
set -exuo pipefail

die() { printf "\033[31m[ERROR]\033[0m: %s\n" "$@"; exit 1; }

test $# -eq 1 || die "no version supplied"
VERSION="$1"
[[ $VERSION == v* ]] || die "versions should start with v"
BARE_VERSION="${VERSION:1}"
[[ $VERSION == *-* ]] && DEVEL=true || DEVEL=false
[[ $DEVEL == true ]] && APP_ID=io.github.yukigram.devel || APP_ID=io.github.yukigram

# Sanity checks
test -f package.nix
test -d tdesktop/cur
test -d ../tdesktop
test -f ../tdesktop/run-in-docker.sh

sed -i -E -f - package.nix <<EOF
/version =/s/".*"/"$BARE_VERSION"/
/"DEVEL"/s/true|false/$DEVEL/
/mainProgram =/s/".*"/"$APP_ID"/
EOF

sed -i -E -f - flatpak/io.github.yukigram.yml <<EOF
s/io.github.yukigram(.devel)?/$APP_ID/
EOF

pushd ../tdesktop
sed -i -E -f - Telegram/SourceFiles/boxes/about_box.cpp <<EOF
/box->setTitle/s/: ".*"/: "$VERSION"/
EOF
git add Telegram/SourceFiles/boxes/about_box.cpp
git commit --fixup 'HEAD^{/Yukigram) Version}' --allow-empty
../yukigram/s/rebase.sh
../yukigram/s/format-patch.sh
popd

git add package.nix flatpak/io.github.yukigram.yml tdesktop/cur/????-Yukigram-Version.patch
git commit -m "$VERSION"
git tag -m "$VERSION" "$VERSION"
