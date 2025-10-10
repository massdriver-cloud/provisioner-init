#!/bin/bash
set -eo pipefail

# Both of these commands do proper validation and error handling internally
xo deployment start
xo bundle pull