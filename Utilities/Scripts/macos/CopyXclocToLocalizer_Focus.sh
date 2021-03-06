#!/bin/sh

### ./CopyXclocToLocalizer_Current.sh

## current: 12 files (11 without english)

export XCLOC_BASE="/Volumes/QubitData/[[Code]]/[[NF]]/__Localization/daily-dozen-localization"
export XCLOC_NEW="$XCLOC_BASE/__LOCAL/XLIFF/20210629_langs_all"
export LANGUAGES="$XCLOC_BASE/Languages"

#cp -Rf "$XCLOC_NEW/af.xcloc" "$LANGUAGES/Afrikaans/ios"
#cp -Rf "$XCLOC_NEW/ar.xcloc" "$LANGUAGES/Arabic/ios"
#cp -Rf "$XCLOC_NEW/bho.xcloc" "$LANGUAGES/Bhojpuri/ios"
cp -Rf "$XCLOC_NEW/bg.xcloc" "$LANGUAGES/Bulgarian/ios"
#cp -Rf "$XCLOC_NEW/zh-HK.xcloc" "$LANGUAGES/Chinese_HongKong/ios"
#cp -Rf "$XCLOC_NEW/zh-Hans.xcloc" "$LANGUAGES/Chinese_Simplified/ios"
cp -Rf "$XCLOC_NEW/zh-Hant.xcloc" "$LANGUAGES/Chinese_Traditional/ios" # Traditional _Hant
#cp -Rf "$XCLOC_NEW/cs.xcloc" "$LANGUAGES/Czech/ios"
#cp -Rf "$XCLOC_NEW/da.xcloc" "$LANGUAGES/Danish/ios"
#cp -Rf "$XCLOC_NEW/nl.xcloc" "$LANGUAGES/Dutch/ios"
#cp -Rf "$XCLOC_NEW/en-rGB.xcloc" "$LANGUAGES/English_GB/ios"
#cp -Rf "$XCLOC_NEW/en.xcloc" "$LANGUAGES/English_US/ios"
#cp -Rf "$XCLOC_NEW/et.xcloc" "$LANGUAGES/Estonian/ios"
#cp -Rf "$XCLOC_NEW/fi.xcloc" "$LANGUAGES/Finnish/ios"
cp -Rf "$XCLOC_NEW/fr.xcloc" "$LANGUAGES/French/ios"
#cp -Rf "$XCLOC_NEW/fr-CA.xcloc" "$LANGUAGES/French_Canada/ios"
#cp -Rf "$XCLOC_NEW/ka.xcloc" "$LANGUAGES/Georgian/ios"
cp -Rf "$XCLOC_NEW/de.xcloc" "$LANGUAGES/German/ios"
cp -Rf "$XCLOC_NEW/el.xcloc" "$LANGUAGES/Greek/ios"
#cp -Rf "$XCLOC_NEW/he.xcloc" "$LANGUAGES/Hebrew/ios"
#cp -Rf "$XCLOC_NEW/hi.xcloc" "$LANGUAGES/Hindi/ios"
#cp -Rf "$XCLOC_NEW/hu.xcloc" "$LANGUAGES/Hungarian/ios"
cp -Rf "$XCLOC_NEW/it.xcloc" "$LANGUAGES/Italian/ios"
#cp -Rf "$XCLOC_NEW/ja.xcloc" "$LANGUAGES/Japanese/ios"
#cp -Rf "$XCLOC_NEW/kn.xcloc" "$LANGUAGES/Kannada/ios"
#cp -Rf "$XCLOC_NEW/ko.xcloc" "$LANGUAGES/Korean/ios"
#cp -Rf "$XCLOC_NEW/lt.xcloc" "$LANGUAGES/Lithuanian/ios"
#cp -Rf "$XCLOC_NEW/mn.xcloc" "$LANGUAGES/Mongolian/ios"
#cp -Rf "$XCLOC_NEW/nb.xcloc" "$LANGUAGES/Norwegian_nb/ios"
#cp -Rf "$XCLOC_NEW/fa.xcloc" "$LANGUAGES/Persian/ios"
cp -Rf "$XCLOC_NEW/pl.xcloc" "$LANGUAGES/Polish/ios"
cp -Rf "$XCLOC_NEW/pt.xcloc" "$LANGUAGES/Portuguese/ios"
#cp -Rf "$XCLOC_NEW/pt-BR.xcloc" "$LANGUAGES/Portuguese_Brazil/ios"
#cp -Rf "$XCLOC_NEW/pt-PT.xcloc" "$LANGUAGES/Portuguese_Portugal/ios"
cp -Rf "$XCLOC_NEW/ro.xcloc" "$LANGUAGES/Romanian/ios"
cp -Rf "$XCLOC_NEW/ru.xcloc" "$LANGUAGES/Russian/ios"
#cp -Rf "$XCLOC_NEW/sr.xcloc" "$LANGUAGES/Serbian_Cyrillic/ios"
#cp -Rf "$XCLOC_NEW/sr-Latn.xcloc" "$LANGUAGES/Serbian_Latin/ios"
#cp -Rf "$XCLOC_NEW/sk.xcloc" "$LANGUAGES/Slovak/ios"
#cp -Rf "$XCLOC_NEW/sl.xcloc" "$LANGUAGES/Slovenian/ios"
cp -Rf "$XCLOC_NEW/es.xcloc" "$LANGUAGES/Spanish/ios"
#cp -Rf "$XCLOC_NEW/sv.xcloc" "$LANGUAGES/Swedish/ios"
#cp -Rf "$XCLOC_NEW/th.xcloc" "$LANGUAGES/Thai/ios"
#cp -Rf "$XCLOC_NEW/tr.xcloc" "$LANGUAGES/Turkish/ios"
#cp -Rf "$XCLOC_NEW/vi.xcloc" "$LANGUAGES/Vietnamese/ios"
