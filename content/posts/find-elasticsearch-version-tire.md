+++
date = "2014-04-22T14:58:53+05:30"
title = "Quickly find your app's Elasticsearch version with tire gem"
+++

If you use Elasticsearch and the [tire](https://github.com/karmi/retire) gem and wish to quickly find the version of Elasticsearch your rails app uses, open a rails console and run

{{< highlight ruby >}}
response = Tire::Configuration.client.get(Tire::Configuration.url)
version = JSON.parse(response.body)['version']
puts version
{{< /highlight >}}
