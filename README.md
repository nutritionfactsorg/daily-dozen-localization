# daily-dozen-localization

<center><span style="font-family:'DejaVu Sans Mono','Andale Mono',Courier,Monaco,'Courier New',monospace; color: orange; font-size: 18pt;">DRAFT CANDIDATE PROCESS</span></center>

## Contents <a id="contents"></a>
[Dashboard](#dashboard-) •
[Localization Workflow](#localization-workflow-) •
[File Name Convention](#file-name-convention-) •
[Resources](#resources-)

## Dashboard <a id="dashboard-"></a><sup>[▴](#contents)</sup>

_Base Development Language_

| Language | Android | _Google Play_ | iOS | _App Store_ |
|:------------|:---:|:----------:|:---:|:----------:|
| [English][locale_en] (US) | ✓  | [en][droid_en] | ✓ | [us][apple_en_us]

[locale_en]:Languages/English/README.md
[droid_en]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=en
[apple_en_us]:https://apps.apple.com/us/app/dr-gregers-daily-dozen/id1060700802

_Existing Localizations & Distribution_

| Language | Android | _Google Play_ | iOS | _App Store_ |
|:----------|:---:|:-------:|:---:|:-------:|
| [Bulgarian][locale_bg]  | ✓ | [bg][droid_bg] |   | [bg][apple_bg]  |
| [Chinese][locale_zh]   | ✓ | [zh][droid_zh] |   | [cn][apple_cn], [hk][apple_hk]   |
| [English][locale_en] (non-US) |   | [en-rGB][droid_en_rGB] |  | [au][apple_en_au], [ca][apple_en_ca], [gb][apple_en_gb]
| [French][locale_fr]     | ✓ | [fr][droid_fr] |   | [ca/fr][apple_fr_ca], [fr][apple_fr] |
| [German][locale_de]     | ✓ | [de][droid_de] |   | [de][apple_de] |
| [Greek][locale_el]      | ✓ | [el][droid_el] |   | [gr][apple_gr] |
| [Italian][locale_it]    | ✓ | [it][droid_it] |   | [it][apple_it] |
| [Portuguese][locale_pt] | ✓ | [pt][droid_pt] |   | [br][apple_pt_br], [pt][apple_pt] |
| [Romanian][locale_ro]   | ✓ | [ro][droid_ro] |   | [ro][apple_ro] |
| [Russian][locale_ru]    | ✓ | [ru][droid_ru] |   | [ru][apple_ru] |
| [Spanish][locale_es]    | ✓ | [es][droid_es] | ✓ | [es][apple_es], [mx][apple_mx] |

[locale_bg]:Languages/Bulgarian/README.md
[locale_zh]:Languages/Chinese/README.md
[locale_de]:Languages/German/README.md
[locale_el]:Languages/Greek/README.md
[locale_fr]:Languages/French/README.md
[locale_it]:Languages/Italian/README.md
[locale_pt]:Languages/Portuguese/README.md
[locale_ro]:Languages/Romanian/README.md
[locale_ru]:Languages/Russian/README.md
[locale_es]:Languages/Spanish/README.md

[droid_bg]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=bg
[droid_zh]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=zh
[droid_en_rGB]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=en-rGB
[droid_de]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=de
[droid_el]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=el
[droid_fr]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=fr
[droid_it]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=it
[droid_pt]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=pt
[droid_ro]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=ro
[droid_ru]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=ru
[droid_es]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=es

[apple_bg]:https://apps.apple.com/bg/app/dr-gregers-daily-dozen/id1060700802
[apple_cn]:https://apps.apple.com/cn/app/dr-gregers-daily-dozen/id1060700802
[apple_hk]:https://apps.apple.com/hk/app/dr-gregers-daily-dozen/id1060700802
[apple_en_au]:https://apps.apple.com/au/app/dr-gregers-daily-dozen/id1060700802
[apple_en_ca]:https://apps.apple.com/ca/app/dr-gregers-daily-dozen/id1060700802
[apple_en_gb]:https://apps.apple.com/gb/app/dr-gregers-daily-dozen/id1060700802

[apple_de]:https://apps.apple.com/de/app/dr-gregers-daily-dozen/id1060700802
[apple_fr]:https://apps.apple.com/fr/app/dr-gregers-daily-dozen/id1060700802
[apple_fr_ca]:https://apps.apple.com/ca/app/dr-gregers-daily-dozen/id1060700802?l=fr
[apple_gr]:https://apps.apple.com/gr/app/dr-gregers-daily-dozen/id1060700802
[apple_it]:https://apps.apple.com/it/app/dr-gregers-daily-dozen/id1060700802
[apple_pt]:https://apps.apple.com/pt/app/dr-gregers-daily-dozen/id1060700802
[apple_pt_br]:https://apps.apple.com/br/app/dr-gregers-daily-dozen/id1060700802
[apple_ro]:https://apps.apple.com/ro/app/dr-gregers-daily-dozen/id1060700802
[apple_ru]:https://apps.apple.com/ru/app/dr-gregers-daily-dozen/id1060700802

[apple_mx]:https://apps.apple.com/mx/app/dr-gregers-daily-dozen/id1060700802
[apple_es]:https://apps.apple.com/es/app/dr-gregers-daily-dozen/id1060700802

_Community Pull Request Submissions_

| Language | Android | _Google Play_ | iOS | _App Store_ | Notes|
|:----------|:---:|:-------:|:---:|:---------:|:----------|
| [Catalan][locale_ca] | [PR#123][] | [ca][droid_ca] |  |       | new submission
| [English][locale_en] (Great Britain) | [PR#120][] | [en-rGB][droid_en_rGB] |  | [gb][apple_en_gb] | British version words
| Hungarian            | [PR#119][] | [hu][droid_hu] |  | [hu][apple_hu] | new submission
| [Italian][locale_it] | [PR#117][] | [it][droid_it] |  | [it][apple_it] | native speaker update
| Japanese             | [PR#138][] | [ja][droid_ja] |  | [jp][apple_jp] | started translation

[PR#117]:https://github.com/nutritionfactsorg/daily-dozen-android/pull/117
[PR#119]:https://github.com/nutritionfactsorg/daily-dozen-android/pull/119
[PR#120]:https://github.com/nutritionfactsorg/daily-dozen-android/pull/120
[PR#123]:https://github.com/nutritionfactsorg/daily-dozen-android/pull/123
[PR#138]:https://github.com/nutritionfactsorg/daily-dozen-android/pull/138

[locale_ca]:Languages/Catalan/README.md

[droid_ca]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=bg
[droid_hu]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=hu
[droid_ja]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=ja

[apple_hu]:https://apps.apple.com/hu/app/dr-gregers-daily-dozen/id1060700802
[apple_jp]:https://apps.apple.com/jp/app/dr-gregers-daily-dozen/id1060700802

## Localization Workflow <a id="localization-workflow-"></a><sup>[▴](#contents)</sup>

**Phase 1. Export.** The Android and Apple exported localization files are merged into a spreadsheet compatible Tab Separated Value (TSV) files.

![](README_files/_DDLocalizer_Overview_export.svg)

**Phase 2. Translation.** The Tab Separated Value (TSV) format and be convenient imported and exported with various popular spreadsheet programs for the translators' use.

Data in field columns with have header names which begin with `key_` or `base_` _are not to be translated_. In particular, the `key_android`, `key_apple` entries are used for mapping values back into the device specific localization files.

The `base_comment` provides translation guidance in the development language (English). 

Extra columns can be added for the translators' convenience. The extra column names should not begin with `key_`, `base_` or `lang_`. The extra columns will be ignored upon import back into the device specific format.

**Phase 3. Import.** The completed TSV files are used to generate Android and Apple localization import files.

![](README_files/_DDLocalizer_Overview_import.svg)

## File Name Convention <a id="file-name-convention-"></a><sup>[▴](#contents)</sup>
 
Since the TSV files may be manually distributed for processed by humans, a `language-datestamp-tag-poc.tsv` file name convention can be used to help keep track of which file is which.

* `language`: language code. For example, `en`, `es`, `en_rGB`.
* `datestamp`: Date and time based on either of the following formats.
     * yyyyMMdd: 20200413 (year, month, day)
     * yyyyMMdd_HHmm:  20200413_1327 (year, month, day, 0-24 hours, minutes)
* `tag`: Use to provide some at-a-glance status. For example:
    * `export`, `ExportToTranslate`
    * `wip`, `WorkInProgress`
    * `import`, `ReadyToImport` 
* `poc`: individual point of contact, if applicable
    * GitHub id
    * initials

_File Name Examples_

* `de-20200219_1600-ExportToTranslate.tsv` A file computer generated file to be translated.
* `en_rGB-20200219-wip-ABC.tsv` A file which has been partially translated by person ABC. Perhaps, pending some review or feedback. 
* `ru-20200819-ReadyToImport-XYZ.tsv` A translation completed by person XYZ which is ready for automated import processing back to the device source code.

##

Apple App Store regions: [https://www.apple.com/choose-country-region/](https://www.apple.com/choose-country-region/)

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

* Android Developer
    * ["Localize Your App" ⇗](https://developer.android.com/guide/topics/resources/localization)
* Apple Developer 
    * [Article: "Localizing Your App" ⇗](https://developer.apple.com/documentation/xcode/localizing_your_app)
    * [Localization ⇗](https://developer.apple.com/localization/)
* [Language ISO 639-1 codes ⇗](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)