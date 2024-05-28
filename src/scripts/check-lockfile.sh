#!/bin/bash

if [ ! -f "package-lock.json" ] && [ ! -f "pnpm-lock.yaml" ]; then
  echo "Lockfile not found"

  exit 1
fi
