#!/usr/bin/env bash
set -euo pipefail

platform="${1:?usage: refresh-native-sdk.sh ios|android}"
case "$platform" in
  ios|android) ;;
  *) echo "Unknown native SDK: $platform" >&2; exit 2 ;;
esac

package_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
sdk_dir="$package_root/native/imsdk-$platform"
url="https://github.com/bitcomputing/imsdk-$platform.git"

if [[ ! -e "$sdk_dir/.git" ]]; then
  if [[ -d "$sdk_dir" && -n "$(ls -A "$sdk_dir")" ]]; then
    echo "Cannot update $sdk_dir: existing files are not a Git checkout. Reinstall the package, then rebuild." >&2
    exit 1
  fi
  git clone --depth 1 --branch master --single-branch "$url" "$sdk_dir"
fi

if [[ -n "$(git -C "$sdk_dir" status --porcelain)" ]]; then
  echo "Cannot update $sdk_dir: local SDK changes are present. Commit or stash them first." >&2
  exit 1
fi

git -C "$sdk_dir" fetch "$url" refs/heads/master
git -C "$sdk_dir" checkout --detach FETCH_HEAD
printf '%s SDK: %s\n' "$platform" "$(git -C "$sdk_dir" rev-parse HEAD)"
