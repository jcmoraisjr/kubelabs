#!/bin/sh
set -e

if [ $# -ne 0 ]; then
  exec "$@"
  exit 0
fi

cd /usr/share/jenkins
echo "--> Checking new files"
find . -type f | while IFS= read -r f; do
  src="${f#./}"
  dest="${JENKINS_HOME}/${src}"
  if [ ! -f "$dest" ]; then
    mkdir -p "$(dirname "$dest")"
    mv "$src" "$dest" 2> /dev/null
    echo "--> $src moved"
  fi
done

exec java -jar /jenkins.war
