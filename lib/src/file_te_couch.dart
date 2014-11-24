part of FileTeCouch;

class FileTeCouch {
  
  String          _bucketName = null;
  String          _bucketType = null;
  ABucketAccess   _bucketAccess = null;
  
  // ctor
  FileTeCouch(bucket) {
    if (CouchbaseCluster.ready == false)
      throw "CouchbaseCluster isn't initialized. Call CouchbaseCluster.init('<Filename>.yaml')";

    if (_bucketAccess != null)
      return;
    
    _bucketName = bucket;
    _bucketType = CouchbaseCluster.getBucketType(bucket);
    
    if (_bucketType == "couchbase")
      _bucketAccess = new BucketAccessCouchbase(bucket);
    else if (_bucketType == "memcached")
      _bucketAccess = new BucketAccessMemcached(bucket);
  }
  
  
  /*
   * If [exptime] exceeds 30 days(30x24x60x60), it is
   *   deemed as an absolute date in seconds since epoch time.
   */
  Future set(DBObject object) {
    return _bucketAccess.set(object);
  }

  Future get(String key) {
    return _bucketAccess.get(key);    
  }
  
  Future getAll(List<String> list) {
    return _bucketAccess.getAll(list);
  }

  Future delete(String key) {
    return _bucketAccess.delete(key);    
  }

  
  
  /*
   * Increment and decrement are atomic operations : avoid to meet concurrency problems 
   */
  Future increment(DBObject obj) {
    if (obj.value is num == false)
      throw "FileTeCouch doesn't support this type to increment a value.";
    return _bucketAccess.increment(obj);
  }
  Future decrement(DBObject obj) {
    if (obj.value is num == false)
      throw "FileTeCouch doesn't support this type to decrement a value.";
    return _bucketAccess.decrement(obj);
  }
  
  
  
  /*********************************************************************************
   * Views can be associated to queries. More complex request than key/value storage
   * You can just perform the retrieve operation with a view.
   ********************************************************************************/
  
  
  
  /**
   * Send a query to Couchbase Server for custom map/reduce algorythms
   */
  Future getViewByQuery(String designDocumentName, String viewName, DBQuery query) {
    if (designDocumentName == null || viewName == null
          || designDocumentName == "" || viewName == "")
          throw "FileTeCouch would like return you a result, but we cannot guess the design document name and the view name alone...";
        
    if (viewName.indexOf("dev_") == 0)
      print("FileTeCouch: You're using a view in development mode. Data are not exhaustive");
        
    return _bucketAccess.getView(designDocumentName, viewName, query);
  }
  
  /**
   * Request Couchbase Server to get map/reduce results. Use it carefully : without query, Couchbase Server would return a lot of data !
   * DEPRECATED
   */
  Future getView(String designDocumentName, String viewName) {
    return getViewByQuery(designDocumentName, viewName, new DBQuery());
  }
  
  /**
   * Return Couchbase Server document(s) filtering by key (first emit argument in a view)
   */
  Future getDocumentsByViewResultKey(String designDocumentName, String viewName, String key) {
    DBQuery query = new Query();
    // to retrieve the attached doc at the same time
    query.includeDocs = true;
    // filter by key (first emit argument)
    query.key = JSON.encode(key);
    return getViewByQuery(designDocumentName, viewName, query)
        .then( (List<ViewObject> obj) {
          List<DBObject> ret = new List<DBObject>();
          // select just document in the view result : keys and values doesn't matter here
          for (int i = 0; ret != null && i < obj.length; ++i)
            ret.add(obj[i].doc);
          return ret;
        });
  }

  /**
   * Query a view with up-to-date view cache
   */
  Future getConsistentViewByQuery(String designDocumentName, String viewName, DBQuery query) {
    query.stale = Stale.FALSE;
    return getViewByQuery(designDocumentName, viewName, query);
  }
  
}

