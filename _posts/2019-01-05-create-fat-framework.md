---
layout: post
comments: true
title: Create a universal (fat) framework in iOS along with selected swift version and strip out unwanted architecture
excerpt_separator:  <!--more-->
---

Recently, I came into the framework development and I've learned or say went through lots of things during development like dependency free framework, swift version compatible issue, active architecture build problem, create private framework with cocoapod, method swizzling, threading etc etc

In this article, I'll try to explain how I went through multiple articles for fat framework creation along with multiple swift version compatibility issues and later how I figured out device architecture problem during upload.

<h3>What is fat or universal framework?</h3>

In framework development, when we build our framework it will create two versions of .framework file as below
- For Device i.e armv7, armv7s, arm64 (`In Debug-iphoneos dir`)
- For Simulator i.e x86_64, i386 (`In Debug-iphonesimulator dir`)
After combining above two versions of the framework the resulting framework is called `fat` or `universal` or `universal static` framework or library.

> NOTE: x86_64, i386 are not valid device architecture, means it will gonna fail during build upload or build validation process.

Step to create a fat framework as below [Reference](https://stackoverflow.com/questions/24039470/xcode-6-ios-creating-a-cocoa-touch-framework-architectures-issues/26691080#26691080)

1. Create a new (Aggregate) target in your framework's project (`In Xcode 7 and 8, click File>New>Target... and there select "Other" group to select Aggregate target`)
2. Under "Build Phases" select "Add Run Script" and copy the contents of below script
3. Select the Aggregate target in the Scheme Selection drop down
4. Build the target for the aggregate scheme

{% highlight shell %}
# 1
# Set bash script to exit immediately if any commands fail.
set -e
# 2
# Setup some constants for use later on.
FRAMEWORK_NAME="your_framework_name_here"
OUTPUT_DIR="${SRCROOT}/build"
# 3
# If remnants from a previous build exist, delete them.
if [ -d "${OUTPUT_DIR}" ]; then
rm -rf "${OUTPUT_DIR}"
fi
# 4
# Build the framework for device and for simulator (using
# all needed architectures).

xcodebuild -project "${FRAMEWORK_NAME}.xcodeproj" -scheme "${FRAMEWORK_NAME}" -configuration Release -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -sdk "iphoneos" -derivedDataPath "${OUTPUT_DIR}"
xcodebuild -project "${FRAMEWORK_NAME}.xcodeproj" -scheme "${FRAMEWORK_NAME}" -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator" -derivedDataPath "${OUTPUT_DIR}"

# 5
# Remove .framework file if exists from previous run.
if [ -d "${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework" ]; then
rm -rf "${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework"
fi
# 6
# Copy the device version of framework.
cp -r "${OUTPUT_DIR}/Build/Products/Release-iphoneos/${FRAMEWORK_NAME}.framework" "${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework"
# 7
# Replace the framework executable within the framework with
# a new version created by merging the device and simulator
# frameworks' executables with lipo.
lipo -create -output "${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${OUTPUT_DIR}/Build/Products/Release-iphoneos/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${OUTPUT_DIR}/Build/Products/Release-iphonesimulator/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"
# 8
# Copy the Swift module mappings for the simulator into the
# framework. The device mappings already exist from step 6.
cp -r "${OUTPUT_DIR}/Build/Products/Release-iphonesimulator/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/" "${OUTPUT_DIR}/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule"
{% endhighlight %}

Now as per above script final .framework file is valid for all available architecture i.e x86_64, i386, armv7, armv7s, arm64

You can check framework valid architecture via running below command on terminal 

{% highlight shell %}
$ lipo -info path_to_framework/framework_name.framework/framework_name
{% endhighlight %}

The output you will see:

`Architecture in the fat file: framework_name are: x86_64 i386 armv7 armv7s arm64
Means your .framework will be available for both simulator as well as device architecture!!`

---

Secondly, now I'm facing swift compatibility issues for the above-created framework as my framework based on swift 4.2 only 

Below is the conditional #if statement I have used in some part of code [Reference](https://www.hackingwithswift.com/example-code/language/how-to-check-the-swift-version-at-compile-time)

{% highlight shell %}
#if swift(>=4.2)
//condition here
#else
//condition here
#endif
{% endhighlight %}

Now to make it available for multiple swift version you have to build using a different command like Toolchain through Xcode

1. First, download and install swift Toolchain via below link

- [Swift 4.0](https://swift.org/builds/swift-4.0-release/xcode/swift-4.0-RELEASE/swift-4.0-RELEASE-osx.pkg)
- [Swift 4.1](https://swift.org/builds/swift-4.1-release/xcode/swift-4.1-RELEASE/swift-4.1-RELEASE-osx.pkg)
- [Swift 4.2](https://swift.org/builds/swift-4.2-release/xcode/swift-4.2-RELEASE/swift-4.2-RELEASE-osx.pkg)

1. After above package installation jump to `Xcode->Preference->Component->Toolchain` and select your swift version 

2. Also change the swift version in Build Settings same as what you selected in Toolchain 

Finally, build it using manually created fat aggregate target and check your 'build' output directory as per our above fat framework script, you will see .framework file for all architecture along with selected swift version.

---

> NOTE: If you are not using cocoapod or carthage for your framework as dependency platform then only most of the time you will face kind of below issue.

Now we have to make it available for device architecture only otherwise you will face such [issue](https://stackoverflow.com/questions/30547283/submit-to-app-store-issues-unsupported-architecture-x86/30866648) on host app during app store upload.

Because Apple won't allow x86_64, i386 architecture on app store build.

So for wrapping out x86_64, i386 architecture from framework on host app (App in which our fat framework is in use) use below script [Reference](http://ikennd.ac/blog/2015/02/stripping-unwanted-architectures-from-dynamic-libraries-in-xcode/)
 
>  Under "Build Phases" select "Add Run Script" and copy the contents of below script

{% highlight shell %}
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

# This script loops through the frameworks embedded in the application and
# removes unused architectures.
find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
    FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
    FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
    echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

    EXTRACTED_ARCHS=()

    for ARCH in $ARCHS
    do
        echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
        lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
        EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
    done

    echo "Merging extracted architectures: ${ARCHS}"
    lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
    rm "${EXTRACTED_ARCHS[@]}"

    echo "Replacing original executable with thinned version"
    rm "$FRAMEWORK_EXECUTABLE_PATH"
    mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

done
{% endhighlight %}

Once you add above script it will wrap out all invalid architecture via looping through all imported frameworks and host app won't face architecture related issue during their final upload on the store.