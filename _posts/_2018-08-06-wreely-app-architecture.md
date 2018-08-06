---
layout: post
comments: true
title: How I setup `Wreely - Community Platform` app 
excerpt_separator:  <!--more-->
---

Hello!!

Hope all good.

Let me introduce my [Wreely - Community Platform](https://itunes.apple.com/us/app/wreely-community-platform/id1351815873?ls=1&mt=8) app architecure to you guys that How I implemented it using swift 4.0 language along with `view`, `presenter` and `protocols` way to architect this app.

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

<h3> Setup network, database, analytics and basic utilities library via dependency manager </h3>

For dependency manager, I have used cocoapods

The content of Podfile as below - `Improving it everyday`

{% gist dca6ca03cea525140629eea9815e68ac %}

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

<h3> Setup class model as per network response using [Mappable]() </h3>

As previously in Objective-C I always create model using `Interfaces` but in swift I mostly use `Struct` as because of it's immutable behaviour and allocation on stack.(As we know stack is used for static memory allocation and Heap for dynamic. Variables allocated on the stack are stored directly to the memory and access to this memory is very fast).

Check below struct model as used in project for `User` model

{% gist 4591e802e9f36c79dbd032ecad2da563 %}

<h3> Setup initial extensions for native controls & class </h3>

Swift has amazing set of open source extensions library which you can use via dependency manager cocoapods or carthage.

Few good libraries for extensions are as below: 
- [SwifterSwift](https://github.com/SwifterSwift/SwifterSwift)
- [EZSwiftExtensions](https://github.com/goktugyil/EZSwiftExtensions)

In Wreely based on type I have created project necessary extensions only as per below folder structure.

{% gist 02a67132058bc472f94492006287867e %}

> Soon will open source this project then you can easily see content of this extensions and all other files.

<h3> Setup helper class for logger, theme, analytics, error and session </h3>
