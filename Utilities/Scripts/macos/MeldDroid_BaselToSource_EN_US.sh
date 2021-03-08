#!/bin/sh

### cd /to-this-directory/Tools/Scripts/macos
### ./MeldDroid_BaselToSource_EN_US.sh
###
### Environment setup:
# export NF_ANDROID_RESOURCES='/PATH/TO/daily-dozen-android/app/src/main/res'

SCRIPT_DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
LANGUAGES="$SCRIPT_DIR/../../../Languages"
MELD="/Applications/Meld.app/Contents/MacOS/Meld"

BASE="$LANGUAGES/English_US/android/values/strings_base_sans_NoTranslatableFalse.xml"

#############
$MELD "$BASE" "$NF_ANDROID_RESOURCES/values/strings.xml"
