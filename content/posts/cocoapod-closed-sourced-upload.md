---
title: "Upload Closed-Source Framework to CocoaPods"
date: 2023-07-15T19:23:13+05:30
draft: false # Set 'false' to publish
description: ""
categories:
- Swift
tags:
- swift
- cocoapods
---

Publishing a closed-source framework to CocoaPods can be challenging. This guide aims to alleviate your pain points by sharing how I successfully uploaded a precompiled `.framework` file to CocoaPods. 

## Prerequisites

Make sure you go through the following resources:

- [Getting Setup With Trunk](https://guides.cocoapods.org/making/getting-setup-with-trunk.html) - Official Reference
- [Private CocoaPods](https://guides.cocoapods.org/making/private-cocoapods.html) - Official Reference
- [Eladnava's Guide](https://eladnava.com/publish-a-universal-binary-ios-framework-in-swift-using-cocoapods/) - Third-party Reference
- [Telerik's Guide](https://www.telerik.com/blogs/how-to-use-a-third-party-framework-in-a-private-cocoapod) - Third-party Reference

### Common Issues

I encountered several issues related to the `.podspec` file, such as:

- Unexpected version directory
- Wrong `.source file` error
- Invalid `.public_header_files`
- Non-validating `.homepage` URL
- Specification does not validate

## Step-by-Step Guide

### Create Universal Framework

First, create a universal iOS framework. Refer to [this article](https://www.tirupatibalan.com/2019/01/05/create-fat-framework.html) for a step-by-step guide.

### Create `.podspec` File

Create a `MyFramework.podspec` file in your project directory and add the following content:

```ruby
Pod::Spec.new do |s|
    s.name                    = 'MyFramework'
    s.version                 = '1.0.0'
    s.summary                 = 'MyFramework summary.'
    s.homepage                = 'https://www.example.com/'
    s.author                  = { 'MyFramework' => 'hello@example.com' }
    s.license                 = { :type => 'Apache-2.0', :file => 'LICENSE' }
    s.platform                = :ios
    s.source                  = { :http => 'https://example.com/download/ios_sdk/1.0.1/MyFramework.zip' }
    s.ios.deployment_target   = '9.0'
    s.ios.vendored_frameworks = 'MyFramework.framework'
end
```

### Validate `.podspec`

Run the following command to validate:

```bash
pod spec lint --allow-warnings
```

### Archive and Upload Framework

Create a `.zip` file containing your framework and LICENSE:

```bash
zip -r MyFramework.zip LICENSE MyFramework.framework
```

Upload the `.zip` file to your server. In my case, I used [Firebase Private Hosting](https://firebase.google.com/docs/hosting/).

### Register With CocoaPods Trunk

Register an account for authentication:

```bash
pod trunk register you@youremail.com 'Your organization name'
```

### Push to CocoaPods

Finally, push your `.podspec` file:

```bash
pod trunk push MyFramework.podspec
```

## Testing

Add the following line to your `.podfile` and run `pod install`:

```ruby
pod 'MyFramework', '1.0.0'
```

That's it! You've successfully uploaded your closed-source framework to CocoaPods.

Happy Coding!