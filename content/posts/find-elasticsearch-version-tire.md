+++
date = "2014-04-22T14:58:53+05:30"
title = "Quickly find elasticsearch version with tire gem"
draft = true
+++

If you use the [tire](https://github.com/karmi/retire) gem in your rails app and wish to quickly find the version of elasticsearch you use, open a rails console and run

```ruby
response = Tire::Configuration.client.get(Tire::Configuration.url)
version = JSON.parse(response.body)['version']
puts version
```
