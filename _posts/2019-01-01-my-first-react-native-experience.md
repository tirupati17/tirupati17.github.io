---
layout: post
comments: true
title: My first react-native app experience via forking open source project
excerpt_separator:  <!--more-->
---

Long back ago I had built [SIPCalculator](https://github.com/tirupati17/sip-calculator-swift) for iOS using simple swift language based on Apple MVC architecture and somewhere always wanted to build similar for Android.

Now I have found similar open source project in react-native i.e [gas-oil-mixture-mobile](https://github.com/filippofilip95/gas-oil-mixture-mobile) on GitHub which somewhere looks like [SIPCalculator](https://github.com/tirupati17/sip-calculator-swift) requirement and I will try to rebuild my SIPCalculator based on this [gas-oil-mixture-mobile](https://github.com/filippofilip95/gas-oil-mixture-mobile) code base only.

So a few steps I have performed to first build this open source project (As a beginner rect-native developer)

---
NOTE: First of all even before forking actual project I have installed basic things for developing any react native app via official FB react-native [reference](https://facebook.github.io/react-native/docs/getting-started.html)

Below 3 commands is basically most important before starting any react-native app i.e

{% highlight shell %}
$ brew install node
$ brew install watchman (Optional but recommended by Facebook to keep track of file changes)
$ npm install -g react-native-cli
{% endhighlight %}

Also tried to create test App as per init command 
{% highlight shell %}
$ react-native init TestProject
{% endhighlight %}

After init cd to created project i.e cd /TestProject and performed most important run-ios command as below
{% highlight shell %}
$ react-native run-ios 
{% endhighlight %}

As I’m an iOS developer so I already have Xcode in my system so above command works fine and after few terminal text output my simulator got open and I easily saw my first react native app i.e TestProject on my iOS simulator 

---

Now I’ve to build cloned react-native project which I have forked from actual repo so let's discuss step by step 

- I forked it from [gas-oil-mixture-mobile](https://github.com/filippofilip95/gas-oil-mixture-mobile)
- Now I cloned it using my own version of [gas-oil-mixture-mobile](https://github.com/tirupati17/gas-oil-mixture-mobile) GitHub project URL after fork
- Jumped to cloned directory i.e `cd /gas-oil-mixture-mobile`
- I did  `yarn install` on my terminal out of two available option as per readme instructions of [gas-oil-mixture-mobile](https://github.com/filippofilip95/gas-oil-mixture-mobile) i.e `$ yarn install or $ npm i`

>  Install yarn if you don’t have it `brew install yarn` [As per official reference site](https://yarnpkg.com/lang/en/docs/install/#mac-stable)

- Now `yarn` installed in my system and have performed `yarn start` command on my terminal
- Got `Loading dependency graph, done.` message on the terminal (Looks like everything works fine) and suddenly faced an error on the simulator as below

>  NOTE: Nowadays I'm doing below error parameter detailing for myself only to keep track of error complexity.

---

`Error Code:` #001 <br/>
`Error Title:` bundling failed: Error: Unable to resolve module <br/>
`Error Detail:` bundling failed: Error: Unable to resolve module i.e /node_modules/react-native/Libraries/Animated/src/AnimatedImplementation.js file not exist <br/>
`Error Responsible:` System (As Happening to too many users but un-expected way as per error references) <br/>
`Error Level:` Critical (As per error references) <br/>
`Error Type:` Unexpected <br/>
`Error References:` https://github.com/facebook/react-native/issues/11257 <br/>
`Solid Solution:` NA (Let me know if there is any) <br/>
`Workaround Solution:` https://github.com/facebook/react-native/issues/11498 <br/>

---

- Seriously this error stopped me to continue react-native development for a while (But anyhow I had taken few minute breaks and started to solve this error again and workaround solution worked for me `as below`

>  As per error [workaround solution](https://github.com/facebook/react-native/issues/11498) reference

---

1. Click "Reset content and settings..." in the simulator's drop-down menu and confirm
2. Close the simulator after it reloads
3. Close the terminal window running watchman
4. Run the following commands within terminal inside of your project's directory:

{% highlight shell %}
$ watchman watch-del-all
$ rm -rf ./node_modules
$ npm cache clean
$  yarn cache clean
$ rm -rf $TMPDIR/react-*
$ yarn install
$ npm cache clean
$ yarn cache clean
$ yarn add uuid
{% endhighlight %}

---

- After running above instructions and command step by step `Unable to resolve module` error gone but a new error comes to over my face `as below`
 
---

`Error Code:` #002 <br/>
`Error Title:`  bundling failed: Error: While resolving module <br/>
`Error Detail:` bundling failed: Error: While resolving module `react-native-vector-icons/MaterialCommunityIcons`, the Haste package `react-native-vector-icons` was found. However the module `MaterialCommunityIcons` could not be found within the package. Indeed, none of these files exist: <br/>
`Error Responsible:` System (As Happening to too many users but un-expected way as per error references) <br/>
`Error Level:` Critical (As per error references) <br/>
`Error Type:` Unexpected <br/>
`Error References:` https://github.com/oblador/react-native-vector-icons/issues/626 <br/>
`Solid Solution:` NA (Let me know if there is any) <br/>
`Workaround Solution:` https://github.com/oblador/react-native-vector-icons/issues/626#issuecomment-357405396 <br/>

---

- Again workaround solution worked for me `as below`
{% highlight shell %}
rm ./node_modules/react-native/local-cli/core/__fixtures__/files/package.json
{% endhighlight %}

>  As per error [workaround solution](https://github.com/oblador/react-native-vector-icons/issues/626#issuecomment-357405396) reference


Finally, after figuring out above two error i.e `#001` and `#002` my forked cloned project worked fine on simulator.

Well, for now, this is only I have done which took me honestly 2 hrs approximately for overall things. Now I have to change this working project string, unit calculations and few functionalities as per [SIPCalculator](https://github.com/tirupati17/sip-calculator-swift) which seriously I don't know how much time it will gonna take so again on my free time will try to do next changes related things as per this react-native project standard (which looks good) and will post my overall experience. 

Thanks!!
