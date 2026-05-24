#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash jq nix-prefetch-git
set -exuo pipefail

info() { printf "\033[36m[INFO]\033[0m: %s\n" "$@"; }
warn() { printf "\033[33m[WARN]\033[0m: %s\n" "$@"; }
die() { printf "\033[31m[ERROR]\033[0m: %s\n" "$@"; exit 1; }

test $# -eq 1 || die "no version supplied"
Version="$1"
[[ $Version == v* ]] || die "versions should start with v"
BareVersion="${Version:1}"

# Sanity checks
test -f package.nix
test -d tdesktop/cur
test -d ../tdesktop
test -f ../tdesktop/run-in-docker.sh

#### Update upstream versions for packages ####
Hash=$(
    nix-prefetch-git \
        --url "https://github.com/telegramdesktop/tdesktop" \
        --rev "$Version" \
        --fetch-submodules \
        --no-add-path \
    | jq .hash
)

sed -i -E -f - .github/workflows/bincache.yml <<EOF
/ref:/s/: .*$/: $Version/
/# Upstream version/s/=.* #/=$BareVersion #/
EOF
sed -i -E -f - package.nix <<EOF
/rev/s/".*"/"$Version"/
/hash/s|"sha256-.*"|$Hash|
EOF
git add .github/workflows/bincache.yml package.nix

info 'Flatpak permissions might have been changed.' \
    'Check https://github.com/flathub/org.telegram.desktop for changes' \
    'and apply these to local flatpak manifest.' \
    'Once finished, press enter to add changes.'
read -r _confirmation
git add flatpak/io.github.yukigram.yml

git commit -m "tdesktop/$Version: packaging"

#### Update the patchset ####
pushd ../tdesktop

# Reset to the clean slate
git fetch --all
git reset --hard "$Version"
git submodule update --init --recursive
../yukigram/s/flatten.sh

# Apply patches and fix conflicts
if ! git am -3 ../yukigram/tdesktop; then
    while
        info 'Fix conflicts and exit the shell to continue applying'
        bash -i || true
        git am --continue
    do
        :
    done
fi

# Update centos_env
info 'Telegram might have released a new `centos_env` image' \
    'Find the correct version from and enter it here' \
    'Versions: https://github.com/telegramdesktop/tdesktop/pkgs/container/tdesktop%2Fcentos_env/versions'
while
    read -r Hash;
    [[ $Hash != sha256:???????????????????????????????????????????????????????????????? ]]
do
    warn 'This does not look like a hash to me. Try again'
done
sed -i -E -f - run-in-docker.sh <<EOF
/centos_env/s/sha256:.* /$Hash /
EOF
git add run-in-docker.sh
git commit --fixup 'HEAD^{/Yukigram) Build support}' --allow-empty
../yukigram/s/rebase.sh

# Clean up patches directory in case patches were dropped
find ../yukigram/tdesktop/cur/ -name '*.patch' -delete
../yukigram/s/format-patch.sh
popd
git add tdesktop/cur/
git commit -m "tdesktop/$Version: patches"
