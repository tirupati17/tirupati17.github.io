---
layout: post
comments: true
title: How I setup `Wreely - Community Platform` app architecture 
excerpt_separator:  <!--more-->
---

Hello!!

Hope all good.

Let me introduce my [Wreely - Community Platform](https://itunes.apple.com/us/app/wreely-community-platform/id1351815873?ls=1&mt=8) app architecure to you guys that How I implemented it using swift 4.0 language along with `view`, `presenter` and `protocols` way to architect this app.

Before talking about architecture and all let me share `Tools` I have used in this project.
- [Slack](https://slack.com) `For centralized project communication`
- [Trello](https://trello.com) `For project initial to-do list, list of project screen along with use cases for each screen, future plan etc`
- [GitLab Issues](https://docs.gitlab.com/ee/user/project/issues/) `For project issue tracking (Kanban style board)`
- [GitLab CI](https://about.gitlab.com/features/gitlab-ci-cd/) `For continues integration`
- [GitLab](https://gitlab.com) `For version control`

Now as per below list of GitLab issue list I will explain what I had did in that issue commit using issue number.

1. Initial project setup
2. Setup network, database, analytics and basic utilities library via dependency manager [cocoapods]()
3. Setup network connection manager via [Alamofire]() as base library
4. Setup class model as per network response using [Mappable]()
5. Setup initial extentions and protocols for native controls & class
6. Setup helper class for logger, theme, analytics, error and session
7. Setup base class for in-built view controller and UI class
8. Splash view controller implementation using `view`, `presenter` and `protocols` architecture

---
<h3>Initial project setup</h3>

1. Created project via latest Xcode with init git repo
2. Folder structure as below - `Improving it everyday`
3. Except root and test folder all other folder name starts with `WS` (project initial)  

```
- WreelySocial (Folder)
      - .xcodeproj
      - WreelySocialTest (Folder)
      - WreelySocialUITest (Folder)
      - WreelySocial (Folder)
            - Base.lproj
            - Classes
                 - Constant.swift (Error code, debug flag, beta flag, app color theme code,  any app constant string and number flag)
                 - Common (Folder)
                     - Extension
                     - Protocols
                 - Libary (Folder)
                     - HelperClass (Theme, Session, Logger, Tracking, Error)
                     - Connections
                         - Network
                         - Database (Use coredata or realm)
                         - Request
                         - Realtime Database (Only If you are using Firebase)
                     - View (Create subclass of every basic useful control i.e UIViewController, UITableViewController, UIButton, UIImageView, UINavigationController)
                     - Models
                         - Class (Folder)
                         - CoreData or Realm (Folder)
                         - FireBase (Folder)
            - Resource
                 - Assets.xcassets (Apple assets)
                 - Fonts (Folder)
                 - Images (Folder) //Recommend to use Assets.xcassets images 
                 - Info.plist (Project Info plist)
```

<h3> Setup network, database, analytics and basic utilities library via dependency manager </h3>

For dependency manager, I have used cocoapods

The content of Podfile as below - `Improving it everyday`

```
platform :ios, :deployment_target => "9.1"
use_frameworks!

def pods
    
    #analytics
    pod 'Fabric'
    #pod 'Crashlytics' #if enable along with Answers then may be will show dublicate symbol error
    pod 'Answers'
    pod 'Mixpanel-swift'

    #database
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'

    #pod 'Firebase/Performance'

    #notification
    pod 'OneSignal', '>= 2.6.2', '< 3.0'

    #network
    pod 'Alamofire', '~> 4.5'
    
    #image
    pod 'Kingfisher'
    pod 'Letters'

    #datepicker
    pod 'ScrollableDatepicker', :git => 'https://github.com/iamjason/ScrollableDatepicker', :branch => 'swift-4'

    #parser
    pod 'SwiftyJSON'
    
    #logger
    pod 'Log' #colorfull log based on type
    
    #alert
    pod 'SCLAlertView'
    pod 'Toast-Swift', '~> 3.0.1'
    pod 'NotificationBannerSwift' # not in use
    
    #indicator
    pod 'NVActivityIndicatorView'

    #rx
    pod 'RxSwift',    '~> 4.0'

    #model
    pod 'ObjectMapper', '~> 3.1'

    #auto-layout
    pod 'SnapKit', '~> 4.0.0'
    
    #form-builder
    pod 'Eureka'
    
    #animation
    pod 'RevealingSplashView' # not in use
    pod 'ParallaxHeader', '~> 2.0.0'
    pod 'EMSpinnerButton' # not in use
    pod 'Spring', :git => 'https://github.com/MengTo/Spring.git' # not in use

    #utilities
    pod 'SwiftyUserDefaults'
    pod 'InteractiveSideMenu'
    pod 'FontAwesome.swift'
    pod 'ListPlaceholder'
    pod 'SwiftLint'
    pod 'PopupDialog', '~> 0.7'
    pod 'LBTAComponents'
    
    #pod 'ChameleonFramework/Swift' use for theme

    #design
    pod 'Material', '~> 2.0'
    pod 'CocoaLumberjack/Swift' # not in use

end

target 'WreelySocial' do
    pods
end

target 'WreelySocialTests' do
#    target "WreelySocialTests"
#    target "WreelySocialUITests"

    pod 'Quick'
    pod 'Nimble'
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.1'
        end
    end
end
```