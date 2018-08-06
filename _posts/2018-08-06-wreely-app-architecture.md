---
layout: post
comments: false
title: How I setup `Wreely - Community Platform` app architecture 
# excerpt_separator:  <!--more-->
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
- [Codacy](https://www.codacy.com/) `For code review`

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

{% github_sample_ref /tirupati17/wreely-social-iphone/blob/master/Podfile %}
{% highlight ruby %}
{% github_sample /tirupati17/wreely-social-iphone/blob/master/Podfile 0 26 %}
{% endhighlight %}

<h3> Setup network connection manager via Alamofire as base library </h3> 

It includes implementation of below:

`Create API request class which handle common HTTP request parameter like below`

- Url string
- Http Method    
- Request parameter 
- Post Data (For image or any binary data)
- Pass success/failure closure so once network connection manager get a response from the server it will inform this class 

{% github_sample_ref tirupati17/wreely-social-iphone/blob/master/WreelySocial/Classes/WSLibrary/WSConnection/API/WSAPIRequest.swift %}
{% highlight ruby %}
{% github_sample tirupati17/wreely-social-iphone/blob/master/WreelySocial/Classes/WSLibrary/WSConnection/API/WSAPIRequest.swift %}
{% endhighlight %}

**Filename Standard**: Project two main initial capital word(2 Letters) + APIRequest i.e If your project name is Facebook then name should be `FBAPIRequest` 

**Other utilities this class handles:** 
- Request pagination (page number and per page)
- Which core data or realm model should be used based on a request type
- Create detail error dictionary return method because here only you are getting request parameter and response object

`Create network connection manager class`

- Initiate HTTP session manager class from here based on a request parameters getting from API request  
- Pass success/failure closure so once session manager get a response from the server it will inform this class 
- This class must synthesize(get/set) a singleton class of self
- Once got a response via session manager class handle it here and call a database manager (singleton class) response handler method 

{% github_sample_ref tirupati17/wreely-social-iphone/blob/master/WreelySocial/Classes/WSLibrary/WSConnection/API/WSConnectionManager.swift %}
{% highlight ruby %}
{% github_sample tirupati17/wreely-social-iphone/blob/master/WreelySocial/Classes/WSLibrary/WSConnection/API/WSConnectionManager.swift %}
{% endhighlight %}

**Other utilities this class handles:**

- Network reachability implementation
- Which request should read or not like for login and sign up it should not check for a valid session for all other requests you should check for a valid token before performing it

`Create HTTP session manager class (Should inherit from SessionManager- Alamofire if you are using it)`

- Perform actual network request via the third party library i.e Alamofire or Apple native one to handle session request 
- Perform GET, POST, PUT etc based on API Request class details
- Get full path of URL using API Request class and constant base URL

{% github_sample_ref tirupati17/wreely-social-iphone/blob/master/WreelySocial/Classes/WSLibrary/WSConnection/API/WSHTTPSessionManager.swift %}
{% highlight ruby %}
{% github_sample tirupati17/wreely-social-iphone/blob/master/WreelySocial/Classes/WSLibrary/WSConnection/API/WSHTTPSessionManager.swift %}
{% endhighlight %}