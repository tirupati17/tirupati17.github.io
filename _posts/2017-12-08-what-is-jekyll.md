---
layout: post
title: What is GitHub Pages, Jekyll, Poole, Hyde and Hydeout?
excerpt_separator:  <!--more-->
---

Hello, Hope all good!

<p>This is the first post on my personal blog and I want everyone to know how I setup this site using Jekyll and GitHub Pages. </p>

Please read below things step by step as per their reference source and get to know about this. Good Luck!!

<h4>What is GitHub Pages?</h4>

GitHub Pages is a static site hosting service.

> GitHub Pages is designed to host your personal, organization, or project pages directly from a GitHub repository.<br>
> You can create and publish GitHub Pages online using the Jekyll Theme Chooser.

> GitHub Pages is a static site hosting service and doesn't support server-side code such as, PHP, Ruby, or Python.

<a href="https://help.github.com/articles/what-is-github-pages/">Reference</a>

<h4>What is Jekyll?</h4>
[Jekyll](http://jekyllrb.com) is a simple, blog-aware, static site generator for personal, project, or organization sites. Written in Ruby by Tom Preston-Werner, GitHub's co-founder, it is distributed under an open source license.

> Instead of using databases, Jekyll takes the content, renders Markdown or Textile and Liquid templates, and produces a complete, static website ready to be served by Apache HTTP Server, Nginx or another web server.

> Jekyll is the engine behind <a href="https://pages.github.com/">GitHubPages</a>, a GitHub feature that allows users to host websites based on their GitHub repositories.

<a href="https://en.wikipedia.org/wiki/Jekyll_(software)">Reference</a>

Few useful article's related to Jekyll and GitHub Pages:<br>
<a href="https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/">Setting up your GitHub Pages site locally with Jekyll</a> <br>
<a href="https://programminghistorian.org/lessons/building-static-sites-with-jekyll-github-pages">Building a static website with Jekyll and GitHub Pages</a>

 ---

<h4>Meet Poole</h4>

[Poole](http://getpoole.com)  is the butler for Jekyll, the static site generator.

> It's designed and developed by [@mdo](https://markdotto.com) to provide a clear and concise foundational setup for any Jekyll site.<br>It does so by furnishing a full vanilla Jekyll install with example templates, pages, posts, and styles.

<a href="http://getpoole.com/">Reference</a>

---

<h4>Hyde?</h4>

[Hyde](https://github.com/poole/hyde) is a brazen two-column Jekyll theme that pairs a prominent sidebar with uncomplicated content. It's based on Poole, the Jekyll butler.

> Hyde is a theme built on top of Poole, which provides a fully furnished Jekyll setup—just download and start the Jekyll server.

<a href="https://github.com/poole/hyde">Reference</a>

---

<h4>Finally Hydeout?</h4>

[Hydeout](https://github.com/fongandrew/hydeout) updates the original Hyde theme for Jekyll 3.x and adds new functionality.

Hydeout is available as the `jekyll-theme-hydeout` Ruby Gem.<br> Add `gem "jekyll-theme-hydeout", "~> 3.4"` to your Gemfile and run `bundle install`

Hydeout uses pagination, so if you have an `index.md`, you'll need to swap it with an `index.html` that uses the index layout:

{% highlight liquid %}
---
layout: index
title: Home
---
{% endhighlight %}

Find out more by [visiting the project on GitHub](https://github.com/fongandrew/hydeout).
