#!/bin/bash

mkdir /tmp/2015-11-21
export ELEX_RECORDING=flat
export ELEX_LOGGING_DIR=/tmp/2015-11-21

dropdb elex
createdb elex