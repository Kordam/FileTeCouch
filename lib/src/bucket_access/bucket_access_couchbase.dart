part of FileTeCouch;

class BucketAccessCouchbase extends ABucketAccess {
  
  BucketAccessCouchbase(String bucket) : super(bucket);

  
  
  Future set(DBObject object) {
    if (object.key == null || object.key == "")
      throw "FileTeCouch cannot write a value with an empty key";
    
    return CouchbaseCluster.connect(bucket)
      .then( (CouchClient client) {
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
      .then( (CouchClient client) {
        return client.gets(key)
            .then( (GetResult val) {
              client.close();
              return val;
            });
      })
      
      .then(DBObject.entryToDBObject);
  }
  
  Future getAll(List<String> keys) {
    return CouchbaseCluster.connect(bucket)
      .then( (CouchClient client) {
        return client.getsAll(keys).toList()
            .then( (List<GetResult> val) {
              client.close();
              return val;
            });
    })
    
    .then(DBObject.entriesToDBObject);
  }
  
  Future delete(String key) {
    return CouchbaseCluster.connect(bucket)
      .then( (CouchClient client) {
        return client.delete(key)
            .then( (val) {
              client.close();
              return val;
            });
      });
  }  
  
  
  
  

  Future increment(DBObject obj) {
    return CouchbaseCluster.connect(bucket)
          .then( (CouchClient client) {
            return client.increment(obj.key, obj.value)
                .then( (val) {
                  client.close();
                  return val;
                });
          });
  }
  Future decrement(DBObject obj) {
    return CouchbaseCluster.connect(bucket)
              .then( (CouchClient client) {
                return client.decrement(obj.key, obj.value)
                    .then( (val) {
                      client.close();
                      return val;
                    });
              });
  }
  
  
  
  
  /**
   * Send a query to Couchbase Server for custom map/reduce algorythms
   */
  Future getView(String designDocumentName, String viewName, DBQuery query) {
    return CouchbaseCluster.connect(bucket)
                  .then( (CouchClient client) {
                    return client.getView(designDocumentName, viewName)
                        .then( (View view) {
                          Query query = new Query();
                          return client.query(view, query)
                              .then( (results) {
                                client.close();
                                return (ViewObject.entriesToViewObject(view.bucketName, results.rows));
                              });
                        });
                  });
  }
  
  
}