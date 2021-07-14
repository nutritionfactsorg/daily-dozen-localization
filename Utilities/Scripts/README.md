# Utilities: Scripts

## Contents <a id="contents"></a>
[macOS Scripts](#macos-scripts-) •
[Windows Scripts](#windows-scripts-) •
[Resources](#resources-)

## macOS Scripts <a id="macos-scripts-"></a><sup>[▴](#contents)</sup>

**Environment Variables**

* `daily-dozen-android` paths
    * **`NF_DROID_RES`** path to `daily-dozen-android/app/src/main/res`
    * **`NF_DROID_RES_FORK`** path to pull request fork of `daily-dozen-android/app/src/main/res`

* `daily-dozen-ios` paths
    * **`NF_APPLE_V3_LANG`** path to v3-languages branch `daily-dozen-ios-v3-languages`
    * **`NF_APPLE_V3_MAIN`** path to main branch of `daily-dozen-ios-master`
    * **`NF_XCLOC_LANG`** path to current Xcode `.xcloc` export for the _languages_ branch.
    * **`NF_XCLOC_MAIN`** path to current Xcode `.xcloc` export for the _main_ branch.

* `daily-dozen-localization` paths
    * **`NF_LOCALE_LANG_ALL`** path to `…/Languages/`
    * **`NF_LOCALE_LANG_BASE`** path to `…/Languages/English_US`
    * **`NF_LOCALE_SCRIPTS_MAC`** path to `…/Utilities/Scripts/macos/`

**Locations**

* `daily-dozen-android/app/main/src/res/`
    * **`droid`** refers to the Android `values-*/strings.xml` file set.
* `daily-dozen-ios` -> `/*.xloc`
    * **`xloc`** refers the exported Xcode `*.xloc` localization files placed in some an intermediate `xliff` directory.
* `daily-dozen-localization/Languages/`
    * **`base`** indicates the "baseline" `English_US` directory.
    * **`lang`** indicates the language set which have existing translations.
    * **`temp`** indicates the language set which still have the baseline English_US template and are awaiting translation.

**Scripts**

1. Setup of baseline (English_US)
    * **compare_droid_base_enUS.sh** - use to update baseline from current Android source
    * **compare_xcloc_base_enUS.sh** - use to update localization baseline from current iOS Xcode `xcloc` export.
2. Propagate baseline English to templated languages
    * **compare_base_temp_xliff.sh**
    * **compare_base_temp_xml.sh**
3. Sync existing translations to Android and iOS
    * **compare_lang_droid.sh**
    * **compare_lang_xcloc.sh**

## Windows Scripts <a id="windows-scripts-"></a><sup>[▴](#contents)</sup>

