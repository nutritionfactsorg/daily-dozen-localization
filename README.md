# [Daily Dozen Localization](https://github.com/nutritionfactsorg/daily-dozen-localization)

## Contents <a id="contents"></a>
[Dashboard](#dashboard-) •
[Localization Workflow](#localization-workflow-) •
[Resources](#resources-)

<!-- [File Name Convention](#file-name-convention-) • -->

_The `nutritionfactsorg/daily-dozen-localization` repository supports the language translation work for the Daily Dozen applications on Android and Apple devices._

_A Daily Dozen App Localization QuickStart Guide is located in the documentation folder at [Documentation/Quickstart.md](https://github.com/nutritionfactsorg/daily-dozen-localization/blob/master/Documentation/Quickstart.md). The guide is intended to provide a process that is approachable by contributors without software development expertise. For example, it is sufficient to download, edit and submit a single file without creating a local clone or online fork of the git repository._

_Additionally, if you are interested to help create translated subtitles for NutritionFacts.org videos and help the NutritionFacts.org information reach more people all over the world, you can apply to be part of the Volunteer Translator Team at [https://nutritionfacts.org/volunteer](https://nutritionfacts.org/volunteer/)._

## Dashboard <a id="dashboard-"></a><sup>[▴](#contents)</sup>

_Base Development Language_

| Language | Android | _Google Play_ | Apple | _App Binary_ | _App Store_ |
|:------------|:---:|:---------:|:---:|:---------:|:-------------:|
| [English_US][locale-en] | ✓  | [en][droid-en] | ✓ | `Base`, `en` | [Australia AU)][apple-en-au]<br>[Canada (CA)][apple-en-ca]<br>[Great Britain (GB)][apple-en-gb]<br>[USA (US)][apple-en-us] |

[locale-en]:Languages/English_US
[droid-en]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=en
[apple-en-ca]:https://apps.apple.com/ca/app/dr-gregers-daily-dozen/id1060700802
[apple-en-us]:https://apps.apple.com/us/app/dr-gregers-daily-dozen/id1060700802
[apple-en-au]:https://apps.apple.com/au/app/dr-gregers-daily-dozen/id1060700802
[apple-en-gb]:https://apps.apple.com/gb/app/dr-gregers-daily-dozen/id1060700802

_App Localizations & Store Distribution_

| Language | Android | _Google Play_ | Apple | _Apple<br>App Binary_ | _App Store<br>Region_ |
|:------|:---:|:-----:|:-----:|:------:|:-------------:|
| [Afrikaans][locale-af]   |   | [af][droid-af]   |   | `af` | <!-- [Namibia (NA)][apple-af-NA]@en,<br>[South Africa (ZA)][apple-af-ZA]@en --> |
| [Arabic][locale-ar]      |   | [ar][droid-ar]   |   | `ar` | [Egypt (ar-EG)][apple-ar-EG],<br>[Saudi Arabia (ar-SA)][apple-ar-SA], ... |
| [Bhojpuri][locale-bho]   |   | [bho][droid-bho] |   |  --  | _(not available)_ |
| [Bulgarian][locale-bg]   | ✓ | [bg][droid-bg]   |   | `bg` | [Bulgarian (BG)][apple-bg]
| [Chinese_HongKong][locale-zh-HK]      |   | [zh-HK][droid-zh-HK]     |   | `zh-HK`   | [Hong Kong (HK)][apple-zh-HK]
| [Chinese_Simplified][locale-zh-Hans]  |   | [zh-Hans][droid-zh-Hans] |   | `zh-Hans` | [China (CN)][apple-zh-Hans],<br>[Singapore (SG)][apple-zh-Hans-SG]
| [Chinese_Traditional][locale-zh-Hant] | ✓ | [zh-Hant][droid-zh-Hant] |   | `zh-Hant` | [Macau (MO)][apple-zh-Hant-MO],<br>[Tiawan (TW)][apple-zh-Hant]
| [Czech][locale-cs]       |   | [cs][droid-cs] |   | `cs` | [Czech Republic (CZ)][apple-cs]
| [Danish][locale-da]      |   | [da][droid-da] |   | `da` | [Denmark (DK)][apple-da]
| [Dutch][locale-nl]       |   | [nl][droid-nl] |   | `nl` | [Netherlands (NL)][apple-nl]
| [Estonian][locale-et]    |   | [et][droid-et] |   | `et` | [Estonia (EE)][apple-et]
| [Finnish][locale-fi]     |   | [fi][droid-fi] |   | `fi` | [Finland (FI)][apple-fi]
| [French][locale-fr]      | ✓ | [fr][droid-fr] |  | `fr` | [France (FR)][apple-fr] |
| [French_Canada][locale-fr-CA] |   | [fr-CA][droid-fr-CA] |   | `fr-CA` | [Canada French (fr-CA)][apple-fr-ca]
| [Georgian][locale-ka]     |   | [ka][droid-ka] |   | `ka` |
| [German][locale-de]       | ✓ | [de][droid-de] |   | `de` | [Germany (DE)][apple-de]
| [Greek][locale-el]        | ✓ | [el][droid-el] |   | `gr` | [Greece (GR)][apple-el-gr]
| [Hebrew][locale-he]       | `P` | [he][droid-he] | `P` | `he` | [Isreal (IL)][apple-he-il]
| [Hindi][locale-hi]        |   | [hi][droid-hi] |   | `hi` | [India (IN)][apple-hi-in]
| [Hungarian][locale-hu]    |   | [hu][droid-hu] |   | `hu` | [Hungary (HU)][apple-hu]
| [Italian][locale-it]      | ✓ | [it][droid-it] |   | `it` | [Italy (IT)][apple-it]
| [Japanese][locale-ja]     |   | [ja][droid-ja] |   | `ja` | [Japan (JP)][apple-ja-jp]
| [Kannada][locale-kn]      |   | [kn][droid-kn] |   | `kn` |
| [Korean][locale-ko]       |   | [ko][droid-ko] |   | `ko` | [Korea (KR)][apple-ko-kr]
| [Lithuanian][locale-lt]   |   | [lt][droid-lt] |   | `lt` |
| [Mongolian][locale-mn]    |   | [mn][droid-mn] |   | `mn` |
| [Norwegian_nb][locale-nb] |   | [nb][droid-nb] |   | `nb` | [Norway (NO)][apple-nb-no]
| [Persian][locale-fa]      |   | [fa][droid-fa] |   | `fa` | 
| [Polish][locale-pl]       | ✓ | [pl][droid-pl] | `T` | `pl` | [Poland (PL)][apple-pl]
| [Portuguese][locale-pt]   | ✓ | [pt][droid-pt] | `T` | `pt` |
| [Portuguese_Brazil][locale-pt-BR]   |   | [pt-BR][droid-pt-BR] |   | `pt-BR` | [Brazil (BR)][apple-pt-BR]
| [Portuguese_Portugal][locale-pt-PT] |   | [pt-PT][droid-pt-PT] |   | `pt-PT` | [Portugal (PT)][apple-pt]
| [Romanian][locale-ro]     | ✓ | [ro][droid-ro] |   | `ro` | [Romania (RO)][apple-ro]
| [Russian][locale-ru]      | ✓ | [ru][droid-ru] | `P` | `ru` | [Russia (RU)][apple-ru]
| [Serbian_Cyrillic][locale-sr]   |   | [sr][droid-sr] |   | `sr` |
| [Serbian_Latin][locale-sr-Latn] |   | [sr-Latn][droid-sr-Latn] |   | `sr-Latn` |
| [Slovak][locale-sk]       |   | [sk][droid-sk] |   | `sk` | [Slovakia (SK)][apple-sk]
| [Slovenian][locale-sl]    |   | [sl][droid-sl] |   | `sl` |
| [Spanish][locale-es]      | ✓ | [es][droid-es] | ✓ | `es`, `mx` | [Mexico (mx)][apple-es-mx],<br>[Spain (ES)][apple-es-es]
| [Swedish][locale-sv]      |   | [sv][droid-sv] |   | `sv` | [Sweden (SE)][apple-sv-se]
| [Thai][locale-th]         |   | [th][droid-th] |   | `th` | [Thailand (TH)][apple-th]
| [Turkish][locale-tr]      |   | [tr][droid-tr] |   | `tr` | [Turkey (TR)][apple-tr]
| [Vietnamese][locale-vi]   |   | [vi][droid-vi] |   | `vi` | [Viet Nam (VN)][apple-vi-vn]

_legend:_

* `P` - partial application translation received
* `T` - application translation received and being processed
* `✓` - published through the app store

<!-- Afrikaans: Namibia (af-NA), South Africa (af-ZA) -->
[locale-af]:Languages/Afrikaans
[droid-af]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=af
[apple-af-NA]:https://apps.apple.com/na/app/dr-gregers-daily-dozen/id1060700802?l=af
[apple-af-ZA]:https://apps.apple.com/za/app/dr-gregers-daily-dozen/id1060700802?l=af

<!-- Arabic:  -->
[locale-ar]:Languages/Arabic
[droid-ar]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=ar
[apple-ar-EG]:https://apps.apple.com/eg/app/dr-gregers-daily-dozen/id1060700802?l=ar
[apple-ar-SA]:https://apps.apple.com/sa/app/dr-gregers-daily-dozen/id1060700802?l=ar

<!-- Bhojpuri -->
[locale-bho]:Languages/Bhojpuri
[droid-bho]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=bho
[apple-bho]:https://apps.apple.com/in/app/dr-gregers-daily-dozen/id1060700802?l=bho

<!-- Bulgarian: -->
[locale-bg]:Languages/Bulgarian
[droid-bg]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=bg
[apple-bg]:https://apps.apple.com/bg/app/dr-gregers-daily-dozen/id1060700802

<!-- Chinese_HongKong -->
[locale-zh-HK]:Languages/Chinese_HongKong
[droid-zh-HK]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=zh-HK
[apple-zh-HK]:https://apps.apple.com/hk/app/dr-gregers-daily-dozen/id1060700802

<!-- Chinese_Simplified -->
[locale-zh-Hans]:Languages/Chinese_Simplified
[droid-zh-Hans]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=zh-Hans
[apple-zh-Hans]:https://apps.apple.com/cn/app/dr-gregers-daily-dozen/id1060700802
[apple-zh-Hans-SG]:https://apps.apple.com/sg/app/dr-gregers-daily-dozen/id1060700802?l=zh

<!-- Chinese_Traditional -->
[locale-zh-Hant]:Languages/Chinese_Traditional
[droid-zh-Hant]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=zh-Hant
[apple-zh-Hant]:https://apps.apple.com/tw/app/dr-gregers-daily-dozen/id1060700802
[apple-zh-Hant-MO]:https://apps.apple.com/mo/app/dr-gregers-daily-dozen/id1060700802

<!-- Czech -->
[locale-cs]:Languages/Czech
[droid-cs]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=cs
[apple-cs]:https://apps.apple.com/cz/app/dr-gregers-daily-dozen/id1060700802?l=cs

<!-- Danish -->
[locale-da]:Languages/Danish
[droid-da]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=da
[apple-da]:https://apps.apple.com/dk/app/dr-gregers-daily-dozen/id1060700802?l=da

<!-- Dutch -->
[locale-nl]:Languages/Dutch
[droid-nl]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=nl
[apple-nl]:https://apps.apple.com/nl/app/dr-gregers-daily-dozen/id1060700802?l=nl

<!-- English_GreatBritain -->
[droid-en-GB]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=en-rGB

<!-- Estonian -->
[locale-et]:Languages/Estonian
[droid-et]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=et
[apple-et]:https://apps.apple.com/ee/app/dr-gregers-daily-dozen/id1060700802?l=et

<!-- Finnish -->
[locale-fi]:Languages/Finnish
[droid-fi]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=fi
[apple-fi]:https://apps.apple.com/fi/app/dr-gregers-daily-dozen/id1060700802?l=fi

<!-- French: -->
[locale-fr]:Languages/French
[droid-fr]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=fr
[apple-fr]:https://apps.apple.com/fr/app/dr-gregers-daily-dozen/id1060700802

<!-- French_Canada -->
[locale-fr-CA]:Languages/French_Canada
[droid-fr-CA]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=fr-CA
[apple-fr-CA]:https://apps.apple.com/ca/app/dr-gregers-daily-dozen/id1060700802?l=fr

<!-- Georgian -->
[locale-ka]:Languages/Georgian
[droid-ka]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=ka
[apple-ka]:https://apps.apple.com/ge/app/dr-gregers-daily-dozen/id1060700802

<!-- German -->
[locale-de]:Languages/German
[droid-de]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=de
[apple-de]:https://apps.apple.com/de/app/dr-gregers-daily-dozen/id1060700802

<!-- Greek -->
[locale-el]:Languages/Greek
[droid-el]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=el
[apple-el-gr]:https://apps.apple.com/gr/app/dr-gregers-daily-dozen/id1060700802?l=el

<!-- Hebrew -->
[locale-he]:Languages/Hebrew
[droid-he]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=he
[apple-he-il]:https://apps.apple.com/il/app/dr-gregers-daily-dozen/id1060700802?l=he

<!-- Hindi -->
[locale-hi]:Languages/Hindi
[droid-hi]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=hi
[apple-hi-in]:https://apps.apple.com/in/app/dr-gregers-daily-dozen/id1060700802?l=hi

<!-- Hungarian -->
[locale-hu]:Languages/Hungarian
[droid-hu]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=hu
[apple-hu]:https://apps.apple.com/hu/app/dr-gregers-daily-dozen/id1060700802?l=hu

<!-- Italian -->
[locale-it]:Languages/Italian
[droid-it]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=it
[apple-it]:https://apps.apple.com/it/app/dr-gregers-daily-dozen/id1060700802

<!-- Japanese -->
[locale-ja]:Languages/Japanese
[droid-ja]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=ja
[apple-ja-jp]:https://apps.apple.com/jp/app/dr-gregers-daily-dozen/id1060700802

<!-- Kannada -->
[locale-kn]:Languages/Kannada
[droid-kn]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=kn

<!-- Korean -->
[locale-ko]:Languages/Korean
[droid-ko]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=ko
[apple-ko-kr]:https://apps.apple.com/kr/app/dr-gregers-daily-dozen/id1060700802

<!-- Lithuanian -->
[locale-lt]:Languages/Lithuanian
[droid-lt]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=lt

<!-- Mongolian -->
[locale-mn]:Languages/Mongolian
[droid-mn]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=mn

<!-- Norwegian_nb -->
[locale-nb]:Languages/Norwegian_nb
[droid-nb]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=nb
[apple-nb-no]:https://apps.apple.com/no/app/dr-gregers-daily-dozen/id1060700802?l=nb

<!-- Persian -->
[locale-fa]:Languages/Persian
[droid-fa]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=fa
[apple-fa-ir]:https://apps.apple.com/ir/app/dr-gregers-daily-dozen/id1060700802

<!-- Polish -->
[locale-pl]:Languages/Polish
[droid-pl]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=pl
[apple-pl]:https://apps.apple.com/pl/app/dr-gregers-daily-dozen/id1060700802?l=pl

<!-- Portuguese -->
[locale-pt]:Languages/Portuguese
[droid-pt]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=pt
[apple-pt]:https://apps.apple.com/pt/app/dr-gregers-daily-dozen/id1060700802
[apple-pt]:https://apps.apple.com/pt/app/dr-gregers-daily-dozen/id1060700802

<!-- Portuguese_Brazil -->
[locale-pt-BR]:Languages/Portuguese_Brazil
[droid-pt-BR]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=pt-BR
[apple-pt-BR]:https://apps.apple.com/br/app/dr-gregers-daily-dozen/id1060700802

<!-- Portuguese_Portugal -->
[locale-pt-PT]:Languages/Portuguese_Portugal
[droid-pt-PT]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=pt-PT
[apple-pt-PT]:https://apps.apple.com/pt/app/dr-gregers-daily-dozen/id1060700802

<!-- Romanian -->
[locale-ro]:Languages/Romanian
[droid-ro]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=ro
[apple-ro]:https://apps.apple.com/ro/app/dr-gregers-daily-dozen/id1060700802?l=ro

<!-- Russian -->
[locale-ru]:Languages/Russian
[droid-ru]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=ru
[apple-ru]:https://apps.apple.com/ru/app/dr-gregers-daily-dozen/id1060700802

<!-- Serbian_Cyrillic -->
[locale-sr]:Languages/Serbian_Cyrillic
[droid-sr]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=sr

<!-- Serbian_Latin -->
[locale-sr-Latn]:Languages/Serbian_Latin
[droid-sr-Latn]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=sr-Latn

<!-- Slovak -->
[locale-sk]:Languages/Slovak
[droid-sk]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=sk
[apple-sk]:https://apps.apple.com/sk/app/dr-gregers-daily-dozen/id1060700802?l=sk

<!-- Slovenian (aka Slovene) -->
[locale-sl]:Languages/Slovenian
[droid-sl]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=sl

<!-- Spanish -->
[locale-es]:Languages/Spanish
[droid-es]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=es
[apple-es-mx]:https://apps.apple.com/mx/app/dr-gregers-daily-dozen/id1060700802
[apple-es-es]:https://apps.apple.com/es/app/dr-gregers-daily-dozen/id1060700802

<!-- Swedish -->
[locale-sv]:Languages/Swedish
[droid-sv]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=sv
[apple-sv-se]:https://apps.apple.com/se/app/dr-gregers-daily-dozen/id1060700802?l=sv

<!-- Thai -->
[locale-th]:Languages/Thai
[droid-th]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=th
[apple-th]:https://apps.apple.com/th/app/dr-gregers-daily-dozen/id1060700802?l=th

<!-- Turkish -->
[locale-tr]:Languages/Turkish
[droid-tr]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=tr
[apple-tr]:https://apps.apple.com/tr/app/dr-gregers-daily-dozen/id1060700802?l=tr

<!-- Vietnamese -->
[locale-vi]:Languages/Vietnamese
[droid-vi]:https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=vi
[apple-vi-vn]:https://apps.apple.com/vn/app/dr-gregers-daily-dozen/id1060700802?l=vi

## Localization Workflow <a id="localization-workflow-"></a><sup>[▴](#contents)</sup>

Here is an overview of the general workflow for working with the TSV spreadsheet files. Please see the Daily Dozen App Localization QuickStart Guide for more detailed steps: [Documentation/Quickstart.md](https://github.com/nutritionfactsorg/daily-dozen-localization/blob/master/Documentation/Quickstart.md).

**Phase 1. Export.** The Android and Apple exported localization files are merged into a spreadsheet compatible Tab Separated Value (TSV) files.

**Phase 2. Translation.** The Tab Separated Value (TSV) format can be conveniently imported and exported with various popular spreadsheet programs for the translators' use.

Data in field columns with have header names which begin with `key_` or `base_` _are not to be translated_. In particular, the `key_android`, `key_apple` entries are used for mapping values back into the device specific localization files.

The `base_comment` provides translation guidance in the development language (English). 

The columns which begin with `lang_` are to be translated.

Extra columns can be added for the translators' convenience. The extra column names should not begin with `key_`, `base_` or `lang_`. Any extra columns will be ignored upon import back into the device specific formats.

**Phase 3. Import.** The completed TSV files are used to generate Android and Apple localization import files.

<!--
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
-->

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

* Android Developer
    * ["Localize Your App" ⇗](https://developer.android.com/guide/topics/resources/localization)
* Apple App Store regions: [https://www.apple.com/choose-country-region/](https://www.apple.com/choose-country-region/)
* Apple Developer 
    * [Article: "Localizing Your App" ⇗](https://developer.apple.com/documentation/xcode/localizing_your_app)
    * App Store
        * [App Store localizations ⇗](https://help.apple.com/app-store-connect/#/dev656087953) List of localizations supported in App Store. The following can be localized on the App Store page: app name, description, keywords, and screenshots.
        * [App Store countries and regions ⇗](https://help.apple.com/app-store-connect/#/dev997f9cf7c) List of countries and regions where the app can be made available.
        * [Required, localizable, and editable properties ⇗](https://help.apple.com/app-store-connect/#/devfc3066644)
    * [Localization ⇗](https://developer.apple.com/localization/)
* [Language ISO 639-1 codes ⇗](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
