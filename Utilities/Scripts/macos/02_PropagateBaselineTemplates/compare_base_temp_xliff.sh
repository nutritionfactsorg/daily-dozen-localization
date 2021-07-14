#!/bin/sh
### FILE: compare_base_temp_xliff.sh

### :!!!: loose end CFBundleDisplayName
###       <trans-unit id="CFBundleDisplayName" xml:space="preserve">
###        <source>DailyDozen ML</source>

### Use: update untranslated languages using on the English_US base for XLIFF and JSON

BASE="$NF_LOCALE_LANG_BASE/ios/en.xcloc"

#############
## Leave untranslated locales uncommented. Comment out translated locales.
#############
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Afrikaans/ios/af.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Arabic/ios/ar.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Bulgarian/ios/bg.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Chinese_HongKong/ios/zh-HK.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Chinese_Simplified/ios/zh-Hans.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Chinese_Traditional/ios/zh.xcloc" # Traditional _Hant
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Czech/ios/cs.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Danish/ios/da.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Dutch/ios/nl.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/English_GB/ios/en-GB.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Estonian/ios/et.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Finnish/ios/fi.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/French/ios/fr.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/French_Canada/ios/fr-CA.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Georgian/ios/ka.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/German/ios/de.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Greek/ios/el.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Hebrew/ios/he.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Hindi/ios/hi.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Hungarian/ios/hu.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Italian/ios/it.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Japanese/ios/ja.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Kannada/ios/kn.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Korean/ios/ko.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Lithuanian/ios/lt.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Mongolian/ios/mn.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Norwegian_nb/ios/nb.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Persian/ios/fa.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Polish/ios/pl.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Portuguese/ios/pt.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Portuguese_Brazil/ios/pt-BR.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Portuguese_Portugal/ios/pt-PT.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Romanian/ios/ro.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Russian/ios/ru.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Serbian_Cyrillic/ios/sr.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Serbian_Latin/ios/sr-Latn.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Slovak/ios/sk.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Slovenian/ios/sl.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Spanish/ios/es.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Swedish/ios/sv.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Thai/ios/th.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Turkish/ios/tr.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Vietnamese/ios/vi.xcloc"

###############
### Note: Next up. Set to receive Android translations
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Bulgarian/ios/bg.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Chinese_Traditional/ios/zh-Hant.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/German/ios/de.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Greek/ios/el.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Hungarian/ios/hu.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Italian/ios/it.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Portuguese/ios/pt.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Romanian/ios/ro.xcloc"
bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Russian/ios/ru.xcloc"

###############################
### Note: not yet added to Xcode
## bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Bhojpuri/ios/bho.xcloc" ## :NYI: add to Xcode

###############
### Note: sets which have translations
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/French/ios/fr.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Polish/ios/pl.xcloc"
#bcompare "$BASE" "$NF_LOCALE_LANG_ALL/Spanish/ios/es.xcloc"
