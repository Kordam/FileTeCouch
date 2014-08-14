part of FileTeCouch;

class FileTeCouch {
  
  String          _bucketName = null;
  String          _bucketType = null;
  ABucketAccess   _bucketAccess = null;
  
  // ctor
  FileTeCouch(bucket) {
    if (CouchbaseCluster.ready == false)
      throw "CouchbaseCluster isn't initialized. Call CouchbaseCluster.init('<Filename>.yaml')";
    
    _bucketName = bucket;
    _bucketType = CouchbaseCluster.getBucketType(bucket);
    
    if (_bucketType == "couchbase")
      _bucketAccess = new BucketAccessCouchbase(bucket);
    else if (_bucketType == "memcached")
      throw "Memcached bucket not supported yet.";
//      _bucketAccess = new BucketAccessMemcached(bucket);
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
  
  
}
