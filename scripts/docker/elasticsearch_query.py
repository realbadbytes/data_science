#!/usr/bin/python3

from datetime import datetime
from elasticsearch import Elasticsearch

es = Elasticsearch(['localhost:9200'])

# Doc to add
doc = {
    'author': 'kimchy',
    'text': 'Elasticsearch: cool. bonsai cool.',
    'timestamp': datetime.now(),
}

# Add the doc into index
res = es.index(index='test-index', id=1, document=doc)
print(res['result'])

# Refresh the index before search
# https://www.elastic.co/guide/en/elasticsearch/reference/7.15/indices-refresh.html
es.indices.refresh(index='test-index')

# Execute search for all existing docs in that index
res = es.search(index='test-index', query={'match_all': {}})
print('Got %d hits:' % res['hits']['total']['value'])
[print('%(timestamp)s %(author)s: %(text)s' % hit['_source']) for hit in res['hits']['hits']]
