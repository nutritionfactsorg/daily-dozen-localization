# AppLocalizer

_:TODO: update SizeHeaders.xib, and for related .xib_

``` xml
<string name="units">Unidades</string>
<string name="imperial">Imperial</string>
<string name="metric">Métrico</string>
```

``` swift
// :TRANSLATE:!!!:NYI: metric/imperial button in code. also match case sensitivy
//"metric": "1K3-d9-Hfb.normalTitle", // :TRANSLATE:!!!:NYI: metric/imperial button code
//"metric": "M75-CQ-NVP.normalTitle", // :TRANSLATE:!!!:NYI: metric/imperial button code
// SizesHeader.xib
```

---

``` xml
<string-array name="food_info_serving_sizes_other_fruits">
    <item>%s1 medium-sized fruit</item>
    <item>%s dried fruit</item>
</string-array>

<string-array name="food_info_serving_sizes_other_fruits_imperial">
    <item/>
    <item>¼ cup</item>
</string-array>

<string-array name="food_info_serving_sizes_other_fruits_metric">
    <item/>
    <item>40 g</item>
</string-array>

<string-array name="food_info_types_other_fruits">
    <item>Apples</item>
    <item>Dried apricots</item>
</string-array>

<string-array name="food_videos_other_fruits" translatable="false">
    <item>apples</item>
    <item>apricots</item>
    <item/>                   <!-- no video topics keyword -->
</string-array>
```

``` xml
<key>dozeFruitsOther</key>
<dict>
    <key>Sizes</key>
    <dict>
        <key>Metric</key>
        <array>
            <string>1 medium-sized fruit</string>
            <string>40 g dried fruit</string>
        </array>
        <key>Imperial</key>
        <array>
            <string>1 medium-sized fruit</string>
            <string>¼ cup dried fruit</string>
        </array>
    </dict>
    <key>Types</key>
    <array>
        <dict>
            <key>Apples</key>
            <string>apples</string>  <!-- vido topic keyword --> 
        </dict>
        <dict>
            <key>Clementines</key>
            <string></string>
        </dict>
    </array>
    <key>Topic</key>
    <string>fruit</string>
</dict>
```

---

``` xml
<string name="nightly_sleep">Get Sufficient Sleep</string>
<string name="nightly_sleep_short">Get Sufficient Sleep</string>
<string name="nightly_sleep_text">Check this box if …</string>
<string-array name="tweak_names" translatable="false">
    <item>@string/nightly_sleep</item>
    <item>@string/nightly_trendelenburg</item>
</string-array>
```

``` xml
<key>tweakNightlySleep</key>
<dict>
    <key>Sizes</key>
    <dict>
        <key>Metric</key>
        <array>
            <string>Every Night: Get Sufficient Sleep</string>
        </array>
        <key>Imperial</key>
        <array>
            <string>Every Night: Get Sufficient Sleep</string>
        </array>
    </dict>
    <key>Types</key>
    <array>
        <dict>
            <key>Check this box if …</key>
            <string></string>
        </dict>
    </array>
    <key>Topic</key>
    <string>TOPIC_ITEM</string>
</dict>
```