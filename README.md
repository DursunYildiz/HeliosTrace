# HeliosTrace

<p align="center">
  <img src="Sources/Resources/Media.xcassets/HeliosTraceLogo.imageset/logo.png" alt="HeliosTrace Logo" width="200"/>
</p>


HeliosTrace is a powerful network debugging and tracing tool for iOS. It allows developers to monitor HTTP/HTTPS network traffic, capture logs, and debug their applications directly from the device.

## Features

- **Network Monitoring**: Capture and inspect HTTP/HTTPS requests and responses.
- **Log Monitoring**: Intercept and view Swift `print` logs within the app.
- **Filtering**: Configure ignored or allowed URLs and log prefixes to focus on what matters.
- **Customization**: Set a custom main color to match your app's theme.
- **Sharing**: Share network logs and details via email.
- **Shake to Show**: Shake the device to toggle the debug window (configurable).
- **Additional UI**: Add a custom view controller to the HeliosTrace dashboard.
- **Protobuf Support**: Map protobuf URLs to response classes for better debugging.

## Requirements

- iOS 14.0+
- Swift 5.0+

## Installation

### Swift Package Manager

You can install HeliosTrace using [Swift Package Manager](https://swift.org/package-manager/).

1. In Xcode, go to **File > Add Packages...**
2. Enter the repository URL: `https://github.com/DursunYildiz/HeliosTrace` (Replace with actual URL if different)
3. Select the version you want to use.

## Usage

### Initialization

To enable HeliosTrace, call `HeliosTrace.enable()` in your `AppDelegate`'s `application(_:didFinishLaunchingWithOptions:)` method.

```swift
import HeliosTrace

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Configure HeliosTrace
    HeliosTrace.serverURL = "https://api.example.com" // Optional: Mark server URL in bold
    HeliosTrace.ignoredURLs = ["google.com", "facebook.com"] // Optional: Ignore specific URLs
    HeliosTrace.mainColor = "#FF5733" // Optional: Set custom theme color
    
    // Enable HeliosTrace
    HeliosTrace.enable()
    
    return true
}
```

### Objective-C

```objective-c
#import "HeliosTrace-Swift.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Configure HeliosTrace
    HeliosTrace.serverURL = @"https://api.example.com";
    HeliosTrace.ignoredURLs = @[@"google.com", @"facebook.com"];
    HeliosTrace.mainColor = @"#FF5733";
    
    // Enable HeliosTrace
    [HeliosTrace enable];
    
    return YES;
}
```

### Configuration Options

HeliosTrace provides several static properties for configuration:

- `serverURL`: String? - Highlights this URL in the logs.
- `ignoredURLs`: [String]? - List of URLs to ignore.
- `onlyURLs`: [String]? - List of allowed URLs (others will be ignored).
- `ignoredPrefixLogs`: [String]? - List of log prefixes to ignore.
- `onlyPrefixLogs`: [String]? - List of allowed log prefixes.
- `additionalViewController`: UIViewController? - Add a custom tab to the HeliosTrace UI.
- `emailToRecipients`: [String]? - Default "To" recipients for email sharing.
- `emailCcRecipients`: [String]? - Default "Cc" recipients for email sharing.
- `mainColor`: String - Hex color code for the UI theme (default: `#42d459`).
- `protobufTransferMap`: [String: [String]]? - Mapping for Protobuf URL and response classes.

### Disabling

To disable HeliosTrace:

```swift
HeliosTrace.disable()
```

### Show/Hide Bubble

You can programmatically show or hide the floating bubble:

```swift
HeliosTrace.showBubble()
HeliosTrace.hideBubble()
```

## Logging

HeliosTrace automatically captures standard `print` statements if enabled. To ensure logs are captured, use the overridden `print` function provided by the library or ensure your logging mechanism integrates with it.

## License

This project is available under the MIT license. See the LICENSE file for more info.
