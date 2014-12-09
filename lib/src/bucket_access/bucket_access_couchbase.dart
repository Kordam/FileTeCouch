part of FileTeCouch;

class BucketAccessCouchbase extends ABucketAccess {

  BucketAccessCouchbase(String bucket) : super(bucket);

  Future set(DBObject object) {
    if (object.key == null || object.key == "") {
      throw "FileTeCouch cannot write a value with an empty key";
    }
    return CouchbaseCluster.connect(bucket).then((CouchClient client) {
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
    return CouchbaseCluster.connect(bucket).then((CouchClient client) {
      return client.gets(key)
          .then((val) => val)
          .whenComplete(() => client.close());
      })
      .then(DBObject.entryToDBObject);
  }

  Future getAll(List<String> keys) {
    return CouchbaseCluster.connect(bucket).then((CouchClient client) {
      return client.getsAll(keys).toList()
        .then((val) => val)
        .whenComplete(() => client.close());
    })
    .then(DBObject.entriesToDBObject);
  }

  Future delete(String key) {
    return CouchbaseCluster.connect(bucket).then((CouchClient client) {
      return client.delete(key)
          .then((val) => val)
          .whenComplete(() => client.close());
    });
  }

  Future increment(DBObject obj) {
    return CouchbaseCluster.connect(bucket).then((CouchClient client) {
      return client.increment(obj.key, obj.value)
        .then((val) => val)
        .whenComplete(() => client.close());
    });
  }

  Future decrement(DBObject obj) {
    return CouchbaseCluster.connect(bucket).then((CouchClient client) {
      return client.decrement(obj.key, obj.value)
        .then((val) => val)
        .whenComplete(() => client.close());
    });
  }

  /**
   * Send a query to Couchbase Server for custom map/reduce algorythms
   */
  Future getView(String designDocumentName, String viewName, DBQuery query) {
    return CouchbaseCluster.connect(bucket).then((CouchClient client) {
      return client.getView(designDocumentName, viewName).then((View view) {
        if (view == null) {
          throw "Unknown view";
        }
        return client.query(view, query)
          .then((results) => (ViewObject.entriesToViewObject(view.bucketName, results.rows)))
          .whenComplete(() => client.close());
        });
    });
  }

}