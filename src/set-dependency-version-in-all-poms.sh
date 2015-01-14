#!/bin/bash

# Usage: ./set-dependency-version-in-all-poms.sh "de.icongmbh.dopix.editor.commons.variables.model" "1.2.0-SNAPSHOT"
#
# Trägt überall für de.icongmbh.dopix.editor.commons.variables.model 1.2.0-SNAPSHOT als version ein.

for file in $(find . -name \*pom.xml)
do
  versionString="${1}.version"
  version="${2}"
  sed -i "s+<${versionString}>.*</${versionString}>+<${versionString}>${version}</${versionString}>+" $file
done
