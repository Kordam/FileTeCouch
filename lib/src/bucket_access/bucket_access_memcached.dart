part of FileTeCouch;

class BucketAccessMemcached extends ABucketAccess {
  
  BucketAccessMemcached(String bucket) : super(bucket);

  
  Future set(DBObject object) {
    if (object.key == null || object.key == "")
          throw "FileTeCouch cannot write a value with an empty key";
        
        return CouchbaseCluster.connect(bucket)
          .then( (MemcachedClient client) {
            return client.set(object.key, UTF8.encode(JSON.encode(object.value)), exptime: object.ttl, cas: object.revision)
                .then( (val) {
                  client.close();
                  
                  if (val == false)
                    throw "FileTeCouch cannot write the object \"" + object.key + "\" in db";
                  
                  return object;
                });
          });
  }
  
  Future get(String key) {
    return CouchbaseCluster.connect(bucket)
          .then( (MemcachedClient client) {
            return client.gets(key)
                .then( (GetResult val) {
                  client.close();
                  return val;
                });
          })
          
          .then(DBObject.entryToDBObject);
  }
  
  Future getAll(String key) {
    return CouchbaseCluster.connect(bucket)
      .then( (MemcachedClient client) {
        return client.gets(key)
            .then( (GetResult val) {
              client.close();
              return val;
            });
      })
      
      .then(DBObject.entryToDBObject);
  }
  
  Future delete(String key) {
    return CouchbaseCluster.connect(bucket)
      .then( (MemcachedClient client) {
        return client.delete(key)
            .then( (val) {
              client.close();
              return val;
            });
      });
  }
  
  

  Future increment(DBObject obj) {
    return CouchbaseCluster.connect(bucket)
          .then( (MemcachedClient client) {
            return client.increment(obj.key, obj.value)
                .then( (val) {
                  client.close();
                  return val;
                });
          });
  }
  
  Future decrement(DBObject obj) {
    return CouchbaseCluster.connect(bucket)
              .then( (MemcachedClient client) {
                return client.decrement(obj.key, obj.value)
                    .then( (val) {
                      client.close();
                      return val;
                    });
              });
  }
  
  Future getView(String designDocumentName, String viewName, DBQuery query) {
    throw "View are never been implemented in Memcached bucket in Couchbase Server.";
  }
  
}