# Workflow: Diffs

The _"Diffs"_ workflow outlines various comparisons.

## Contents <a id="contents"></a>
[Steps](#steps-) •
[Example Batch Commands](#example-batch-commands-) •
[Resources](#resources-)

* `DIFF_TSV_A`, `DIFF_TSV_B` one or more files. values of last file overwrite any previous values.
* `DIFF_XLIFF_A`, `DIFF_XLIFF_B` single xliff file.
* `DIFF_XML_A`, `DIFF_XML_B` single xml file.

## Steps <a id="steps-"></a><sup>[▴](#contents)</sup>

## Example Batch Commands <a id="example-batch-commands-"></a><sup>[▴](#contents)</sup>

_batch_diff_tsv_update_all.txt_

``` sh
### FILE: batch_diff_tsv_update_all.txt
### WORKFLOW: Documentation/Workflow_Diffs.md
###
### USE: After updating English_US baseline,
###      determine the key changes needed to update each language.
###
#################################
### UPDATE DIFF: Afrikaans_af ###
#################################
DIFF_TSV_A="English_US/tsv/English_US_en.app.20210309.tsv"
DIFF_TSV_B="Afrikaans/tsv/Afrikaans_af.app.tsv"
DO_DIFF_KEYS
CLEAR_ALL

##############################
### UPDATE DIFF: Arabic_ar ###
##############################
DIFF_TSV_A="English_US/tsv/English_US_en.app.20210309.tsv"
DIFF_TSV_B="Arabic/tsv/Arabic_ar.app.tsv"
DO_DIFF_KEYS
CLEAR_ALL

# ...
```

_batch_diff_xliff.txt_

``` sh
### FILE: batch_diff_xliff.txt
### WORKFLOW: Documentation/Workflow_Diffs.md
##################
### DIFF FILES ###
##################
DIFF_XLIFF_A="English_US/ios/en.xcloc/Localized Contents/en.xliff" 
DIFF_XLIFF_B="Polish/ios/pl.xcloc/Localized Contents/pl.xliff" 
DO_DIFF_KEYS
```

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

* [Utility: AppLocalizer ⇗](../Utilities/AppLocalizerLib/README.md)
