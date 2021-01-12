---
layout: default
---

### Hi, I'm a **Ruby & Elixir** developer, and this is my **blog**.

{% for post in site.posts %}

<br />

# [{{ post.title }}]({{ post.url | prepend: site.baseurl }})

*{{ post.date | date: "%b %-d, %Y" }}{% if post.tags != empty %}{{ post.tags| array_to_sentence_string | prepend: ' -- '}}{% endif %}*

{{ post.excerpt }}
[more ...]({{ post.url | prepend: site.baseurl }})

{% endfor %}
