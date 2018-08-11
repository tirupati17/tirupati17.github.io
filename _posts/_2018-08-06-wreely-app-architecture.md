---
layout: post
comments: true
title: How I architect Wreely - Community Platform swift based iPhone app 
excerpt_separator:  <!--more-->
---

Hello!!

Hope all good.

Let me introduce my [Wreely - Community Platform](https://itunes.apple.com/us/app/wreely-community-platform/id1351815873?ls=1&mt=8) app architecure to you guys that How I implemented it using swift 4.0 language along with `view`, `presenter` and `protocols` way to architect this app.

>  NOTE: This is not a tutorial for any kind of architectural setup. It is just a overview of my current project architecure which I'm sharing to keep track of project standard, for colleagues and clients.

Before talking about architecture and all let me share `Tools` I have used in this project.
- [Slack](https://slack.com) `For centralized project communication`
- [Trello](https://trello.com) `For project initial to-do list, list of project screen along with use cases for each screen, future plan etc`
- [GitLab Issues](https://docs.gitlab.com/ee/user/project/issues/) `For project issue tracking (Kanban style board)`
- [GitLab CI](https://about.gitlab.com/features/gitlab-ci-cd/) `For continuous integration`
- [GitLab](https://gitlab.com) `For version control`
- [Codacy](https://www.codacy.com/) `For code review`

Now as per below list of GitLab issue list I will explain what I had did in that issue commit using issue number.

1. Initial project setup
2. Setup network, database, analytics and basic utilities library via dependency manager `cocoapods`
3. Setup network connection manager via `Alamofire` as base library
4. Setup class model as per network response using `Mappable`
5. Setup initial extensions for native controls & class
6. Setup helper class for logger, theme, analytics, error, constant and session
7. Setup base class and protocols for in-built view controllers and UI classes
8. Splash view controller implementation using `view`, `presenter` and `protocols` architecture

 ---

<h3>Initial project setup</h3>

1. Created project via latest Xcode with init git repo
2. Folder structure as below - `Improving it everyday`
3. Except root and test folder all other folder name starts with `WS` (project initial)  


{% gist a7f034251ac16d6580e3948c12f08067 %}

 ---

<h3> Setup network, database, analytics and basic utilities library via dependency manager </h3>

For dependency manager, I have used cocoapods

The content of Podfile as below - `Improving it everyday`

{% gist dca6ca03cea525140629eea9815e68ac %}

 ---

<h3> Setup network connection manager via Alamofire as base library </h3> 

It includes implementation of below:

`Create API request class which handle common HTTP request parameter like below`

- Url string
- Http Method    
- Request parameter 
- Post Data (For image or any binary data)
- Pass success/failure closure so once network connection manager get a response from the server it will inform this class 

{% gist 585a12c95a604f2c2e8527d73b742dce %}

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

{% gist eef249131d592f2d5b373f910a73dbe4 %}

**Other utilities this class handles:**

- Network reachability implementation
- Which request should read or not like for login and sign up it should not check for a valid session for all other requests you should check for a valid token before performing it

`Create HTTP session manager class (Should inherit from SessionManager- Alamofire if you are using it)`

- Perform actual network request via the third party library i.e Alamofire or Apple native one to handle session request 
- Perform GET, POST, PUT etc based on API Request class details
- Get full path of URL using API Request class and constant base URL

{% gist 31bb59e4866ab89dacbbe4524a7f4aee %}

 ---

<h3> Setup class model as per network response using Mappable</h3>

As previously in Objective-C I always create model using `Interfaces` but in swift I mostly use `Struct` as because of it's immutable behaviour and allocation on stack.(As we know stack is used for static memory allocation and Heap for dynamic. Variables allocated on the stack are stored directly to the memory and access to this memory is very fast).

Check below struct model as used in project for `User` model

{% gist 4591e802e9f36c79dbd032ecad2da563 %}

 ---

<h3> Setup initial extensions for native controls & class </h3>

Swift has amazing set of open source extensions library which you can use via dependency manager cocoapods or carthage.

Few good libraries for extensions are as below: 
- [SwifterSwift](https://github.com/SwifterSwift/SwifterSwift)
- [EZSwiftExtensions](https://github.com/goktugyil/EZSwiftExtensions)

In Wreely based on type I have created project necessary extensions only as per below folder structure.

{% gist 02a67132058bc472f94492006287867e %}

> Soon will open source this project then you can easily see content of this extensions and all other files.

 ---

<h3> Setup helper class for logger, analytics, error and session </h3>

<h4>Logger</h4>
My logger class as below which depend on [Log](https://github.com/delba/Log) library - An extensible color logging framework for Swift:
{% gist 13a034925780d71d4cbc6226da3ab1ac %}

`How to use:`

Call below WSLogger class method directly from anywhere along with optional error type:
{% highlight swift %}
WSLogger.log(errorMessage, logType: .kError)
{% endhighlight %}

<h4>Analytics</h4>
Customized analytics class for this project which cover `OneSignal`, `Mixpanel`, `Answers` and `Firebase` via one method.
{% gist 223a33945afbde200300abd6f63d5520 %}

`How to use:`

One should call `WSTracking.sharedTracking.setupInitialTracking()` from login or signup or any start controller after initialization of all supported analytics library in appDelegate 

<h4>Error handle</h4>
Error handler helper class as below which used in project.

{% gist 7b097bd85fe3775fdbabf1d8f98d9281 %}

`How to use:`

You have to initialize WSError object with customize message as below: 
{% highlight swift %}
let error: LocalizedDescriptionError = WSError.customError(message: "Custom error here")
{% endhighlight %}

Later call default `localizedDescription` protocol to get this custom message.
{% highlight swift %}
print(error.localizedDescription)
{% endhighlight %}

<h4>Session management</h4>

Wreely session management is fully depend on user based `access_token` key of UserDefault object. If exist it will fetch user details from server during splash screen load and if not it will skip to otp login screen.

All other internal endpoints need this `access_token` to get valid response.

See below implementation of WSSession class 
{% gist 68dc20c99f9939b9fca2d73e9213a6ee %}

`How to use:`

1. After successful access token response from server save it on session class via session manager singleton class
{% highlight swift %}
WSSessionManager.sessionManager.setAccessToken(response["access_token"] as! String)
{% endhighlight %}

2. Once session is saved now you have to call user detail endpoint to save user object in current session via WSSessionManager
{% highlight swift %}
WSSessionManager.sessionManager.setCurrentUser(userObject)
{% endhighlight %}

3. To get the active current user just call `activeSession` class func of `WSSession` where it will fetch current active session object via singleton class of WSSessionManager and then call `currentUser` instance func
{% highlight swift %}
WSSession.activeSession().currentUser()
{% endhighlight %}

4. For logout call `logout` use as below which uses same way to get WSSession object as explained above:
{% highlight swift %}
WSSession.activeSession().logout()
{% endhighlight %}

<h3> Setup base class and protocols for in-built view controllers and UI classes </h3>

As we know swift is protocol oriented programming (POP) rather than object oriented programming(OOP) which gives him ability to do more with protocol declaration.

We can:
1. Inherit protocols
2. Create extension
3. Even type cast it

In Wreely I have used protocols for each view controller via `view` and `presenter` as both confirming to each other protocol and calling protocol methods whenever necessary.

Let me give you simple example of WSOTPView module which contain below files.
1. WSOTPProtocol.swift  
2. WSOTPView.swift
3. WSOTPPresenter.swift
4. WSOTPCell.swift

Check below WSOTPProtocol implementation where `WSOTPViewProtocol` and `WSOTPPresenterProtocol` initiated which will later adopted by WSOTPView and WSOTPPresenter respectively 

{% gist 3f8bb367e096c83e9689155eccb49dee %}

Once above protocol initiated now let's see WSOTPView implementation which adopted WSOTPViewProtocol methods which will call by WSOTPPresenter whenever necessary. 

{% gist f64e0db0f1365c9ab249ca387948c984 %}

Same way you can see WSOTPPresenter implementation which adopted WSOTPPresenterProtocol methods which will call by WSOTPView as whenever necessary.

{% gist 7c43d2fa8100b5ee48a9c07eb3876669 %}

Along with above view design pattern I have used storyboard for UI view and even for table view cells responsibility. Check below `WSOTPCell` implementation which is implemented using storyboard outlet.

{% gist 073712b21117c2499a682b27f4b3a728 %}

`WSOTPCell` inherited by `WSTableViewCell` which has below implementation

{% gist 6d229ced8d5623662bbc730b3ee56998 %}

