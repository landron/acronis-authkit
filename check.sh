#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

start=$(date +%s)

GO=go
# GO=go1.20

# golangci-lint-v1:
#   ERRO Running error: context loading failed: no go files to analyze: running `go mod tidy` may solve the problem
$GO mod tidy

# ~15 files
# gofumpt -l -w ./
# gofumpt -l -w -extra ./

$GO build ./...
$GO test ./...

echo
golangci-lint-v1 run -v --timeout 600s

if false; then
    # 12 issues:
    # * goconst: 3
    # * gocritic: 3
    # * gosec: 2
    # * staticcheck: 4
    echo
    golangci-lint run -v --timeout 600s --config .golangci.v2.yml
fi

echo
echo "All checks passed successfully at $(date +'%H:%M:%S %d.%m')"
end=$(date +%s)
elapsed=$((end - start))
echo "Elapsed time: ${elapsed} seconds"
