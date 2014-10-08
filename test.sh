#!/usr/bin/env bash
./logic.test.sh | diff logic.test.ref -
./size.test.sh | diff size.test.ref -
