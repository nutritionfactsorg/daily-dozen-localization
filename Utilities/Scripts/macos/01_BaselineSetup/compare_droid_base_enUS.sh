#!/bin/sh
### FILE: compare_droid_base_enUS.sh

### Use: update localization English_US base XML from Android source XML

# replace `#` with side number: 1=Left, 2=Right, 3=Center, 4=Output
#  -title#=<title>     Shows description instead of filename in path edit
bcomp "$NF_DROID_RES/values/strings.xml" "$NF_LOCALE_LANG_BASE/android/values/strings.xml"

bcomp "$NF_LOCALE_LANG_BASE/android/values/strings.xml" "$NF_LOCALE_LANG_BASE/android/values/strings_WithoutTranslatableFalse.xml"

