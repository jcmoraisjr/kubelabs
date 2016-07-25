#!/bin/sh
set -e

echo "Copying plugins from $1"

baseUrl=${baseUrl:-http://updates.jenkins.io/download/plugins}
dir=/usr/share/jenkins/plugins
mkdir -p "$dir"

sed '/^#/d;/^[ \t]*$/d' "$1" | while IFS=: read -r plugin version status; do
  dest=${dir}/${plugin}.jpi
  url=${baseUrl}/${plugin}/${version}/${plugin}.hpi
  printf '%12s => %s [%s] -- %s\n' "$plugin" "$version" "$status" "$url"
  wget -qO"$dest" "$url"
  unzip -qp "$dest" > /dev/null
#  echo "$(wget -qO- ${url}.sha1)  $dest" | sha1sum -cs -
  case "-$status" in
    -) ;;
    -pinned) touch ${dest}.pinned ;;
    *) echo "Invalid status: $status"; exit 1 ;;
  esac
done
rm -fv "$1"
