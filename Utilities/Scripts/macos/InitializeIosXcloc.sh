#!/bin/sh

###################################
### FILE: InitializeIosXcloc.sh ###
###################################
### Populates initial android/values-* with English strings.xml for new languages. 

SCRIPT_DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
LANGUAGES="$SCRIPT_DIR/../../../Languages"

LANGUAGES="$NF_LANGUAGES"

## Existing 

# af.xcloc
# ar.xcloc
# bg.xcloc
# cs.xcloc
# da.xcloc
# de.xcloc
# el.xcloc
# en.xcloc
# es.xcloc
# et.xcloc
# fa.xcloc
# fi.xcloc
# fr-CA.xcloc
# fr.xcloc
# he.xcloc
# hi.xcloc
# hu.xcloc
# it.xcloc
# ja.xcloc
# ka.xcloc
# kn.xcloc
# ko.xcloc
# lt.xcloc
# mn.xcloc
# nb.xcloc
# nl.xcloc
# pl.xcloc
# pt-BR.xcloc
# pt-PT.xcloc
# pt.xcloc
# ro.xcloc
# ru.xcloc
# sk.xcloc
# sl.xcloc
# sr-Latn.xcloc
# sr.xcloc
# sv.xcloc
# th.xcloc
# tr.xcloc
# vi.xcloc
# zh-HK.xcloc
# zh-Hans.xcloc
# zh-Hant.xcloc

cp -Rf "af.xcloc"      "$LANGUAGES/Afrikaans/ios/"
cp -Rf "ar.xcloc"      "$LANGUAGES/Arabic/ios/"
cp -Rf "bg.xcloc"      "$LANGUAGES/Bulgarian/ios/"
cp -Rf "cs.xcloc"      "$LANGUAGES/Czech/ios/"
cp -Rf "da.xcloc"      "$LANGUAGES/Danish/ios/"
cp -Rf "de.xcloc"      "$LANGUAGES/German/ios/"
cp -Rf "el.xcloc"      "$LANGUAGES/Greek/ios/"
cp -Rf "en.xcloc"      "$LANGUAGES/English_US/ios/"
cp -Rf "es.xcloc"      "$LANGUAGES/Spanish/ios/"
cp -Rf "et.xcloc"      "$LANGUAGES/Estonian/ios/"
cp -Rf "fa.xcloc"      "$LANGUAGES/Persian/ios/"
cp -Rf "fi.xcloc"      "$LANGUAGES/Finnish/ios/"
cp -Rf "fr-CA.xcloc"   "$LANGUAGES/French_Canada/ios/"
cp -Rf "fr.xcloc"      "$LANGUAGES/French/ios/"
cp -Rf "he.xcloc"      "$LANGUAGES/Hebrew/ios/"
cp -Rf "hi.xcloc"      "$LANGUAGES/Hindi/ios/"
cp -Rf "hu.xcloc"      "$LANGUAGES/Hungarian/ios/"
cp -Rf "it.xcloc"      "$LANGUAGES/Italian/ios/"
cp -Rf "ja.xcloc"      "$LANGUAGES/Japanese/ios/"
cp -Rf "ka.xcloc"      "$LANGUAGES/Georgian/ios/"
cp -Rf "kn.xcloc"      "$LANGUAGES/Kannada/ios/"
cp -Rf "ko.xcloc"      "$LANGUAGES/Korean/ios/"
cp -Rf "lt.xcloc"      "$LANGUAGES/Lithuanian/ios/"
cp -Rf "mn.xcloc"      "$LANGUAGES/Mongolian/ios/"
cp -Rf "nb.xcloc"      "$LANGUAGES/Norwegian_nb/ios/"
cp -Rf "nl.xcloc"      "$LANGUAGES/Dutch/ios/"
cp -Rf "pl.xcloc"      "$LANGUAGES/Polish/ios/"
cp -Rf "pt-BR.xcloc"   "$LANGUAGES/Portuguese_Brazil/ios/"
cp -Rf "pt-PT.xcloc"   "$LANGUAGES/Portuguese_Portugal/ios/"
cp -Rf "pt.xcloc"      "$LANGUAGES/Portuguese/ios/"
cp -Rf "ro.xcloc"      "$LANGUAGES/Romanian/ios/"
cp -Rf "ru.xcloc"      "$LANGUAGES/Russian/ios/"
cp -Rf "sk.xcloc"      "$LANGUAGES/Slovak/ios/"
cp -Rf "sl.xcloc"      "$LANGUAGES/Slovenian/ios/"
cp -Rf "sr-Latn.xcloc" "$LANGUAGES/Serbian_Latin/ios/"
cp -Rf "sr.xcloc"      "$LANGUAGES/Serbian_Cyrillic/ios/"
cp -Rf "sv.xcloc"      "$LANGUAGES/Swedish/ios/"
cp -Rf "th.xcloc"      "$LANGUAGES/Thai/ios/"
cp -Rf "tr.xcloc"      "$LANGUAGES/Turkish/ios/"
cp -Rf "vi.xcloc"      "$LANGUAGES/Vietnamese/ios/"
cp -Rf "zh-HK.xcloc"   "$LANGUAGES/Chinese_HongKong/ios/"
cp -Rf "zh-Hans.xcloc" "$LANGUAGES/Chinese_Simplified/ios/"
cp -Rf "zh-Hant.xcloc" "$LANGUAGES/Chinese_Traditional/ios/"
