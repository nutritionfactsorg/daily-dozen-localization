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

A current Apple `en.xcloc/` Xcode export will need to be done for a (re-)baseline process.

If needed, update the `daily-dozen-localization` `Languages/English_US` `android/` and `ios/` sources.

_Scripts_

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
