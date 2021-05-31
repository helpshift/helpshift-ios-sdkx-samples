# HelpshiftX SDK iOS Samples

Sample Xcode projects demonstrating the integration of HelpshiftX SDK

## Requirements

* see Helpshift SDK requirements [here](https://developers.helpshift.com/sdkx_ios/getting-started/)

## Projects

Each one of the sub-directories in this repository is a Xcode project that demonstrates HelpshiftX SDK integration and features.

* **[Objc/HSSDKXObjcSample](ObjC/HSSDKXObjcSample)**: Demonstrates integration of HelpshiftX your Objective-C app
* **[Swift/HSSDKXSwiftSample](Swift/HSSDKXSwiftSample)**: Demonstrates integration of HelpshiftX your Swift app
* **[SwiftUI/HSSDKXSwiftUISample](SwiftUI/HSSDKXSwiftUISample)**: Demonstrates integration of HelpshiftX your app which has its UI done using SwiftUI framework

For the projects to build and run successfully, please follow these steps : 
* Enter your install credentials in `AppDelegate.m` (`AppDelegate.swift` for Swift projects) Check the `#warning` occurences in the app to know what values have to replaced.
* Enter your bundle identifier in General section in project settings.
* (For push notifications) Select a valid team in General section in project settings.

## Resources
* Documentation: [https://developers.helpshift.com/sdkx_ios/getting-started/](https://developers.helpshift.com/sdkx_ios/getting-started/)
* API Reference: [https://docs.helpshift.com/docs/api/ios/sdkx/v10.x/index.html](https://docs.helpshift.com/docs/api/ios/sdkx/v10.x/index.html)
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
