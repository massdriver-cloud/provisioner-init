#!/bin/bash
set -eo pipefail

xo deployment start

xo bundle pull


if [[ -n "${MASSDRIVER_BUNDLE_VERSION:-}" ]]; then
  xo bundle pull
else
  xo bundle pullv0
  tar -xzf bundle.tar.gz
fi