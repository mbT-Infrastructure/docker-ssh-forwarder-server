#!/usr/bin/env bash
set -e -o pipefail

nc -z 127.0.0.1 22 || exit 1
