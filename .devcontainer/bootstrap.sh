#!/bin/bash
set -euo pipefail

cd /project

if [ ! -x "$HOME/venv/bin/python" ]; then
  make venv
fi

. "$HOME/venv/bin/activate"
make install
