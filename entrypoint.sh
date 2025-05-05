#!/bin/bash
set -eo pipefail

xo deployment start

xo bundle pull
tar -xzf bundle.tar.gz