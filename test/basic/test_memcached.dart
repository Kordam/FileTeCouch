part of test_file_te_couch;


void test_memcached_set() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("memcached-unitTest");

  test("Set", () {
    DBObject set0 = new DBObject("set0", "value0");
    var callback = expectAsync((DBObject ret) {
      expect(ret.key, equals(set0.key));
      expect(ret.value, equals(set0.value));
    });
    testBucket.set(set0).then(callback);
  });
}

void test_memcached_get() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("memcached-unitTest");

  test("Get", () {
    DBObject set0 = new DBObject("set0", "value0");
    var callback = expectAsync((DBObject ret) {
      expect(ret.key, equals(set0.key));
      expect(ret.value, equals(set0.value));
    });
    testBucket.set(set0).then( (DBObject ret) {
      testBucket.get(set0.key).then(callback);
    });
  });
}

void test_memcached_getAll() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("memcached-unitTest");

  test("GetAll", () {
    DBObject set0 = new DBObject("set0", "value0");
    DBObject set1 = new DBObject("set1", "value1");
    var callback = expectAsync((List<DBObject> ret) {
      expect(ret[0].key, equals(set0.key));
      expect(ret[0].value, equals(set0.value));
      expect(ret[1].key, equals(set1.key));
      expect(ret[1].value, equals(set1.value));
    });
    testBucket.set(set0).then( (DBObject ret) {
      return testBucket.set(set1);
    }).then( (_) {
      testBucket.getAll([set0.key, set1.key]).then(callback);
    });
  });  
}

void test_memcached_increment() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("memcached-unitTest");

  test("Increment", () {
    DBObject set0 = new DBObject("set0", 42);
    var callback = expectAsync((int result) {
      expect(result, equals((set0.value as int) + 1));
    });
    testBucket.set(set0).then( (DBObject ret) {
      testBucket.increment(new DBObject(set0.key, 1)).then(callback);
    });
  });
}

void test_memcached_decrement() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("memcached-unitTest");

  test("Decrement", () {
    DBObject set0 = new DBObject("set0", 42);
    var callback = expectAsync((result) {
      expect(result, equals((set0.value as int) - 1));
    });
    testBucket.set(set0).then( (DBObject ret) {
      testBucket.decrement(new DBObject(set0.key, 1)).then(callback);
    });
  });
}

void test_memcached_delete() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("memcached-unitTest");

  test("Delete", () {
    var callback = expectAsync((){});
    testBucket.delete("set0").then((bool result) {
      expect(result, isTrue);
      try {
        testBucket.get("set0").then(callback);
      } catch(e) {
        callback();
      }
    });
  });
}

void test_memcached_views() {
  
}