#!/bin/sh
### FILE: compare_base_temp_xml.sh

### Use: update untranslated languages using on the English_US base Android XML

BASE="$NF_LOCALE_LANG_BASE/android/values/strings_WithoutTranslatableFalse.xml"

#############
## Leave untranslated locales uncommented. Comment out translated locales.
#############
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Afrikaans/android/values-af/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Arabic/android/values-ar/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Bhojpuri/android/values-bho/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Bulgarian/android/values-bg/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Chinese_HongKong/android/values-zh-HK/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Chinese_Simplified/android/values-zh-Hans/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Chinese_Traditional/android/values-zh/strings.xml" # Traditional _Hant
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Czech/android/values-cs/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Danish/android/values-da/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Dutch/android/values-nl/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/English_GB/android/values-en-rGB/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Estonian/android/values-et/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Finnish/android/values-fi/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/French/android/values-fr/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/French_Canada/android/values-fr-CA/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Georgian/android/values-ka/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/German/android/values-de/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Greek/android/values-el/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Hebrew/android/values-he/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Hindi/android/values-hi/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Hungarian/android/values-hu/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Italian/android/values-it/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Japanese/android/values-ja/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Kannada/android/values-kn/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Korean/android/values-ko/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Lithuanian/android/values-lt/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Mongolian/android/values-mn/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Norwegian_nb/android/values-nb/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Persian/android/values-fa/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Polish/android/values-pl/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Portuguese/android/values-pt/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Portuguese_Brazil/android/values-pt-BR/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Portuguese_Portugal/android/values-pt-PT/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Romanian/android/values-ro/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Russian/android/values-ru/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Serbian_Cyrillic/android/values-sr/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Serbian_Latin/android/values-sr-Latn/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Slovak/android/values-sk/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Slovenian/android/values-sl/strings.xml"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Spanish/android/values-es/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Swedish/android/values-sv/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Thai/android/values-th/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Turkish/android/values-tr/strings.xml"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Vietnamese/android/values-vi/strings.xml"
