# Workflow: Baseline Mapping

The _"Baseline"_ workflow checks that the develop language (English_US) has up-to-date mappings between the Android and Apple applications.

## Contents <a id="contents"></a>
[Steps](#steps-) •
[Example Batch Commands](#example-batch-commands-) •
[Resources](#resources-)

## Steps <a id="steps-"></a><sup>[▴](#contents)</sup>

**Step 1. Update `English_US` Sources.** Verify that the following `daily-dozen-localization` sources are up-to-date relative to the `daily-dozen-android` and `daily-dozen-ios` repositories:

* Android file: `Languages/English_US/android/values/strings.xml`
* Apple directory: `Languages/English_US/ios/en.xcloc/`

The Android `strings.xml` file can be verified directly. Update the  `strings_WithoutTranslatableFalse.xml` file to correspond to `strings.xml` without any `translatable="false"` entries.

Export Apple `en.xcloc/` from main and related branches. First, compare `en.xcloc/` for the branches to verify that the branches are in sync. Then, normalize the exported 'en.xcloc' to contain the "Localized Contents" in the same directory structure as the other languages.

``` sh
### Normalize exported 'en.xcloc'
# cd $PATH_TO/en.xcloc

cp -R 'Source Contents/DailyDozen' 'Localized Contents/DailyDozen'

LOCAL_STRINGS="Localized Contents/DailyDozen/App/Texts/LocalStrings"
LOCAL_BASE="$LOCAL_STRINGS/Base.lproj"
LOCAL_enUS="$LOCAL_STRINGS/en.lproj"
mv "$LOCAL_BASE/DozeDetailData.json" "$LOCAL_enUS/DozeDetailData.json" 
mv "$LOCAL_BASE/TweakDetailData.json" "$LOCAL_enUS/TweakDetailData.json" 

rm -r "$LOCAL_BASE"
```

The resulting file directory should be like the following `tree`.

``` sh
tree 'Localized Contents'

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
```

If needed, update the `daily-dozen-localization` `Languages/English_US` `android/` and `ios/` sources.

_Scripts/…/01_BaselineSetup_

* compare_droid_base_enUS.sh
* compare_xcloc_base_enUS.sh

**Step 2. Update Localization Templated Languages**

_Scripts/…/02_PropagateBaselineTemplates_

* compare_base_temp_xliff.sh
* compare_base_temp_xml.sh

**Step 3. Update URL "Bookmarks"**

Verify and update as needed the `NutritionFacts.org` links. See the _[Workflow: URL Bookmarks](Workflow_URLs.md)_ documentation for details.

## Example Batch Commands <a id="example-batch-commands-"></a><sup>[▴](#contents)</sup>

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

* [Utility: AppLocalizer ⇗](../Utilities/AppLocalizerLib/README.md)
