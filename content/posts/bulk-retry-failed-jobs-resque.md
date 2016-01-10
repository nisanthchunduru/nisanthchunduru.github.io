+++
date = "2015-01-08T14:58:53+05:30"
title = "Bulk retry failed jobs in Resque 1.x"
+++

> Reposted from [SupportBee's Dev Blog](https://devblog.supportbee.com/2015/01/08/retry-subset-of-failed-jobs-in-resque/)

Retrying failed jobs via Resque’s web interface is cumbersome, especially when there are more than a handful of them. So I quickly wrote down a small script that’ll do it for me. 

Open a rails console and copy paste the below snippet

{{< highlight ruby >}}
def retry_if(&should_retry)
  redis = Resque.redis

  (0...Resque::Failure.count).each do |i|
    serialized_job = redis.lindex(:failed, i)
    job = Resque.decode(serialized_job)

    next unless should_retry.(job)
    Resque::Failure.requeue(i)
  end
end
{{< /highlight >}}

To retry a subset of failed jobs, say email notifications that have failed because of smtp errors

{{< highlight ruby >}}
retry_if do |job|
  job['payload']['class'] == 'SendEmailNotifications' &&
  job['exception'] == 'Net::SMTPServerBusy'
end
{{< /highlight >}}

If you want to skip jobs that have already been retried

{{< highlight ruby >}}
retry_if do |job|
  if job['payload']['class'] == 'SendEmailNotifications' && job['exception'] == 'Net::SMTPServerBusy'
    if !job['retried_at']
      next true
    end
  end

  false
end
{{< /highlight >}}

I might eventually move this to a rake task, but that’s a blog post for the future.
