#!/bin/bash

. `dirname $0`/demo.conf

PUSHD ${JBOSS_HOME}
    bin/standalone.sh
POPD
