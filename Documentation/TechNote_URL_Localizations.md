# Tech Note:<br>Daily Dozen Mobile Application<br>URL Localization

_Translator level documentation for Daily Dozen mobile application URL localization._

**Overview**

Links to [NutritionFacts.org](https://nutritionfacts.org/) _language-specific webpages_ can be added to the mobile applications based on the URL rows in the `*.url_topics.tsv` and `*.url_fragments.tsv` spreadsheets on a per-language basis.

Below are the two English URL baseline spreadsheets which can be localized to the different languages:

* [English_US/tsv](https://github.com/nutritionfactsorg/daily-dozen-localization/tree/master/Languages/English_US/tsv)
    * [English_US_en.url_fragments.tsv](https://github.com/nutritionfactsorg/daily-dozen-localization/blob/master/Languages/English_US/tsv/English_US_en.url_fragments.tsv) is used for information resources such as books.
    * [English_US_en.url_topics.tsv](https://github.com/nutritionfactsorg/daily-dozen-localization/blob/master/Languages/English_US/tsv/English_US_en.url_topics.tsv) is, in general, used for topic pages and videos.

The Daily Dozen mobile application does not depend on the browser based web redirect.

As an example, the Spanish URL spreadsheets can be view here:

* [Spanish/tsv](https://github.com/nutritionfactsorg/daily-dozen-localization/tree/master/Languages/Spanish/tsv)
    * [Spanish_es.url_fragments.tsv](https://github.com/nutritionfactsorg/daily-dozen-localization/blob/master/Languages/Spanish/tsv/Spanish_es.url_fragments.tsv)
    * [Spanish_es.url_topics.tsv](https://github.com/nutritionfactsorg/daily-dozen-localization/blob/master/Languages/Spanish/tsv/Spanish_es.url_topics.tsv)

Languages which do not have specified URL spreadsheets default to use the English_US URLs.

_Note: Each URL row in the spreadsheets represents a specific URL placeholder in the application. If some URL is needed which does not have a corresponding spreadsheet row, then a URL/feature request will need to submitted to the applications._

**Use**

Place the appropriate URL segment in the `lang_value` column value.

If the `lang_value` column value is blank, then that web URL *is not* shown in the application.

* Links can be added (activated) by filling in the `lang_value` column.
* Links can be removed (deactivated) by leaving in the `lang_value` column blank.

Any URL link additions/removals are updated for the user on a per application release basis. Minor update releases can be done relatively quick.

