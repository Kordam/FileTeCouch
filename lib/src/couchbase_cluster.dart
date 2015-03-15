part of FileTeCouch;


class CouchbaseCluster {
  
  static bool                 ready = false;
  
  static int                  _portCouchbase = 8091;
  static int                  _portMemcached = 11211;
  
  static List<Uri>            _listServersCouchbase = new List();
  static List<SocketAddress>  _listServersMemcached = new List();
  static Map<String, Map<String, String>>  _listBuckets = new Map<String, Map<String, String>>();
  

  
  
  
  static void init(String filename, Map<String, Object> config) {
    _getConfiguration(filename, config);
    ready = true;
  }

  
  
  
  // load the couchbase cluster configuration
  static void _getConfiguration(String filename, Map list) {

    if (filename != null && list != null) {
      // open and read the file
      var file = new File(filename);
      String content = file.readAsStringSync(encoding: ASCII);
      
      // parse the configuration file
      list = loadYaml(content);
    }
    
    if (list == null)
      throw "Bad couchbase configuration file";
    if (list['serverList'] == null || list['serverList'][0] == null)
      throw "Bad couchbase configuration file, you need at least one couchbase instance";
    if (list['bucketList'] == null || list['bucketList'][0] == null)
      throw "Bad couchbase configuration file, you need at least one bucket";
    
    // parse servers host and port
    list['serverList'].forEach((server) {
      if (server["host"] == null || server["host"] is String == false
          || server["portCouchbase"] == null || (server["portCouchbase"] is String == false && server["portCouchbase"] is int == false)
          || server["portMemcached"] == null || (server["portMemcached"] is String == false && server["portMemcached"] is int == false))
        throw "Bad couchbase configuration file - \"" + server.toString() + "\" is invalid";
      
      _addServer(server["host"], server["portCouchbase"].toString(), server["portMemcached"].toString());
    });
    
    // parse buckets name and password
    list['bucketList'].forEach((bucket) {
      if (bucket["bucketName"] == null || bucket["bucketName"] is String == false
          || bucket["password"] == null || bucket["password"] is String == false
          || bucket["bucketType"] == null || bucket["bucketType"] is String == false
       || (bucket["bucketType"] != null && bucket["bucketType"] != "couchbase" && bucket["bucketType"] != "memcached"))
        throw "Bad couchbase configuration file - \"" + bucket.toString() + "\" is invalid";
      
      _addBucket(bucket["bucketName"], bucket["password"], bucket["bucketType"]);
    });
  }

  // add a server in the _listServers attribute
  static void _addServer(String host, String portCouchbase, String portMemcached) {
    _portCouchbase = int.parse(portCouchbase);
    _portMemcached = int.parse(portMemcached);
    
    // + Couchbase
    String hostnameCouchbase = "http://" + host + ":" + portCouchbase + "/pools";
    _listServersCouchbase.add(Uri.parse(hostnameCouchbase));
    
    // + Memcached
    _listServersMemcached.add(new SocketAddress(host, _portMemcached));
  }

  // add a bucket in the _listBuckets attribute
  static void _addBucket(String bucketName, String password, String bucketType) {
    if (bucketType == null)
      bucketType = "couchbase";
    
    _listBuckets[bucketName] = new Map();
    _listBuckets[bucketName]["password"] = password;
    _listBuckets[bucketName]["bucketType"] = bucketType;
  }

  
  
  
  
  
  
  
  static Future connect(String bucket) {
    if (_listBuckets[bucket] == null)
      throw "\"" + bucket + "\": unkown bucket";
    if (_listBuckets[bucket]["bucketType"] == "memcached")
      return _connectMemcachedBucket(bucket);
    return _connectCouchbaseBucket(bucket);
  }
  
  static Future _connectCouchbaseBucket(String bucket) {
    return (CouchClient.connect(_listServersCouchbase, bucket, _listBuckets[bucket]["password"]));
  }
  static Future _connectMemcachedBucket(String bucket) {
    var factory = new SaslBinaryConnectionFactory(bucketName: bucket, password: _listBuckets[bucket]["password"]);
    return (MemcachedClient.connect(_listServersMemcached, factory: factory));
  }
  
  
  
  static String   getBucketType(String bucketName) {
    if (_listBuckets[bucketName] == null)
      return null;
    return _listBuckets[bucketName]["bucketType"];
  }
  
}