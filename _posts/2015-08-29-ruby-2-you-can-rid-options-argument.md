---
layout: post
title:  "Ruby 2: You can rid options argument"
categories: ruby
tags: ruby
---

Ruby 2 improved the support to keyword arguments. You can define your method with the default hash params as `*args`, and rid the `options = {}`. And no more need of `options.reverse_merge(default_options)`.

{% highlight ruby %}
def foo(bar: 'initial')
  puts bar
end

foo # => 'initial'
foo(bar: 'final') # => 'final'
{% endhighlight %}

Required arguments: you need a colon after the key (also you need ruby 2.1)
<!--more-->

{% highlight ruby %}
def foo(bar:)
  puts bar
end

foo # => ArgumentError: missing keyword: bar
foo(bar: 'baz') # => 'baz'
foo(bar: nil) # => "\n"
              # don't show error, nil is a valid value for bar
{% endhighlight %}

Optional arguments: just set the default to `nil`

{% highlight ruby %}
def foo(bar: nil, baz: 'aaa')
  puts "#{bar}:#{baz}"
end

foo # => ':aaa'
foo(baz: 'zab') # => ':zab'
foo(bar: 'rab', baz: 'zab') # => 'rab:zab'
foo(bin: 'bin') # => ArgumentError: unknown keyword: bin
foo(baz: nil) # => ':'
{% endhighlight %}

Also you can use the standard positional args with this new hash parameters notation. You will find more information at this [blog][blog]{:target='_blank'} and at the [official][ruby_oficial]{:target='_blank'} documentation.

**Bonus**: The refactor is easy because you can rid the options hash of your method without changing it's callers. But... this is not completely true, if you have a call with an unexpected option you will get an error: `ArgumentError: unknown keyword: <the_invalid_arg>`. And of course, calling with `nil` parameter is not the same of calling without it, you'll lose the default value because `nil` is a valid one.

[blog]: https://robots.thoughtbot.com/ruby-2-keyword-arguments
[ruby_oficial]: https://ruby-doc.org/core-2.2.2/doc/syntax/calling_methods_rdoc.html#label-Keyword+Arguments
