#!/bin/sh

###################################
### FILE: InitializeDroidXML.sh ###
###################################
### Populates initial android/values-* with English strings.xml for new languages. 

SCRIPT_DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
LANGUAGES="$SCRIPT_DIR/../../../Languages"

## Existing 

#mkdir "$LANGUAGES/Bulgarian/android/values-bg"
#mkdir "$LANGUAGES/Chinese_Traditional/android/values-zh"
#mkdir "$LANGUAGES/English_GB/android/values-en-rGB"
#mkdir "$LANGUAGES/English_US/android/values"
#mkdir "$LANGUAGES/French/android/values-fr"
#mkdir "$LANGUAGES/German/android/values-de"
#mkdir "$LANGUAGES/Greek/android/values-el"
#mkdir "$LANGUAGES/Hungarian/android/values-hu"
#mkdir "$LANGUAGES/Italian/android/values-it"
#mkdir "$LANGUAGES/Japanese/android/values-ja"
#mkdir "$LANGUAGES/Portuguese/android/values-pt"
#mkdir "$LANGUAGES/Romanian/android/values-ro"
#mkdir "$LANGUAGES/Russian/android/values-ru"
#mkdir "$LANGUAGES/Spanish/android/values-es"

## New translations

mkdir "$LANGUAGES/Afrikaans/android/values-af"
mkdir "$LANGUAGES/Arabic/android/values-ar"
mkdir "$LANGUAGES/Bhojpuri/android/values-bho"
mkdir "$LANGUAGES/Chinese_HongKong/android/values-zh-HK"
mkdir "$LANGUAGES/Chinese_Simplified/android/values-zh-Hans"
mkdir "$LANGUAGES/Czech/android/values-cs"
mkdir "$LANGUAGES/Danish/android/values-da"
mkdir "$LANGUAGES/Dutch/android/values-nl"
mkdir "$LANGUAGES/Estonian/android/values-et"
mkdir "$LANGUAGES/Finnish/android/values-fi"
mkdir "$LANGUAGES/French_Canada/android/values-fr-CA"
mkdir "$LANGUAGES/Georgian/android/values-ka"
mkdir "$LANGUAGES/Hebrew/android/values-he"
mkdir "$LANGUAGES/Hindi/android/values-hi"
mkdir "$LANGUAGES/Kannada/android/values-kn"
mkdir "$LANGUAGES/Korean/android/values-ko"
mkdir "$LANGUAGES/Lithuanian/android/values-lt"
mkdir "$LANGUAGES/Mongolian/android/values-mn"
mkdir "$LANGUAGES/Norwegian_nb/android/values-nb"
mkdir "$LANGUAGES/Persian/android/values-fa"
mkdir "$LANGUAGES/Polish/android/values-pl"
mkdir "$LANGUAGES/Portuguese_Brazil/android/values-pt-BR"
mkdir "$LANGUAGES/Portuguese_Portugal/android/values-pt-PT"
mkdir "$LANGUAGES/Serbian_Cyrillic/android/values-sr"
mkdir "$LANGUAGES/Serbian_Latin/android/values-sr-Latn"
mkdir "$LANGUAGES/Slovak/android/values-sk"
mkdir "$LANGUAGES/Slovenian/android/values-sl"
mkdir "$LANGUAGES/Swedish/android/values-sv"
mkdir "$LANGUAGES/Thai/android/values-th"
mkdir "$LANGUAGES/Turkish/android/values-tr"
mkdir "$LANGUAGES/Vietnamese/android/values-vi"

# Replicate English XML
BASE_DROID_XML="$LANGUAGES/English_US/android/values/strings.xml"

cp "$BASE_DROID_XML" "$LANGUAGES/Afrikaans/android/values-af"
cp "$BASE_DROID_XML" "$LANGUAGES/Arabic/android/values-ar"
cp "$BASE_DROID_XML" "$LANGUAGES/Bhojpuri/android/values-bho"
cp "$BASE_DROID_XML" "$LANGUAGES/Chinese_HongKong/android/values-zh-HK"
cp "$BASE_DROID_XML" "$LANGUAGES/Chinese_Simplified/android/values-zh-Hans"
cp "$BASE_DROID_XML" "$LANGUAGES/Czech/android/values-cs"
cp "$BASE_DROID_XML" "$LANGUAGES/Danish/android/values-da"
cp "$BASE_DROID_XML" "$LANGUAGES/Dutch/android/values-nl"
cp "$BASE_DROID_XML" "$LANGUAGES/Estonian/android/values-et"
cp "$BASE_DROID_XML" "$LANGUAGES/Finnish/android/values-fi"
cp "$BASE_DROID_XML" "$LANGUAGES/French_Canada/android/values-fr-CA"
cp "$BASE_DROID_XML" "$LANGUAGES/Georgian/android/values-ka"
cp "$BASE_DROID_XML" "$LANGUAGES/Hebrew/android/values-he"
cp "$BASE_DROID_XML" "$LANGUAGES/Hindi/android/values-hi"
cp "$BASE_DROID_XML" "$LANGUAGES/Kannada/android/values-kn"
cp "$BASE_DROID_XML" "$LANGUAGES/Korean/android/values-ko"
cp "$BASE_DROID_XML" "$LANGUAGES/Lithuanian/android/values-lt"
cp "$BASE_DROID_XML" "$LANGUAGES/Mongolian/android/values-mn"
cp "$BASE_DROID_XML" "$LANGUAGES/Norwegian_nb/android/values-nb"
cp "$BASE_DROID_XML" "$LANGUAGES/Persian/android/values-fa"
cp "$BASE_DROID_XML" "$LANGUAGES/Polish/android/values-pl"
cp "$BASE_DROID_XML" "$LANGUAGES/Portuguese_Brazil/android/values-pt-BR"
cp "$BASE_DROID_XML" "$LANGUAGES/Portuguese_Portugal/android/values-pt-PT"
cp "$BASE_DROID_XML" "$LANGUAGES/Serbian_Cyrillic/android/values-sr"
cp "$BASE_DROID_XML" "$LANGUAGES/Serbian_Latin/android/values-sr-Latn"
cp "$BASE_DROID_XML" "$LANGUAGES/Slovak/android/values-sk"
cp "$BASE_DROID_XML" "$LANGUAGES/Slovenian/android/values-sl"
cp "$BASE_DROID_XML" "$LANGUAGES/Swedish/android/values-sv"
cp "$BASE_DROID_XML" "$LANGUAGES/Thai/android/values-th"
cp "$BASE_DROID_XML" "$LANGUAGES/Turkish/android/values-tr"
cp "$BASE_DROID_XML" "$LANGUAGES/Vietnamese/android/values-vi"
