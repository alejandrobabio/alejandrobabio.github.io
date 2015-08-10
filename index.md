---
layout: default
---

### Hi, I'm **Alejandro Babio**. I'm a **Ruby on Rails** developer, and this is my **blog**.

## Posts

{% for post in site.posts %}
* {{ post.date | date: "%b %-d, %Y" }}
[{{ post.title }}]({{ post.url | prepend: site.baseurl }})
{% endfor %}

