#!/usr/bin/env bash
set -ex

echo -e "${USERNAME}:$(perl -le 'print crypt($ENV{"PASSWORD"}, rand(0xffffffff));')" > /app/config/basic.htpasswd
