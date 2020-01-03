#!/usr/bin/env bash

set -e
set -u

rm -rfv "/cygdrive/c/TACO-IDE/workspaces/default-workspace/.metadata/.plugins/org.eclipse.pde.core/.bundle_pool"
rm -rfv "/cygdrive/c/Documents and Settings/sst/.p2"
rm -rfv "/home/sst/.m2/repository"
