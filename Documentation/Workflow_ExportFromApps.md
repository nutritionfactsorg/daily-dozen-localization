# Workflow: Export (TSV) Spreadsheets from Applications

The _Export (TSV) Spreadsheets from Applications_ workflow generates or updates TSV spreadsheets using data in the Android and Apple source code files.

## Contents <a id="contents"></a>
[Steps](#steps-) •
[Report Information](#report-information-) •
[Example Batch Commands](#example-batch-commands-) •
[Resources](#resources-)

![](Workflow_ExportFromApps_files/ExportDataflowDiagram_pl.png)

## Steps <a id="steps-"></a><sup>[▴](#contents)</sup>

1. Use base TSV as Android-Apple key mapping files. Set up reverse mappings.
2. Set input & output file URLs.
3. `enUS` populates both `base_value` and `lang_value` with `base_value`.  
    * Note: the last received value will an existing value. 
4. `LANG` overwrites lang_value.                          


``` sh
### EXPORT TRANSLATION ## 
# Steps:
#   1. Read mapping files. Set up reverse mappings.
#   2. Set input & output file URLs.
#   3. enUS populates base_value & lang_value with base_value.  
#           Apple, if present, overwrites Android. 
#   4. LANG overwrites lang_value.                          
#           Apple, if present, overwrites Android.
# Report:
#   * Where Android value != Apple value for mapped keys. [NYI]
#   * After all inputs, list where base_value == lang_value [NYI] 
#   * If base_value != lang_value && (incoming_target != existing_target), then report

```

## Report Information <a id="report-information-"></a><sup>[▴](#contents)</sup>

* Where Android value != Apple value for mapped keys. [NYI]
* After all inputs, list where base_value == lang_value [NYI] 
* If base_value != lang_value && (incoming_target != existing_target), then report

## Example Batch Commands <a id="example-batch-commands-"></a><sup>[▴](#contents)</sup>

_file.txt_

``` sh
######################
##### Spanish_es #####
######################
## Existing output file to be updated.
OUTPUT_LANG_TSV="Spanish/tsv/Spanish_es.tsv"
## Key Pairing Document
SOURCE_enUS_TSV="English_US/tsv/English_US_en.tsv"
## Android
SOURCE_enUS_DROID="English_US/android/values/strings.xml"
SOURCE_LANG_DROID="Spanish/android/values-es/strings.xml"
## Apple
SOURCE_enUS_APPLE="English_US/ios/en.xcloc/Localized Contents/en.xliff" 
SOURCE_LANG_APPLE="Spanish/ios/es.xcloc/Localized Contents/es.xliff"
## Execute
DO_EXPORT_TSV
```

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

* [Utility: AppLocalizer ⇗](../Utilities/AppLocalizerLib/README.md)
