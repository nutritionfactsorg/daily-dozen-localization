# Utilities: AppLocalizer

_The `AppeLocalizer` utility performs mapping to and from TSV spreadsheets and the Android and Apple "Daily Dozen" applications._

## Contents <a id="contents"></a>
[Batch Commands](#batch-commands-) •
[Workflows](#workflows-) •
[Resources](#resources-)

## Checklist <a id="checklist-"></a>

The checklist matrix ["LocaleChecklistTemplate.txt"](./README_files/LocaleChecklistTemplate.txt) is available to help manually doublecheck the stages and statuses of the various translations.

## Commands <a id="commands-"></a>

- `SOURCE_enUS_TSV` 
    - Function: provides for the key pairing between Android and Apple files.
    - Workflows: 

See _"…/AppLocalizerLib/Core/Batch/CmdKeys.swift"_ for the full list of AppLocalizer scripting commands and variables. 

## Workflows <a id="workflows-"></a>

- [Baseline](../Documentation/Workflow_Baseline.md) - review and setup keys.
    - checks that the develop language (English_US) has up-to-date mappings between the Android and Apple applications.
    - **:OBSOLETE:XLIFF:**
- [Diffs](../Documentation/Workflow_Diffs.md) - compare `.tsv`, `.xliff` and `.xml` files
    - **:OBSOLETE:XLIFF:**
- [Export (TSV) Spreadsheets from Applications](../Documentation/Workflow_ExportFromApps.md)
    - **:OBSOLETE:XLIFF:**
- [Import (TSV) Spreadsheets into Applications](../Documentation/Workflow_ImportIntoApps.md)
    - **:OBSOLETE:XLIFF:**
- [Langauge Additions](../Documentation/Workflow_LanguageAddition.md)
    - Set up a new language.
- Rebase **:WIP:**
    - 
- [Replicate](../Documentation/Workflow_Replicate.md)
    - Replicate existing Android translations to normal form
    - **:OBSOLETE:** Was used to pre-populate prior to when the Android did not include all the translations which were available for Android. This is likely no longer required.
- Batch Rebase

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

- [daily-dozen-localization ⇗](https://github.com/nutritionfactsorg/daily-dozen-localization)
