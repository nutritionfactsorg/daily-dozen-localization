#!/bin/sh
### FILE: compare_xcloc_base_enUS.sh

### Use: update localization English_US base XCLOC from Xcode current XCLOC export.

## Copy "Source Contents" to "Localized Contents"
echo "Begin: compare_xcloc_base_enUS.sh "

PATH_OLD="$NF_XCLOC_LANG/en.xcloc/Source Contents/DailyDozen"
PATH_NEW="$NF_XCLOC_LANG/en.xcloc/Localized Contents/DailyDozen"
cp -R "$PATH_OLD" "$PATH_NEW"
echo "... copying  'Source Contents/DailyDozen/' to 'Localized Contents/DailyDozen/' "

## Move "Base.lproj" into "en.proj"
PATH_OLD="$NF_XCLOC_LANG/en.xcloc/Localized Contents/DailyDozen/App/Texts/LocalStrings/Base.lproj/DozeDetailData.json"
PATH_NEW="$NF_XCLOC_LANG/en.xcloc/Localized Contents/DailyDozen/App/Texts/LocalStrings/en.lproj/"
mv "$PATH_OLD" "$PATH_NEW"

PATH_OLD="$NF_XCLOC_LANG/en.xcloc/Localized Contents/DailyDozen/App/Texts/LocalStrings/Base.lproj/TweakDetailData.json"
mv "$PATH_OLD" "$PATH_NEW"
echo "... moved 'Base.lproj/DozeDetailData.json/' and 'Base.lproj/TweakDetailData.json/' into 'en.lproj/' "

## Remove "Base.lproj" into "en.proj"
rm -Rf "$NF_XCLOC_LANG/en.xcloc/Localized Contents/DailyDozen/App/Texts/LocalStrings/Base.lproj"
echo "... removed 'Base.lproj' "

open "$NF_XCLOC_LANG/en.xcloc/"

### BEFORE
# Localized\ Contents
# └── en.xliff
# Source\ Contents
# └── DailyDozen
#     └── App
#         ├── SupportingFiles
#         │   └── en.lproj
#         │       └── InfoPlist.strings
#         └── Texts
#             └── LocalStrings
#                 ├── Base.lproj
#                 │   ├── DozeDetailData.json
#                 │   └── TweakDetailData.json
#                 └── en.lproj
#                     └── Localizable.strings


### AFTER
# Localized\ Contents
# ├── DailyDozen
# │   └── App
# │       ├── SupportingFiles
# │       │   └── en.lproj
# │       │       └── InfoPlist.strings
# │       └── Texts
# │           └── LocalStrings
# │               └── en.lproj
# │                   ├── DozeDetailData.json
# │                   ├── Localizable.strings
# │                   └── TweakDetailData.json
# └── en.xliff

# replace `#` with side number: 1=Left, 2=Right, 3=Center, 4=Output
#  -title#=<title>     Shows description instead of filename in path edit
bcompare "$NF_XCLOC_LANG/en.xcloc/" "$NF_LOCALE_LANG_BASE/ios/en.xcloc/"

