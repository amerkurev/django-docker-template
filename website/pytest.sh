#!/bin/sh

# run pytest with coverage and check the exit code of pytest
if ! coverage run -m pytest;
then
    echo "Tests failed"
    exit 1
fi

coverage report -m

# if pass `coveralls` as argument, then send coverage report to coveralls.io
if [ "$1" == "coveralls" ]; then
    coveralls --service=github
fi
