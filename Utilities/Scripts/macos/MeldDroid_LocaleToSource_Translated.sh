#!/bin/sh

### cd /to-this-directory/Tools/Scripts/macos
### ./MeldDroid_LocaleToSource_Translated.sh
###
### Environment setup:
# export NF_ANDROID_RESOURCES='/PATH/TO/daily-dozen-android/app/src/main/res'

SCRIPT_DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
LANGUAGES="$SCRIPT_DIR/../../../Languages"
MELD="/Applications/Meld.app/Contents/MacOS/Meld"

$MELD "$NF_ANDROID_RESOURCES/values/strings.xml" "$LANGUAGES/English_US/android/values/strings.xml"

#$MELD "$NF_ANDROID_RESOURCES/values-af/strings.xml" "$LANGUAGES/Afrikaans/android/values-af/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-ar/strings.xml" "$LANGUAGES/Arabic/android/values-ar/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-bho/strings.xml" "$LANGUAGES/Bhojpuri/android/values-bho/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-bg/strings.xml" "$LANGUAGES/Bulgarian/android/values-bg/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-zh-HK/strings.xml" "$LANGUAGES/Chinese_HongKong/android/values-zh-HK/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-zh-Hans/strings.xml" "$LANGUAGES/Chinese_Simplified/android/values-zh-Hans/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-zh/strings.xml" "$LANGUAGES/Chinese_Traditional/android/values-zh/strings.xml" # Traditional _Hant
#$MELD "$NF_ANDROID_RESOURCES/values-cs/strings.xml" "$LANGUAGES/Czech/android/values-cs/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-da/strings.xml" "$LANGUAGES/Danish/android/values-da/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-nl/strings.xml" "$LANGUAGES/Dutch/android/values-nl/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-rGB/strings.xml" "$LANGUAGES/English_GB/android/values-en-rGB/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-et/strings.xml" "$LANGUAGES/Estonian/android/values-et/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-fi/strings.xml" "$LANGUAGES/Finnish/android/values-fi/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-fr/strings.xml" "$LANGUAGES/French/android/values-fr/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-fr-CA/strings.xml" "$LANGUAGES/French_Canada/android/values-fr-CA/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-ka/strings.xml" "$LANGUAGES/Georgian/android/values-ka/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-de/strings.xml" "$LANGUAGES/German/android/values-de/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-el/strings.xml" "$LANGUAGES/Greek/android/values-el/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-he/strings.xml" "$LANGUAGES/Hebrew/android/values-he/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-hi/strings.xml" "$LANGUAGES/Hindi/android/values-hi/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-hu/strings.xml" "$LANGUAGES/Hungarian/android/values-hu/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-it/strings.xml" "$LANGUAGES/Itialian/android/values-it/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-ja/strings.xml" "$LANGUAGES/Japanese/android/values-ja/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-kn/strings.xml" "$LANGUAGES/Kannada/android/values-kn/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-ko/strings.xml" "$LANGUAGES/Korean/android/values-ko/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-lt/strings.xml" "$LANGUAGES/Lithuanian/android/values-lt/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-mn/strings.xml" "$LANGUAGES/Mongolian/android/values-mn/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-nb/strings.xml" "$LANGUAGES/Norwegian_nb/android/values-nb/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-fa/strings.xml" "$LANGUAGES/Persian/android/values-fa/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-pl/strings.xml" "$LANGUAGES/Polish/android/values-pl/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-pt/strings.xml" "$LANGUAGES/Portuguese/android/values-pt/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-pt-BR/strings.xml" "$LANGUAGES/Portuguese_Brazil/android/values-pt-BR/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-pt-PT/strings.xml" "$LANGUAGES/Portuguese_Portugal/android/values-pt-PT/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-ro/strings.xml" "$LANGUAGES/Romanian/android/values-ro/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-ru/strings.xml" "$LANGUAGES/Russian/android/values-ru/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-sr/strings.xml" "$LANGUAGES/Serbian_Cyrillic/android/values-sr/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-sr-Latn/strings.xml" "$LANGUAGES/Serbian_Latin/android/values-sr-Latn/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-sk/strings.xml" "$LANGUAGES/Slovak/android/values-sk/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-sl/strings.xml" "$LANGUAGES/Slovenian/android/values-sl/strings.xml"
$MELD "$NF_ANDROID_RESOURCES/values-es/strings.xml" "$LANGUAGES/Spanish/android/values-es/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-sv/strings.xml" "$LANGUAGES/Swedish/android/values-sv/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-th/strings.xml" "$LANGUAGES/Thai/android/values-th/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-tr/strings.xml" "$LANGUAGES/Turkish/android/values-tr/strings.xml"
#$MELD "$NF_ANDROID_RESOURCES/values-vi/strings.xml" "$LANGUAGES/Vietnamese/android/values-vi/strings.xml"
