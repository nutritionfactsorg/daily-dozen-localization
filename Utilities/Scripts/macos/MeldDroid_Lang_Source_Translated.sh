#!/bin/sh
### FILE: MeldDroid_Locale_Source_Translated.sh

#############################
### Environment Variables ###
# alias meld="/Applications/Meld.app/Contents/MacOS/Meld "
# export NF_DROID_RES="/$NF_PATH_TO/daily-dozen-android/app/src/main/res"
# export NF_LOCALE_SCRIPTS_MAC = $PATH_TO/daily-dozen-localization/Utilities/Scripts/macos

#############
### Usage ###
# cd "$NF_LOCALE_SCRIPTS_MAC"
# ./MeldDroid_Locale_Source_Translated.sh
#

SCRIPT_DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
LANGUAGES="$SCRIPT_DIR/../../../Languages"

##################
### English_US ###
$MELD "$NF_DROID_RES/values/strings.xml" "$LANGUAGES/English_US/android/values/strings.xml"

####################
### Translations ###
#$MELD "$NF_DROID_RES/values-af/strings.xml" "$LANGUAGES/Afrikaans/android/values-af/strings.xml"
#$MELD "$NF_DROID_RES/values-ar/strings.xml" "$LANGUAGES/Arabic/android/values-ar/strings.xml"
#$MELD "$NF_DROID_RES/values-bho/strings.xml" "$LANGUAGES/Bhojpuri/android/values-bho/strings.xml"
$MELD "$NF_DROID_RES/values-bg/strings.xml" "$LANGUAGES/Bulgarian/android/values-bg/strings.xml"
#$MELD "$NF_DROID_RES/values-zh-HK/strings.xml" "$LANGUAGES/Chinese_HongKong/android/values-zh-HK/strings.xml"
#$MELD "$NF_DROID_RES/values-zh-Hans/strings.xml" "$LANGUAGES/Chinese_Simplified/android/values-zh-Hans/strings.xml"
$MELD "$NF_DROID_RES/values-zh/strings.xml" "$LANGUAGES/Chinese_Traditional/android/values-zh/strings.xml" # Traditional _Hant
#$MELD "$NF_DROID_RES/values-cs/strings.xml" "$LANGUAGES/Czech/android/values-cs/strings.xml"
#$MELD "$NF_DROID_RES/values-da/strings.xml" "$LANGUAGES/Danish/android/values-da/strings.xml"
#$MELD "$NF_DROID_RES/values-nl/strings.xml" "$LANGUAGES/Dutch/android/values-nl/strings.xml"
#$MELD "$NF_DROID_RES/values-rGB/strings.xml" "$LANGUAGES/English_GB/android/values-en-rGB/strings.xml"
#$MELD "$NF_DROID_RES/values-et/strings.xml" "$LANGUAGES/Estonian/android/values-et/strings.xml"
#$MELD "$NF_DROID_RES/values-fi/strings.xml" "$LANGUAGES/Finnish/android/values-fi/strings.xml"
$MELD "$NF_DROID_RES/values-fr/strings.xml" "$LANGUAGES/French/android/values-fr/strings.xml"
#$MELD "$NF_DROID_RES/values-fr-CA/strings.xml" "$LANGUAGES/French_Canada/android/values-fr-CA/strings.xml"
#$MELD "$NF_DROID_RES/values-ka/strings.xml" "$LANGUAGES/Georgian/android/values-ka/strings.xml"
$MELD "$NF_DROID_RES/values-de/strings.xml" "$LANGUAGES/German/android/values-de/strings.xml"
$MELD "$NF_DROID_RES/values-el/strings.xml" "$LANGUAGES/Greek/android/values-el/strings.xml"
#$MELD "$NF_DROID_RES/values-he/strings.xml" "$LANGUAGES/Hebrew/android/values-he/strings.xml"
#$MELD "$NF_DROID_RES/values-hi/strings.xml" "$LANGUAGES/Hindi/android/values-hi/strings.xml"
#$MELD "$NF_DROID_RES/values-hu/strings.xml" "$LANGUAGES/Hungarian/android/values-hu/strings.xml"
$MELD "$NF_DROID_RES/values-it/strings.xml" "$LANGUAGES/Italian/android/values-it/strings.xml"
#$MELD "$NF_DROID_RES/values-ja/strings.xml" "$LANGUAGES/Japanese/android/values-ja/strings.xml"
#$MELD "$NF_DROID_RES/values-kn/strings.xml" "$LANGUAGES/Kannada/android/values-kn/strings.xml"
#$MELD "$NF_DROID_RES/values-ko/strings.xml" "$LANGUAGES/Korean/android/values-ko/strings.xml"
#$MELD "$NF_DROID_RES/values-lt/strings.xml" "$LANGUAGES/Lithuanian/android/values-lt/strings.xml"
#$MELD "$NF_DROID_RES/values-mn/strings.xml" "$LANGUAGES/Mongolian/android/values-mn/strings.xml"
#$MELD "$NF_DROID_RES/values-nb/strings.xml" "$LANGUAGES/Norwegian_nb/android/values-nb/strings.xml"
#$MELD "$NF_DROID_RES/values-fa/strings.xml" "$LANGUAGES/Persian/android/values-fa/strings.xml"
$MELD "$NF_DROID_RES/values-pl/strings.xml" "$LANGUAGES/Polish/android/values-pl/strings.xml"
$MELD "$NF_DROID_RES/values-pt/strings.xml" "$LANGUAGES/Portuguese/android/values-pt/strings.xml"
#$MELD "$NF_DROID_RES/values-pt-BR/strings.xml" "$LANGUAGES/Portuguese_Brazil/android/values-pt-BR/strings.xml"
#$MELD "$NF_DROID_RES/values-pt-PT/strings.xml" "$LANGUAGES/Portuguese_Portugal/android/values-pt-PT/strings.xml"
$MELD "$NF_DROID_RES/values-ro/strings.xml" "$LANGUAGES/Romanian/android/values-ro/strings.xml"
$MELD "$NF_DROID_RES/values-ru/strings.xml" "$LANGUAGES/Russian/android/values-ru/strings.xml"
#$MELD "$NF_DROID_RES/values-sr/strings.xml" "$LANGUAGES/Serbian_Cyrillic/android/values-sr/strings.xml"
#$MELD "$NF_DROID_RES/values-sr-Latn/strings.xml" "$LANGUAGES/Serbian_Latin/android/values-sr-Latn/strings.xml"
#$MELD "$NF_DROID_RES/values-sk/strings.xml" "$LANGUAGES/Slovak/android/values-sk/strings.xml"
#$MELD "$NF_DROID_RES/values-sl/strings.xml" "$LANGUAGES/Slovenian/android/values-sl/strings.xml"
$MELD "$NF_DROID_RES/values-es/strings.xml" "$LANGUAGES/Spanish/android/values-es/strings.xml"
#$MELD "$NF_DROID_RES/values-sv/strings.xml" "$LANGUAGES/Swedish/android/values-sv/strings.xml"
#$MELD "$NF_DROID_RES/values-th/strings.xml" "$LANGUAGES/Thai/android/values-th/strings.xml"
#$MELD "$NF_DROID_RES/values-tr/strings.xml" "$LANGUAGES/Turkish/android/values-tr/strings.xml"
#$MELD "$NF_DROID_RES/values-vi/strings.xml" "$LANGUAGES/Vietnamese/android/values-vi/strings.xml"
