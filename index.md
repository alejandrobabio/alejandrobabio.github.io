---
layout: default
---

### Hi, I'm a **Ruby on Rails** developer, and this is my **blog**.

# Posts

{% for post in site.posts %}
## [{{ post.title }}]({{ post.url | prepend: site.baseurl }})
*{{ post.date | date: "%b %-d, %Y" }} -- {{ post.tags| array_to_sentence_string }}*
{{ post.excerpt }}
{% endfor %}
