---
layout: post
comments: true
title: Publish closed source framework using CocoaPods
excerpt_separator:  <!--more-->
---

Well, I’m writing this article based on my own recent experience while I have to upload my closed source compiled framework on CocoaPods means there is no public repo URL except one .framework file along with a license.

Below articles helped me a lot to finish uploading my closed source framework on CocoaPods.

- [Getting setup with trunk](https://guides.cocoapods.org/making/getting-setup-with-trunk.html) - `Official reference`
- [Private cocoapods](https://guides.cocoapods.org/making/private-cocoapods.html) - `Official reference`
- [Eladnava](https://eladnava.com/publish-a-universal-binary-ios-framework-in-swift-using-cocoapods/) - `Third party reference`
- [Telerik](https://www.telerik.com/blogs/how-to-use-a-third-party-framework-in-a-private-cocoapod) - `Third party reference`

After going through all above articles I have still faced few issues like below

- Unexpected version directory 
- Wrong `.source file` error
- Invalid `.public_header_files`
- Not validating `.homepage` url 
- Specification does not validate
  
and so on but one thing I have realized all problems are related to .podspec file only which I’m facing whenever I’m validating spec file through pod lint command i.e  `pod spec lint`

---

Let’s discuss step by step how I have created perfect working podspec file and uploaded my .framework successfully 

- If possible go through [this article](https://www.tirupatibalan.com/2019/01/05/create-fat-framework.html) where I have explained how one could create a universal framework.

- Once you have done with framework create process (`as per point 1`) you have to create `MyFramework.podspec` file in your project directory.

Paste the below content inside it:

{% highlight ruby %}
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
{% endhighlight %}


If above spec file works out for you and if it passed `pod spec lint` command on your terminal then think 90% of your upload headache passed out.

>  During `.podspec` validation I have faced validation of `.homepage` parameter [Error reference](https://github.com/CocoaPods/CocoaPods/issues/2795) so anyhow instead solving it I used `--allow-warnings`  in pod lint validation command as below

{% highlight shell %}
pod spec lint --allow-warnings
{% endhighlight %}

- Now create a zip archive of your `MyFramework.framework` and `LICENSE` through zip command as below

{% highlight shell %}
zip -r MyFramework.zip LICENSE MyFramework.framework 
{% endhighlight %}

>  For licence file content follow [this](https://raw.githubusercontent.com/eladnava/mailgen/master/LICENSE) special thanks to [eladnava](https://github.com/eladnava)

- Upload your MyFramework.zip file on your server and copy the path of uploaded zip file like below which will in use for `s.source` parameter 

{% highlight ruby %}
https://example.com/download/ios_sdk/1.0.1/MyFramework.zip
{% endhighlight %}

>  I have used [Firebase Private Hosting](https://firebase.google.com/docs/hosting/) for .zip file upload and [Dillinger](https://dillinger.io/) for my installation documentation especially for a client where you can easily create styled HTML, pdf file using simple markdown language.

- For publishing your `.podspec` file you have to authenticate and use CocoaPods API service i.e [CocoaPods Trunk](https://guides.cocoapods.org/making/getting-setup-with-trunk.html)

Follow below command to register yourself [Reference](https://guides.cocoapods.org/making/getting-setup-with-trunk.html#getting-started)

{% highlight shell %}
pod trunk register you@youremail.com ‘Your organization name' 
{% endhighlight %}

>  You can list your sessions by running `pod trunk me`

- Now finally follow below last command to push your `.podspec` on CocoaPods server [Reference](https://guides.cocoapods.org/making/getting-setup-with-trunk.html#deploying-a-library)

{% highlight shell %}
pod trunk push MyFramework.podspec
{% endhighlight %}

After following all above step successfully I’m sure now you are ready to test your pod installation through any test project, Just add below line in your `.podfile` and run `pod install` command

{% highlight ruby %}
pod 'MyFramework', '1.0.0'  
{% endhighlight %}

That's it!!!!! 

You are done!!!<br/>
Cheers!!!!
