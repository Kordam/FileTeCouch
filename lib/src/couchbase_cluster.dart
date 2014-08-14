part of FileTeCouch;

class CouchbaseCluster {
  
  static bool                 ready = false;
  
  static List<Uri>            _listServers = new List();
  static Map<String, Map<String, String>>  _listBuckets = new Map<String, Map<String, String>>();
  

  
  
  
  static void init(filename) {
    _getConfiguration(filename);
    ready = true;
  }

  
  
  
  // load the couchbase cluster configuration
  static void _getConfiguration(String filename) {
    // open and read the file
    var file = new File(filename);
    String content = file.readAsStringSync(encoding: ASCII);
    
    // parse the configuration file
    var list = loadYaml(content);
    if (list == null)
      throw "Bad couchbase configuration file";
    if (list['serverList'] == null || list['serverList'][0] == null)
      throw "Bad couchbase configuration file, you need at least one couchbase instance";
    if (list['bucketList'] == null || list['bucketList'][0] == null)
      throw "Bad couchbase configuration file, you need at least one bucket";
    
    // parse servers host and port
    list['serverList'].forEach((server) {
      if (server["host"] == null || server["host"] is String == false
       || server["port"] == null || (server["port"] is String == false && server["port"] is int == false))
        throw "Bad couchbase configuration file - \"" + server.toString() + "\" is invalid";
      
      _addServer(server["host"], server["port"].toString());
    });
    
    // parse buckets name and password
    list['bucketList'].forEach((bucket) {
      if (bucket["bucketName"] == null || bucket["bucketName"] is String == false
       || bucket["password"] == null || bucket["password"] is String == false
       || (bucket["bucketType"] != null && bucket["bucketType"] != "couchbase" && bucket["bucketType"] != "memcached"))
        throw "Bad couchbase configuration file - \"" + bucket.toString() + "\" is invalid";
      
      _addBucket(bucket["bucketName"], bucket["password"], bucket["bucketType"]);
    });
  }

  // add a server in the _listServers attribute
  static void _addServer(String host, String port) {
    String hostname = "http://" + host + ":" + port + "/pools";
    _listServers.add(Uri.parse(hostname));
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
    if (_listBuckets[bucket] == null) {
      return new Future( () {
        throw "\"" + bucket + "\": unkown bucket";
      });
    }
    if (_listBuckets[bucket]["bucketType"] == "memcached")
      return _connectMemcachedBucket(bucket);
    return _connectCouchbaseBucket(bucket);
  }
  
  static Future _connectCouchbaseBucket(String bucket) {
    return (CouchClient.connect(_listServers, bucket, _listBuckets[bucket]["password"]));
  }
  static Future _connectMemcachedBucket(String bucket) {
    // @todo
  }
  
  
  
  
  static String   getBucketType(String bucketName) {
    if (_listBuckets[bucketName] == null)
      return null;
    return _listBuckets[bucketName]["bucketType"];
  }
  
}