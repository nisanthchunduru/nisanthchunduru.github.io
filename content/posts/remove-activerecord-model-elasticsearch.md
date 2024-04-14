+++
date = "2014-04-26T14:58:53+05:30"
title = "Remove ActiveRecord model from ElasticSearch index with tire gem"
draft = true
+++

Say, there is an ActiveRecord model `Ticket`

{{< highlight ruby >}}
class Ticket < ActiveRecord::Base
  include Tire::Model::Search
  # Tire gem setup...
end
{{< /highlight >}}

and a `Ticket` document in ElasticSearch that you wish to delete. To delete the document, copy paste the following code in a rails console

{{< highlight ruby >}}
ticket_id = 1234
document_id = ticket_id
Ticket.index.remove(Ticket.document_type, document_id)
{{< /highlight >}}

This script is quite handy in situations where an ActiveRecord model was deleted from the database but the corresponding document wasn't deleted in Elasticsearch (due to network issues etc.)
