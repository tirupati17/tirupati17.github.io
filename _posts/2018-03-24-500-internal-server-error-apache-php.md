---
layout: post
comments: true
title: Internal Server Error - Invalid command 'RewriteEngine' (Ubuntu Apache/PHP)
excerpt_separator:  <!--more-->
---

What is Internal Server Error?

>  <b> It usually a server misconfiguration (check .htaccess file) or problem with your server side script. </b>

First of all check for error log

{% highlight liquid %}
$   sudo vim /var/log/apache2/error.log 
{% endhighlight %}

If log file become empty then enable it via php.ini  

{% highlight liquid %}
For php7
$ sudo vim /etc/php/7.0/apache2/php.ini 

or

For php5
$ sudo vim /etc/php5/apache2/php.ini 
{% endhighlight %}

Find display_errors, display_startup_errors , error_reporting  (Which look's like below) 

{% highlight liquid %}
;display_errors
;   Default Value: On
;   Development Value: On
;   Production Value: Off

;display_startup_errors
;   Default Value: Off
;   Development Value: On
;   Production Value: Off

;error_reporting
;   Default Value: E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED
;   Development Value: E_ALL
;   Production Value: E_ALL & ~E_DEPRECATED & ~E_STRICT
{% endhighlight %}

Uncomment it via removing semicolons (After change it will look like below)

{% highlight liquid %}
display_errors
;   Default Value: On
;   Development Value: On
;   Production Value: Off

display_startup_errors
;   Default Value: Off
;   Development Value: On
;   Production Value: Off

error_reporting
;   Default Value: E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED
;   Development Value: E_ALL
;   Production Value: E_ALL & ~E_DEPRECATED & ~E_STRICT
{% endhighlight %}

Restart apache via below command 

{% highlight liquid %}
$ sudo service apache2 restart 

or

$ sudo /etc/init.d/apache2 restart 
{% endhighlight %}

Now check in error.log file for Internal Server related problem.

---

If in error log you got module related problem like below: 

 > /var/www/html/.htaccess: Invalid command 'RewriteEngine', perhaps misspelled or defined by a module not included in the server configuration  

Then perform below command for above error which enable rewrite module of apache2:

{% highlight liquid %}
$ sudo a2enmod rewrite && sudo service apache2 restart
{% endhighlight %}

That's it. You are done :)

{% include adsense.html %}