# Technical Note:<br>Daily Dozen Localization Overview for the Apple Platform

_This document summarizes several activities and statuses (as of 2021.03.08) which have been, and are needed, to support multiple languages in the Daily Dozen application on Apple devices._

<em>
The localization objectives include:

* Structure the app to support [multiple languages](https://github.com/nutritionfactsorg/daily-dozen-localization#dashboard-).
* Have [coordinated translations](https://github.com/nutritionfactsorg/daily-dozen-localization) between the Android and Apple apps.
* Reduce the multi-language support complexity.
* Stay on track with Apple's platform shift from [Cocoa Storyboards](https://developer.apple.com/library/archive/documentation/General/Conceptual/Devpedia-CocoaApp/Storyboard.html) to [SwiftUI](https://developer.apple.com/xcode/swiftui/).
</em>

### Contents <a id="contents"></a>

* [Uncouple Database Keys](#uncouple-database-keys-) (implemented: v3.0)
* [Normalize Stored Data](#normalize-stored-data-) (implemented: v3.0)
* [Source Code Logic](#source-code-logic-) (initial implementation: v3.2.1, known cases done)
* [Localize Storyboards](#localize-storyboards-) (baseline implementation: v3.2.1 for Left-to-Right regions)
* [Adjust Storyboard Layout](#adjust-storyboard-layout-) (implemented: v3.2.1, additional updates as needed)
* [Android/Apple Coordinated Translations](#android-apple-coordinated-translations-) (first spreadsheet intake: Polish, pending v3.2.7 release)
* [Localize App Store Presentation](#localize-app-store-presentation-) (in process for Polish, pending v3.2.7 release)
* [Phase Out Random IDs](#phase-out-random-ids-) (process start: v3.2.5/7)
* [Upgrade to SwiftUI](#upgrade-to-swiftui-) (pending random ID phase out)
* [Support Right-to-Left](#support-right-to-left-) (not yet implemented)
* [Localize Default Settings](#localize-default-settings-) (not yet implemented)
* [Accessibility](#accessibility-) (TBD)
* [Resources](#resources-)

### Uncouple Database Keys <a id="uncouple-database-keys-"></a><sup>[▴](#contents)</sup>

The Daily Dozen iOS app v2 used the screen display headings as the database index keys. In v2, a change from "Nuts" to "Nuts and Seeds" would require that the database to be refactored.

Version 3 uses stand-alone database keys. The standalone keys allows for the display text to be modified with needing to refactor the database.

> Status: Implemented version 3.0.0

### Normalize Stored Data <a id="normalize-stored-data-"></a><sup>[▴](#contents)</sup>

The raw weight data is stored as kilograms floating point. Raw dates are stored in ISO Universal Time Codes (UTC) format. Date, time and weight are converted for display in the user's timezone and language.   

> Status: Implemented in version 3.0.0

### Source Code Logic <a id="source-code-logic-"></a><sup>[▴](#contents)</sup>

Version v3.1.0 and earlier routinely used hard coded English text as part of the internal logic. As an example, code logic similar to `if someString == "videos"` was common. The Spanish release found and addressed most instances. The Polish translation uncovered some addition instances. In one case, both Spanish and English use `videos`. However, Polish uses `filmy` causing the non-localized logic could be found.

> Status: Initial implementation: v3.2.1; Known cases are done.

### Localize Storyboards <a id="localize-storyboards-"></a><sup>[▴](#contents)</sup>

Localization is enabled on a per `Storyboard` (screen section) basis.  When enabled, the Xcode development generates multiple `*.strings` files and language project `*.lproj` directories.

A localized `Storyboard` auto-generates fixed, random ids on a _per use basis_ instead of a _per phrase_ basis.  The net result is:

* Good: the app strings can now be translated and a multi-language app released.
* Not-So-Good: app gained a large number of `*.lproj` directories and `*.lproj` directories. ... _like 1,290 additional files for 43 languages._

So, good news, translated apps can be now be published. However, a ["Phase Out Random IDs"](#phase-out-random-ids-) needed to be added to the path forward.

> Status: Baseline implementation done in v3.2.1 for Left-to-Right regions

### Adjust Storyboard Layout <a id="adjust-storyboard-layout-"></a><sup>[▴](#contents)</sup>

Version 3.1.0 and earlier had mostly _fixed text length layouts_ `Storyboard` layouts. Even the initial 21 Tweaks heading strings needed to be shortened to meet the release deadline.

The introduction of Spanish "broke" most screen layouts due how the text sizes varied from English. The layout dimensions, constraint types, and anchors were changed across the many storyboard files.  

The Spanish v3.2.1 marks the release with adjustable text layouts.

> Status: Initial implemented in v3.2.1, additional updates as needed

### Android/Apple Coordinated Translations <a id="android-apple-coordinated-translations-"></a><sup>[▴](#contents)</sup>

The <code>[daily-dozen-localization](https://github.com/nutritionfactsorg/daily-dozen-localization)</code> repository was set up to receive spreadsheet based Daily Dozen translations for both the Android and Apple platforms. The [Polish translation](https://github.com/nutritionfactsorg/daily-dozen-localization/issues/4) has been the first language processed through the spreadsheet workflow.

> Status: Polish translation processed; pending v3.2.7 release

### Localize App Store Presentation <a id="localize-app-store-presentation-"></a><sup>[▴](#contents)</sup>

Polish is the first language to have the text translate for use in the Android and Apple App Store regionalized pages. See the `Polish_pl_appstore*.tsv` file in the [Languages/Polish/tsv folder](https://github.com/nutritionfactsorg/daily-dozen-localization/blob/master/Languages/Polish/tsv).

Here are the regional app store pages where the translated copy is expected to show up:

* [Android: Daily Dozen 'pl'](https://play.google.com/store/apps/details?id=org.nutritionfacts.dailydozen&hl=pl)
* [Apple: Daily Dozen 'pl'](https://apps.apple.com/pl/app/dr-gregers-daily-dozen/id1060700802?l=pl)

> Status: In process for Polish, pending v3.2.7 release

### Phase Out Random IDs <a id="phase-out-random-ids-"></a><sup>[▴](#contents)</sup>

See issue `#51` ["Upgrade: phase out Storyboard auto-generated random String IDs"](https://github.com/nutritionfactsorg/daily-dozen-ios/issues/51) for details.

> Status: Work in progress.

### Upgrade to SwiftUI <a id="upgrade-to-swiftui-"></a><sup>[▴](#contents)</sup>

Apple has retired and archived the `Storyboard` documentation. The replacement for `Storyboard` is `SwiftUI`.

* [https://developer.apple.com/library/archive/documentation/General/Conceptual/Devpedia-CocoaApp/Storyboard.html](https://developer.apple.com/library/archive/documentation/General/Conceptual/Devpedia-CocoaApp/Storyboard.html) 
* [https://developer.apple.com/xcode/swiftui/](https://developer.apple.com/xcode/swiftui/)

![](TechNote_AppleLocalizationOverview_files/AppleStoryboards.jpg)

The storyboard files can be found as `*.storyboard` and `*.xib` files in the repository. A `*.xib` file is an outdated form for a storyboard file. 

Here is a table which shows how many files are needed for each local translation.

| Android               | Apple Storyboard    | Apple SwiftUI |
|:----------------------|:-----------------------|:-----------------------|
| values-es/strings.xml | InfoPlist.strings   | InfoPlist.strings 
|                       | Localizable.strings | Localizable.strings
|                       | DozeDetailLayout.storyboard | swiftui.strings |
|                       | DozeDetailSizeHeader.xib |     |
|                       | DozeDetailSizeUnitHeader.xib |     |
|                       | ( … snip … ) |     |
|                       | DozeDetailData.json | DozeDetailData.json |
|                       | TweakDetailData.json | TweakDetailData.json |
| Total: 1 file/translation | Total: ~30 files/translation | Total: 5 files/translation

Android is efficient for localized implementations. Only one file is needed for each Android translation.

Apple Storyboards is an evolution from Steve Job's NeXT computer which was leveraged 1988 ExperLisp Interface Builder technology. Each `*.storyboard` and `*.xib` file has a corresponding `*.strings` file per localization.

Thus, 43 translations ends up with 1,290 files added to the `daily-dozen-ios` project when the outdated Storyboard approach is used!!

_In contrast, `SwiftUI` will allow for the many, many `*.strings` files to be consolidated into a single `*strings` file per language like Android has a single XML file per language. A SwiftUI implementation will mean "bye-bye" to about a thousand localization files in the Daily Dozen app._

The [daily-dozen-localization](https://github.com/nutritionfactsorg/daily-dozen-localization) repository provides [TSV files](https://github.com/nutritionfactsorg/daily-dozen-localization/tree/master/Languages/Spanish/tsv) which are designed to help migrate from a `Storyboard` implementation to a `SwiftUI` implementation.

> Status: Pending random ID phase out

### Support Right-to-Left <a id="support-right-to-left-"></a><sup>[▴](#contents)</sup>

Cocoa Storyboards requires express setup to support right-to-left localizations. SwiftUI provides more automated and build-in support for right-to-left localization.  A SwiftUI implementation could supersede the need to do a right-to-left implementation with Storyboards.

> Status: Not yet implemented in the application. Revisit when right-to-left translations and testers are available.

### Localize Default Settings <a id="localize-default-settings-"></a><sup>[▴](#contents)</sup>

Currently, the user default is hard coded to use the imperial measurement system. For a new software install, it is possible to set imperial vs. metric default setting to be based on the language and region of the users device.

> Status: not yet implemented.

### Accessibility <a id="accessibility-"></a><sup>[▴](#contents)</sup>

Accessibility includes a variety of modalities such as: extra large fonts, high contrast screen modes, navigation flow and enable synthetic voice reading the navigation labels & text.

> Status: The scope and implementation is TBD.

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

* [Apple Storyboards](https://developer.apple.com/library/archive/documentation/General/Conceptual/Devpedia-CocoaApp/Storyboard.html) _archived documentation. last update: 2018-04-06._ 
* [Apple SwiftUI](https://developer.apple.com/xcode/swiftui/)
