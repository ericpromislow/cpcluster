#!/bin/sh
# Run a Ruby REPL.

set -e

cd $(dirname "$0")/..
exec ruby -S bin/pry -Ilib -r cpcluster -r rugged/cpcluster
