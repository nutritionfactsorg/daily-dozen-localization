#!/bin/sh
### FILE: MeldDroid_Base_Source_EN_US.sh

###################
### Environment ###
# alias meld="/Applications/Meld.app/Contents/MacOS/Meld "
# export NF_DROID_RES="$PATH_TO/daily-dozen-android/app/src/main/res"
# export NF_LOCALE_SCRIPTS_MAC = $PATH_TO/daily-dozen-localization/Utilities/Scripts/macos

###################
### Description ###
###

#############
### Usage ###
# cd "$NF_LOCALE_SCRIPTS_MAC"
# ./MeldDroid_Base_Source_EN_US.sh
#

SCRIPT_DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
LANGUAGES="$SCRIPT_DIR/../../../Languages"

BASE="$LANGUAGES/English_US/android/values/strings_WithoutTranslatableFalse.xml"

##################
### English_US ###
$MELD "$BASE" "$NF_DROID_RES/values/strings.xml"
