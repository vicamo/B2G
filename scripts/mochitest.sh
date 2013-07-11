#!/bin/bash

# Determine the absolute path of our location.
B2G_DIR=$(cd `dirname $0`/..; pwd)
. $B2G_DIR/setup.sh

# Use default Gecko location if it's not provided in .config.
if [ -z $GECKO_PATH ]; then
  GECKO_PATH=$B2G_DIR/gecko
fi

XRE_PATH=$B2G_DIR/gaia/xulrunner-sdk/bin
MOCHITEST_FLAGS+=" --b2gpath $B2G_DIR --xre-path $XRE_PATH"
MOCHITEST_FLAGS+=" --httpd-path $GECKO_OBJDIR/_tests/testing/mochitest"
USE_EMULATOR=yes

# Allow other marionette arguments to override the default --emulator argument
while [ $# -gt 0 ]; do
  case "$1" in
    --emulator=*)
      MOCHITEST_FLAGS+=" $1"
      USE_EMULATOR=no ;;
    --*)
      MOCHITEST_FLAGS+=" $1" ;;
    *)
      MOCHITEST_TESTS+=" $1" ;;
  esac
  shift
done

if [ "$USE_EMULATOR" = "yes" ]; then
  if [ "$DEVICE" = "generic_x86" ]; then
    ARCH=x86
  else
    ARCH=arm
  fi
  MOCHITEST_FLAGS+=" --emulator=$ARCH"
fi

echo "Running tests: $MOCHITEST_TESTS"

SCRIPT=$GECKO_PATH/testing/marionette/client/marionette/venv_mochitest.sh
PYTHON=`which python`

echo bash $SCRIPT "$PYTHON" $MOCHITEST_FLAGS $MOCHITEST_TESTS
bash $SCRIPT "$PYTHON" $MOCHITEST_FLAGS $MOCHITEST_TESTS
