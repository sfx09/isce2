#!/usr/bin/env bash

cat pkglist | xargs sudo apt install -y

pip3 install asf_search
pip3 install pulp
