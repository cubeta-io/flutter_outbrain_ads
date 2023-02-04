# Flutter Outbrain Ads

A Flutter package to show outbrain ads for Android and iOS.
Note: this plugin is unofficial.
## Platform Support

| Android | iOS | 
| :-----: | :-: | 
|   ✔️    | ✔️  | 

## Usage

To use this plugin, add `flutter_outbrain_ads` as a dependency in your pubspec.yaml file.

## Setup
add this permission in your manifist file
```dart
<uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
```

### Example

```dart
// Import package
import 'package:flutter_outbrain_ads/flutter_outbrain_ads.dart';

// Use it
  OutbrainAd(
    permalink: 'DROP_PERMALINK_HERE',
    outbrainAndroidDataObInstallationKey: 'DROP_ANDROID_PARTNER_KEY_HERE',
    outbrainAndroidWidgetId: 'DROP_ANDROID_WIDGET_ID_HERE',
    outbrainIosDataObInstallationKey: 'DROP_IOS_PARTNER_KEY_HERE',
    outbrainIosWidgetId: 'DROP_IOS_WIDGET_ID_HERE',
    darkMode: true,
    )
```