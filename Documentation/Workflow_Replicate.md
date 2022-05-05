# Workflow: Replicate Existing Android Translations to Normal Form

_Steps that were used to migrate pre-existing Android `xml` translation into normalized `tsv` and `xml`._

## Contents <a id="contents"></a>
[Steps](#steps-) •
[Example Batch Commands](#example-batch-commands-) •
[Resources](#resources-)

**Given**

* XML files with existing translations: values-lang/strings.xml
* English_US TSV reference files

**Generate**

* Normalized TSV translation file
* Normalized XML translation file

## Steps <a id="steps-"></a><sup>[▴](#contents)</sup>

1. Verify that the Android `xml` files in `daily-dozen-localization` match the Android `xml` files in `daily-dozen-android`. 
2. Create normalized TSV and XML files from Android existing `xml`. Batch Commands: `batch_normal_FromXmlDroidOnly.txt`
3. Review generated TSV files and reports.
4. Review generated XML files and reports.

## Example Batch Commands <a id="example-batch-commands-"></a><sup>[▴](#contents)</sup>

_batch_normal_FromXmlDroidOnly.txt_

``` sh
```

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

* [Utility: AppLocalizer ⇗](../Utilities/AppLocalizerLib/README.md)

