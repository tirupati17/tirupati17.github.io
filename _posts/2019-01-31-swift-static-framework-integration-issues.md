---
layout: post
comments: true
title: Swift static framework integration issue
tags: 
    - Static Framework
    - Library 
    - Framework 
    - Toolchain
    - Xcode
    - Objective-C
    - Swift

excerpt_separator:  <!--more-->
---

Well, Everyone has kind of experience where they are working on something interesting or say pure engineering task and suddenly after spending 90% of the quality time during development, you are now close to 10% of the remaining work (at least for beta release) to deploy it on production or say making it for production ready.

But now you are realizing this 10% took all the time which almost equal to 90% of overall project whatever we already spent.

Yep, Recently I've gone through same situations as above during the integration of our Swift based closed source static framework into `Objective-C project`.

>  **NOTE:** In all swift based consumer project where swift 4.2 is compatible, with them our swift 4.2 static framework working out perfectly (using our private pod setup) without a single problem.

Let's see below problem statement i.e in what situation our static framework not working out.

---

### Core Situation: 
Whenever we tried to integrate Swift 4.2 or say the latest version of Swift static framework in `Objective-C project` on the consumer app where already Swift 4.0 or say a lower version of Swift static framework in use.

### Solution: 
Whatever the old version of the swift static framework (In our case i.e Swift 4.0) your consumer using, try to tell them to upgrade it to the latest compatible version which matches with your swift static framework version (In our case i.e Swift 4.2) or gives your consumer same older version  of swift static framework (In our case i.e Swift 4.0) to match with consumer dependency static framework.

### Our State: 
As a private framework provider where you are charging a client for your service and your consumer project have major dependencies on that other older version (In our case i.e Swift 4.0) of the swift static framework.

While most of the public or open source framework provider easily reply to the above situations that use their latest version of the swift static framework to resolve this error but what about private framework provider like us, we have no other option except to give the consumer Swift 4.0 compiled static framework version to fulfill consumer requirement.

>  NOTE: Our framework conditionally coded with Swift 4.0 as well as Swift 4.2 syntax and I'm using Xcode toolchain accordingly to create the final fat framework as per our Swift version requirement.

---

Few errors which came step by step during [Core Situation](#core-situation) as below:
- [The following binaries use incompatible versions of Swift:](#001)
- [dyld: Library not loaded: @rpath/libswiftCore.dylib or dyld: Symbol not found: __T0XXX](#002)

Let me explain how I seek possible information to overwhelm from each error. 
  
>  NOTE: Nowadays I’m doing below error parameter detailing for myself only to keep track of error complexity.

---

<h3>The following binaries use incompatible versions of Swift: </h3>

### #001 

| `Error Title:` | The following binaries use incompatible versions of Swift: |
| `Error Detail:` | Exactly below text will print on build log window (light green background window) | 

>  The following binaries use incompatible versions of Swift: /Users/tpXXXXXXX/Library/Developer/Xcode/DerivedData/ProjectName-xxxxxxxx/Build/Products/Debug-iphoneos/ProjectName.app/Frameworks/your_incompatible_version_framework.framework/your_incompatible_version_framework

| `Error Responsible:` | User as well as Apple |

- Why user?
	- Check [Core Situation](#core-situation) as above.

- Why apple?
	- Maybe because, Why they are not allowing multiple version of the swift static framework in the same project

| `Error Level:` | Light |
| `Error Type`: | Expected |
| `Error References`: | [Google It](https://www.google.com/search?q=The+following+binaries+use+incompatible+versions+of+Swift:+site:stackoverflow.com) |
| `Solid Solution:` | Check [Solution](#solution) as above |
| `Workaround Solution:` | NA (Let me know if any) |

Well, after following solid solution I have to compile (using conditional swift version case statement) our swift 4.2 based static framework with swift 4.0

But don't know using [command line toolchain of swift 4.0](https://swift.org/builds/swift-4.0-release/xcode/swift-4.0-RELEASE/swift-4.0-RELEASE-osx.pkg) in Xcode 10.1 did not work out, so I'd to download Xcode 9.2 or Xcode 9.0.1 which by default use swift 4.0 in his command line toolchain.

---

<h3>dyld: Library not loaded: @rpath/libswiftCore.dylib or dyld: Symbol not found: __T0XXX</h3>

>  This is one of the most critical error happened to me ever after a long time.

NOTE : Step to reproduce bug as below: 
- Create Objective-C based project
- Import swift 4.0 based closed source static framework i.e via manual or Cocoapods


### #002 

| `Error Title:` | Library not loaded: @rpath/libswiftCore.dylib |
| `Error Detail:` | Exactly below text printed on debug screen |

>  dyld: Library not loaded: @rpath/libswiftCore.dylib
Referenced from: path_to_library_developer_core_simulator Reason: image not found

| `Error Responsible:` | Seriously don't know who is responsible for this |
| `Error Level:` | Critical |
| `Error Type`: | Unexpected |
| `Error References`: | Check below points |

- [Stackoverflow](https://www.google.com/search?q=dyld:+Library+not+loaded:+@rpath/libswiftCore.dylib+site:stackoverflow.com)
- [Github](https://www.google.com/search?q=dyld%3A+Library+not+loaded%3A+%40rpath%2FlibswiftCore.dylib+site%3Agithub.com&oq=dyld%3A+Library+not+loaded%3A+%40rpath%2FlibswiftCore.dylib+site%3Agithub.com)
- [Well there are many but this looks good](https://stackoverflow.com/questions/26104975/dyld-library-not-loaded-rpath-libswiftcore-dylib-image-not-found)

| `Solid Solution:` | On this planet, it is not possible |
| `Workaround Solution:` | Well, I'd tried so many things to get it done but nothing works out for me except following below step on `consumer app` | 

- Added below path text for **Runpath Search Paths** in **App Target->Build Settings** 
	- `${DT_TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}`

- Build status as per below Xcode version
    - Xcode 9.0.1 (`Working`)
    - Xcode 9.2 (`Working`)
    - Xcode 9.4.1 (`Not Working i.e dyld: Symbol not found: __T0XXX`)
    - Xcode 10.1 (`Not Working i.e dyld: Symbol not found: __T0XXX`)
 	
---

After following solid and workaround solution of [#001](#001) and [#002](#002) respectively, we finally able to build consumer app along with our swift 4.0 static framework.

But, I have to figure out something for error code [#001](#001) 

`Problem:` I'm using Xcode 9.0 to compile swift 4.0 based framework and Xcode 10.1 (latest) to compile swift 4.2 based framework

`Look Good Solution:` Use the latest Xcode only to build and compile our static framework for both version or any swift version.

And for error code [#002](#002)

`Problem:` I have given workaround solution to the consumer to get rid of this error i.e update `Runpath Search Paths` and use Xcode 9.0 to build project

`Look Good Solution:` Figure out something and give the consumer only pod installation instruction i.e pod `MyFramework`, '1.0.0' (for now we are using cocoapods only for our framework installation dependency)

Well, Thank you for taking the time to read this article and I'll appreciate if someone help me out to figure out above two `look good solution`.

Thanks!!