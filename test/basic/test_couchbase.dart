part of test_file_te_couch;


void test_couchbase_set() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("default");

  test("Set", () {
    DBObject set0 = new DBObject("set0", "value0");
    testBucket.set(set0).then( (DBObject ret) {
      expectAsync( (_) {
        expect(ret.key, equals(set0.key));
        expect(ret.value, equals(set0.value));
      });
    });
  });
  
  test("Set with ttl", () {
    DBObject set0 = new DBObject("set0", "value0", dbTtl: 10);
    testBucket.set(set0).then( (DBObject ret) {
      return new Future.delayed(new Duration(seconds: 11), () { 
        testBucket.get(set0.key).then( (DBObject ret) {
          expectAsync( () {
            expect(ret.key, equals(set0.key));
            expect(ret.value, equals(set0.value));
          });
        });
      });
    });
  });
}

void test_couchbase_get() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("default");

  test("Get", () {
    DBObject set0 = new DBObject("set0", "value0");
    testBucket.set(set0).then( (DBObject ret) {
      testBucket.get(set0.key).then( (DBObject ret) {
        expectAsync( (_) {
          expect(ret.key, equals(set0.key));
          expect(ret.value, equals(set0.value));
        });
      });
    });
  });
}

void test_couchbase_getAll() {
  
}

void test_couchbase_delete() {
  
}

void test_couchbase_increment() {
  
}

void test_couchbase_decrement() {
  
}

void test_couchbase_views() {
  
}