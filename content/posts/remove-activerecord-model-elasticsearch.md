+++
date = "2014-04-26T14:58:53+05:30"
title = "Remove ActiveRecord model from ElasticSearch index with tire gem"
draft = true
+++

Say, we have an ActiveRecord model `Ticket`

```ruby
class Ticket < ActiveRecord::Base
  # Tire setup
  # ...
end
```

If we have a Ticket document in ElasticSearch and wish to delete it, we can do so with its document ID

```ruby
document_id = ticket.id
Ticket.index.remove(Ticket.document_type, document_id)
```

Quite handy if an ActiveRecord model is deleted, but a corresponding delete didn't happen in ElasticSearch (for example, if the delete call to elasticsearch  failed due to network issues etc.)
