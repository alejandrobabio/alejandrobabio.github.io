---
layout: post
title:  "Make youtube links work with Jekyll & Github Pages"
categories: jekyll github_pages youtube
tags: snippets
---

I try with the [youtube plugin][youtube_plugin]{:target="_blank"}. It works fine at my local machine, but it does not at Github Pages ([official documentation][github_plugin]{:target="_blank"}).

Them I did it with some coffeescript.

* At the markdown post, I added this small HTML snippet `<div id="youtube_video_id" class="youtube"></div>`.
<!--more-->
* At `_includes/footer.html`, which is called at my `default` layout. I put this line:
`<script src="/assets/js/youtube.js"></script>`
* And add this new file: `assets/js/youtube.coffee`
{% highlight coffeescript %}
---
---

$ ->
  $('.youtube').each ->
    width = 560
    height = 420
    $(@).append "<iframe width=\"#{width}\" height=\"#{height}\" src=\"http://www.youtube.com/embed/#{@id}\" frameborder=\"0\" allowfullscreen></iframe>"
{% endhighlight %}

Some advices here: the file must start with 2 lines of `---`. Since the file has extension `.coffee`, the script at src requires the same file with extension `.js`.


[youtube_plugin]: https://gist.github.com/joelverhagen/1805814
[github_plugin]: https://help.github.com/articles/using-jekyll-plugins-with-github-pages
