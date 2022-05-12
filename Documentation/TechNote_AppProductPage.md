# Technical Note:<br>Application Product Page

## Contents <a id="contents"></a>
[Text Components](#text-components-) •
[Android: Google Play Graphics](#android-google-play-graphics-) •
[Apple App Store Graphics](#apple-app-store-graphics-) •
[Resources](#resources-)

## Text Components <a id="text-components-"></a><sup>[▴](#contents)</sup>

A tsv files with app store information contains `appstore` in the file name. The spreadsheet file ['English_US_en_appstore.tsv'](https://github.com/nutritionfactsorg/daily-dozen-localization/blob/master/Languages/English_US/tsv/English_US_en_appstore.tsv) provides the baseline English reference for both the Android and Apple application store.

The tsv lines where the `key_droid` or `key_apple` values begin with `store.screen.` provide translated text for use in the marketing graphics.

**Text Style: Plain**

All text components are plain text _\*without\* any style formatting_ such as italics or bold. Plain text is used for both Android and Apple product page text content. Translations will need to use plain text characters, such as quotes, for elements like book titles as appropriate for that language.

All [UTF-8 international quotation marks](https://en.wikipedia.org/wiki/Quotation_mark) and other punctuation marks are supported in the product page plain text.

## Android: Google Play Graphics <a id="android-google-play-graphics-"></a><sup>[▴](#contents)</sup>

Google Play accepts a range of screenshot graphics sizes. 

* PNG (24-bit, no alpha) or JPEG 
* Minimum dimension: 320px
* Maximum dimension: 3840px 
    * The maximum screenshot dimension cannot be more than twice as long as the minimum dimension.

## Apple App Store Graphics <a id="apple-app-store-graphics-"></a><sup>[▴](#contents)</sup>

_The Daily Dozen iOS application submits portrait graphics files for 6.5" and 5.5" iPhone screen sizes._

> _Note: The Apple App Store product page expects that all graphics adhere to the exact pixel dimensions as a screen capture. Also, the 6.5" and 5.5" aspect ratios are different. So, a graphics layout whick works for one screen size may have information clipped on the other screen size._

**Simulator Screen shots:** File > `cmd-option-S` New Screen Shot. Requires the highest resolution in each screen size set. Do NOT use simulator "Show device mask to screenshots" preference setting.

* **6.5"** (**12 Pro Max**, 11 Pro Max, 11, Xs Max, Xr) **upload**
    * 1284 x 2778 pixels (portrait)
    * 2778 x 1284 pixels (landscape)
* 5.8" (Super Retina: 11 Pro, X, Xs) _auto-scaled from 6.5"_
* **5.5"** (**8 Plus**, 7 Plus, 6s Plus) **upload**
    * 1242 x 2208 pixels (portrait)
    * 2208 x 1242 pixels (landscape)
* 4.7" (6, 6s, 7, 8) _auto-scaled from 5.5"_
* 4" (SE) _auto-scaled from 5.5"_
* 3.5" (4s) _auto-scaled from 5.5"_

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

**Android: Google Play**

* [Android Developer: Google Play Console ⇗](https://developer.android.com/distribute/console)
    * [Manage your store listings ⇗](https://support.google.com/googleplay/android-developer/topic/3450987)
    * [Add preview assets to showcase your app ⇗](https://support.google.com/googleplay/android-developer/answer/9866151)
    * [Create custom store listings to target specific countries ⇗](https://support.google.com/googleplay/android-developer/answer/9867158?hl=en&ref_topic=3450987)
* [Android Studio: Take a screenshot ⇗](https://developer.android.com/studio/debug/am-screenshot)

**Apple App Store**

* [App Store Connect Help ⇗](https://help.apple.com/app-store-connect/)
    * [App Store: localizations ⇗](https://help.apple.com/app-store-connect/#/dev656087953) provides a list of languages and locales supported in the App store.
    * [Configure custom product pages ⇗](https://help.apple.com/app-store-connect/#/dev3a2998d9f)
    * [Screenshot Specifications ⇗](https://help.apple.com/app-store-connect/#/devd274dd925)
* [Creating Your Product Page ⇗](https://developer.apple.com/app-store/product-page/) provides an overview of the various product page elements.
* [Custom product pages ⇗](https://developer.apple.com/app-store/custom-product-pages/) can highlight different pages for different users.
* World Wide Developers Conference (WWDC)
    * [2021 Get ready to optimize your App Store product page ⇗](https://developer.apple.com/videos/play/wwdc2021/10295/)

