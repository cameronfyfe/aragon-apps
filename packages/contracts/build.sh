#!/usr/bin/env bash

set -xeu

apps=$(make --f ../../Makefile list-apps)

for app in $apps; do
  cp -ar ../../apps/$app/contracts $app
done
