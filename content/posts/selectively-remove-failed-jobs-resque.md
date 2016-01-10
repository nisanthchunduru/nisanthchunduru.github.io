+++
date = "2014-05-12T14:58:53+05:30"
title = "Selectively remove failed jobs from Resque 1.x"
draft = true
+++

Copy the code snippet below and paste it in a rails console.

{{< highlight ruby >}}
def delete_if
  redis = Resque.redis

  (0...Resque::Failure.count).each do |i|
    string = redis.lindex(:failed, i)
    break if string.nil?

    job = Resque.decode(string)
    remove = yield job
    next unless remove

    redis.lrem(:failed, 1, string)
    redo
  end
end
{{< /highlight >}}

To selectively delete a subset of failed jobs, say we wish delete all push notification jobs that have failed because of http errors, run

{{< highlight ruby >}}
delete_if do |job|
  job['payload']['class'] == 'SendPushNotification' &&
    job['exception'] == 'Pusher::HTTPError'
end
{{< /highlight >}}

in the console.
