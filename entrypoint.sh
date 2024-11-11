#!/bin/bash
set -eo pipefail

xo deployment $MASSDRIVER_DEPLOYMENT_ACTION start

xo bundle pull
tar -xzf bundle.tar.gz