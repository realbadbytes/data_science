#!/usr/bin/python3

from datetime import datetime
from elasticsearch import Elasticsearch

es = Elasticsearch(['localhost:9200'])

doc = {
    'author': 'kimchy',
    'text': 'Elasticsearch: cool. bonsai cool.',
    'timestamp': datetime.now(),
}

res = es.index(index='test-index', id=1, document=doc)
print(res['result'])

es.indices.refresh(index='test-index')

res = es.search(index='test-index', query={'match_all': {}})
print('Got %d hits:' % res['hits']['total']['value'])
[print('%(timestamp)s %(author)s: %(text)s' % hit['_source']) for hit in res['hits']['hits']]
