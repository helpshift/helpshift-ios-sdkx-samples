# Helpshift SDK X iOS Example App

Sample iOS SwiftUI project demonstrating the integration of Helpshift SDK X.

## Requirements

* See Helpshift SDK X requirements [here](https://developers.helpshift.com/sdkx_ios/getting-started/)

## Import project

1. Clone the repositiory
2. Open `helpshift-ios-sdkx-example.xcodeproj` in Xcode

## Building the project

Please follow these steps to build the app:
* Update your Helpshift App credentials in `helpshift-ios-sdkx-example/sdk_install_creds.plist` file. To get your Helpshift app credentials please check [here](https://developers.helpshift.com/sdkx_ios/getting-started/#start-using).
* Push notification is already integrated in the example app using [`UserNotifications` framework](https://developer.apple.com/documentation/usernotifications)
    * You need to upload your push certificate in Helpshift Dashboard as mentioned [here](https://developers.helpshift.com/sdkx_ios/notifications/#configure-helpshift-push-admin)
    * You also need to modify the app target's bundle identifier to match your push certificate.
* Build the project in Xcode and run on either your device or simulator.

## Example feature implementations

### Initializing Helpshift SDK via `install`

* Refer `application(:didFinishLaunchingWithOptions:)` method in [`DemoApp.swift`](/helpshift-ios-sdkx-example/Source/DemoApp.swift).
* Notice that we have initialized the SDK as soon as the app is launched.
* Developer Documentation: [Getting Started](https://developers.helpshift.com/sdkx_ios/getting-started/#start-using)

NOTE: `Helpshift.install` must be called before invoking any other API in the Helpshift SDK.

### User Management

* Refer [`LoginView.swift`](/helpshift-ios-sdkx-example/Source/LoginView.swift). file for User related integration and example code
* Developer Documentation: [Users](https://developers.helpshift.com/sdkx_ios/users/)

### SDK Configurations

* For install configuration, check `installConfig()` method in [`DemoApp.swift`](/helpshift-ios-sdkx-example/Source/DemoApp.swift).
* For API configuration, check `config` computed property in [`ContentView.swift`](/helpshift-ios-sdkx-example/Source/ContentView.swift).
* API config contains custom example for CIF. Please modify according to your needs.
* Many other configurations are picked from the example app UI.
* Developer Documentation: [Configurations](https://developers.helpshift.com/sdkx_ios/sdk-configuration/)

### Showing Conversation/FAQ screens, Breadcrumbs, Logs, Setting language etc

* For example code of various other features please refer to code examples in [`ContentView.swift`](/helpshift-ios-sdkx-example/Source/ContentView.swift).
* The code is easy to interpret since each button on UI has been linked with a feature.
* For example, if you need example code for showing Conversation Screen, start refering from `conversationViews` View in [`ContentView.swift`](/helpshift-ios-sdkx-example/Source/ContentView.swift).
* Developer Documentation: [Helpshift APIs](https://developers.helpshift.com/sdkx_ios/support-tools/)

### Handling push notifications from Helpshift

* To handle push notifications from Helpshift, refer implementation of `UNUserNotificationCenterDelegate` in [`DemoApp.swift`](/helpshift-ios-sdkx-example/Source/DemoApp.swift).
* Notice that we have checked "origin" as "helpshift" before calling push handling APIs.
* The `UNUserNotificationCenterDelegate` methods handle Helpshift conversation push notifications as well as Proactive Outbound push notifications.
* Developer Documentation: [Notifications](https://developers.helpshift.com/sdkx_ios/notifications/)

### Handling Proactive Outbound Notifications

* To show Proactive Outbound notification on device when receiving push notifications, refer implementation of `UNUserNotificationCenterDelegate` in [`DemoApp.swift`](/helpshift-ios-sdkx-example/Source/DemoApp.swift).
* Handling Proactive Outbound links as deep links: // TODO
* Developer Documentation: [Proactive Outbound](https://developers.helpshift.com/sdkx_ios/outbound-support/)

### Handling Deeplinks

* Example code to handle deeplinks: // TODO
* Developer Documentation: [Deep Linking](https://developers.helpshift.com/sdkx_ios/deep-linking/)

### Event Delegates

* To register for listening to Helpshift SDK generated events, refer `application(:didFinishLaunchingWithOptions:)` method in [`DemoApp.swift`](/helpshift-ios-sdkx-example/Source/DemoApp.swift).
* To handle events received from Helpshift SDK after registering, refer implementation of `HelpshiftDelegate` in []`DemoApp.swift`](/helpshift-ios-sdkx-example/Source/DemoApp.swift).
* Developer Documentation: [Delegates](https://developers.helpshift.com/sdkx_ios/delegates/)

## Resources
* Documentation: [https://developers.helpshift.com/sdkx_ios/getting-started/](https://developers.helpshift.com/sdkx_ios/getting-started/)
* Release Notes: [https://developers.helpshift.com/sdkx_ios/release-notes/](https://developers.helpshift.com/sdkx_ios/release-notes/)

## License

```
Copyright 2021, Helpshift, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
