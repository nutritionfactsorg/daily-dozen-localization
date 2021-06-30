# AppLocalizer

_The `AppeLocalizer` utility performs mapping to and from TSV spreadsheets and the Android and Apple "Daily Dozen" applications._

## Contents <a id="contents"></a>
[Export](#export-) •
[Import](#import-) •
[Technical Notes](#technical-notes-) •
[Workflow](#workflow-) •
[Resources](#resources-)

## Export <a id="export-"></a><sup>[▴](#contents)</sup>

_Export_ generates or updates TSV spreadsheets from data in the Android and Apple source code files.

``` sh
### EXPORT TRANSLATION ## 
# Steps:
#   1. Use base TSV as Android-Apple key mapping files. Set up reverse mappings.
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

## Import <a id="import-"></a><sup>[▴](#contents)</sup>

_Import_ uses TSV spreadsheet data to update the Android and Apple source code files.

## Technical Notes <a id="technical-notes-"></a><sup>[▴](#contents)</sup>

**Android Platform**

**Apple Platform**

* Case: key exists in English `*.strings` but is not present in the X Does .strings need to already have the ke

xliff complex. brittle. opaque errors. without process to migrate forward (frozen).

## Workflow <a id="workflow-"></a><sup>[▴](#contents)</sup>

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

* [Related: Common HTML Entities ⇗](https://www.w3.org/wiki/Common_HTML_entities_used_for_typography)

