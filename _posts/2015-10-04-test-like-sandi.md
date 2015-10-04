---
layout: post
title: "Test like Sandi"
categories: learn ruby
tags: learn ruby
---

###After seen Sandi Metz's [The magic tricks of testing][tmtot]{:target='_blank'} advice on testing, you will want to test the way she does.

<br />

<div class="youtube" id="URSWYvyc42M"></div>

<br />

<!--more-->

###This is the basic idea:

* The public methods of your class (the public API), must be tested
* The private methods don't need be tested

###Summary of tests to do:

* The incoming query methods, test the result
* The incoming command methods, test the direct public side effects
* The outgoing command methods, expect to send
* Ignore: send to self, command to self, and queries to others

Taken from the [slides][slides]{:target='_blank'} of the conference.

[slides]: https://speakerdeck.com/skmetz/magic-tricks-of-testing-railsconf
[tmtot]: http://confreaks.tv/videos/railsconf2013-the-magic-tricks-of-testing
