# Workflow: URL "Bookmarks"

_Developer source code level detail for managing the application JSON, application XML, the English_US URL TSV reference and downstream language URL TSV files._

## Contents <a id="contents"></a>
[Steps](#steps-) •
[Example Batch Commands](#example-batch-commands-) •
[Resources](#resources-)

## Steps <a id="steps-"></a><sup>[▴](#contents)</sup>

**Step 1. Compare Android/Apple Source Files.**

This step is currently manual process between Android XML files and Apple JSON files. Create a short list of changes to review base on the revision history of the respective Android XML files and Apple JSON files

Complete this step since discovery and changes here will propagate through to the TSV localization files and to the live NutritionFacts.org web link checkers.

**Step 2. Update TSV URL files**

Update the localization TSV spreadsheets files to match any updates to the Android XML files and Apple JSON files completed in the previous step:

* Languages/English_US/tsv/English_US_en_urls.tsv
* Languages/Spanish/tsv/Spanish_es_urls.tsv

**Step 3. Update Localization Files**

**Step 4. Check Web Link.**

* Languages/English_US/ios/en.xcloc/Localized Contents/DailyDozen/App/Texts/LocalStrings/en.lproj/DozeDetailData.json
* Languages/English_US/ios/en.xcloc/Localized Contents/DailyDozen/App/Texts/LocalStrings/en.lproj/TweakDetailData.json

Automated process using 

## Example Batch Commands <a id="example-batch-commands-"></a><sup>[▴](#contents)</sup>

URL tsv files can be diff'd.

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

**Utilities**

* [AppLocalizer ⇗](../Utilities/AppLocalizerLib/README.md)
* [UrlCheck ⇗](../Utilities/UrlCheck/README.md)
* [UrlReportGenerator ⇗](../Utilities/UrlCheck/README.md)

