---
layout: default
---

### Hi, I'm a **Ruby on Rails** developer, and this is my **blog**.

# Posts

{% for post in site.posts %}
## [{{ post.title }}]({{ post.url | prepend: site.baseurl }})
*{{ post.date | date: "%b %-d, %Y" }}{% if post.tags != empty %}{{ post.tags| array_to_sentence_string | prepend: ' -- '}}{% endif %}*
{{ post.excerpt }}
{% endfor %}
