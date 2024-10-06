#!/usr/bin/env bash

apt-get update
xargs apt-get install -y < pkglist
