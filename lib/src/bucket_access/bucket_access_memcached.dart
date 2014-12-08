part of FileTeCouch;

class BucketAccessMemcached extends ABucketAccess {
  
  BucketAccessMemcached(String bucket) : super(bucket);

  
  Future set(DBObject object) {
    if (object.key == null || object.key == "") {
          throw "FileTeCouch cannot write a value with an empty key";
    }
    return CouchbaseCluster.connect(bucket).then( (MemcachedClient client) {
      return client.set(object.key, UTF8.encode(JSON.encode(object.value)), exptime: object.ttl, cas: object.revision)
        .then((val) {
          if (val == false) {
            throw "FileTeCouch cannot write the object \"" + object.key + "\" in db";
          }
          return object;
        })
        .whenComplete(() => client.close());
    });
  }
  
  Future get(String key) {
    return CouchbaseCluster.connect(bucket).then((MemcachedClient client) {
      return client.gets(key)
        .then((GetResult val) => val)
        .whenComplete(() => client.close());
      })
      .then(DBObject.entryToDBObject);
  }
  
  Future getAll(List<String> keys) {
    return CouchbaseCluster.connect(bucket).then((MemcachedClient client) {
      return client.getsAll(keys).toList()
        .then((val) => val)
        .whenComplete(() => client.close());
      })
      .then(DBObject.entriesToDBObject);
  }
  
  Future delete(String key) {
    return CouchbaseCluster.connect(bucket).then((MemcachedClient client) {
      return client.delete(key)
          .then((val) => val)
          .whenComplete(() => client.close());
    });
  }

  Future increment(DBObject obj) {
    return CouchbaseCluster.connect(bucket).then((MemcachedClient client) {
      return client.increment(obj.key, obj.value)
        .then((val) => val)
        .whenComplete(() => client.close());
    });
  }
  
  Future decrement(DBObject obj) {
    return CouchbaseCluster.connect(bucket).then((MemcachedClient client) {
      return client.decrement(obj.key, obj.value)
        .then((val) => val)
        .whenComplete(() => client.close());
    });
  }
  
  Future getView(String designDocumentName, String viewName, DBQuery query) {
    throw "View are never been implemented in Memcached bucket in Couchbase Server.";
  }
  
}