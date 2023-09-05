---
title: "Universal iOS Frameworks with Multi-Swift Support"
date: 2023-01-15T19:23:13+05:30
draft: true # Set 'false' to publish
description: ""
categories:
- Swift
tags:
- swift
- cocoapods
- framework
---

#### What is a Universal Framework?

It's a single framework that works on both iOS devices and simulators. It supports multiple architectures like `armv7`, `arm64`, `x86_64`, etc.

#### Steps to Create Universal Framework

1. In Xcode, add a new "Aggregate" target for your framework project.
2. Add a Run Script in "Build Phases" and copy-paste the following:

```bash
# Exit if any command fails
set -e

# Set framework name and output directory
FRAMEWORK_NAME="YourFrameworkName"
OUTPUT_DIR="${SRCROOT}/build"

# Delete old build directory
rm -rf "${OUTPUT_DIR}"

# Build for device and simulator
xcodebuild -project "${FRAMEWORK_NAME}.xcodeproj" -scheme "${FRAMEWORK_NAME}" -configuration Release -arch arm64 -arch armv7 -arch armv7s -sdk "iphoneos" -derivedDataPath "${OUTPUT_DIR}"
xcodebuild -project "${FRAMEWORK_NAME}.xcodeproj" -scheme "${FRAMEWORK_NAME}" -configuration Release -arch x86_64 -sdk "iphonesimulator" -derivedDataPath "${OUTPUT_DIR}"

# More script commands to combine both frameworks...
```

#### Swift Version Compatibility

You can conditionally compile code for different Swift versions like this:

```swift
#if swift(>=4.2)
// code for Swift 4.2 and above
#else
// code for older versions
#endif
```

To build the framework with a specific Swift version, you can download and install a Swift Toolchain and select it in Xcode.

#### Stripping Unsupported Architectures

Apple doesn't allow certain architectures for App Store uploads. To strip these from your framework, add a Run Script in the app that uses your framework:

```bash
# This script removes unsupported architectures

APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
    # More script commands to remove unwanted architectures...
done
```
