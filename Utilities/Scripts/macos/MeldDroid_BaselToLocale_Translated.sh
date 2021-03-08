#!/bin/sh

### cd /to-this-directory/Tools/Scripts/macos
### ./MeldDroid_BaseToLocale_Translated.sh
###
### Environment setup:
# export NF_ANDROID_RESOURCES='/PATH/TO/daily-dozen-android/app/src/main/res'

SCRIPT_DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
LANGUAGES="$SCRIPT_DIR/../../../Languages"
MELD="/Applications/Meld.app/Contents/MacOS/Meld"

BASE="$LANGUAGES/English_US/android/values/strings_base_sans_NoTranslatableFalse.xml"

#############
##$MELD "$BASE" "$LANGUAGES/English_US/android/values/strings.xml"

#############
#$MELD "$BASE" "$LANGUAGES/Afrikaans/android/values-af/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Arabic/android/values-ar/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Bhojpuri/android/values-bho/strings.xml"
$MELD "$BASE" "$LANGUAGES/Bulgarian/android/values-bg/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Chinese_HongKong/android/values-zh-HK/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Chinese_Simplified/android/values-zh-Hans/strings.xml"
$MELD "$BASE" "$LANGUAGES/Chinese_Traditional/android/values-zh/strings.xml" # Traditional _Hant
#$MELD "$BASE" "$LANGUAGES/Czech/android/values-cs/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Danish/android/values-da/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Dutch/android/values-nl/strings.xml"
#$MELD "$BASE" "$LANGUAGES/English_GB/android/values-en-rGB/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Estonian/android/values-et/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Finnish/android/values-fi/strings.xml"
$MELD "$BASE" "$LANGUAGES/French/android/values-fr/strings.xml"
#$MELD "$BASE" "$LANGUAGES/French_Canada/android/values-fr-CA/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Georgian/android/values-ka/strings.xml"
$MELD "$BASE" "$LANGUAGES/German/android/values-de/strings.xml"
$MELD "$BASE" "$LANGUAGES/Greek/android/values-el/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Hebrew/android/values-he/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Hindi/android/values-hi/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Hungarian/android/values-hu/strings.xml"
$MELD "$BASE" "$LANGUAGES/Itialian/android/values-it/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Japanese/android/values-ja/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Kannada/android/values-kn/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Korean/android/values-ko/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Lithuanian/android/values-lt/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Mongolian/android/values-mn/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Norwegian_nb/android/values-nb/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Persian/android/values-fa/strings.xml"
$MELD "$BASE" "$LANGUAGES/Polish/android/values-pl/strings.xml"
$MELD "$BASE" "$LANGUAGES/Portuguese/android/values-pt/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Portuguese_Brazil/android/values-pt-BR/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Portuguese_Portugal/android/values-pt-PT/strings.xml"
$MELD "$BASE" "$LANGUAGES/Romanian/android/values-ro/strings.xml"
$MELD "$BASE" "$LANGUAGES/Russian/android/values-ru/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Serbian_Cyrillic/android/values-sr/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Serbian_Latin/android/values-sr-Latn/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Slovak/android/values-sk/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Slovenian/android/values-sl/strings.xml"
$MELD "$BASE" "$LANGUAGES/Spanish/android/values-es/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Swedish/android/values-sv/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Thai/android/values-th/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Turkish/android/values-tr/strings.xml"
#$MELD "$BASE" "$LANGUAGES/Vietnamese/android/values-vi/strings.xml"
