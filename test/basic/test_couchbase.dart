part of test_file_te_couch;


void test_couchbase_set() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("default");

  test("Set", () {
    DBObject set0 = new DBObject("set0", "value0");
    testBucket.set(set0).then(expectAsync((DBObject ret) {
      expect(ret.key, equals(set0.key));
      expect(ret.value, equals(set0.value));
    }));
  });
  
  test("Set with ttl", () {
    DBObject set0 = new DBObject("set0", "value0", dbTtl: 10);
    var callback = expectAsync(() {});
    testBucket.set(set0).then((DBObject ret) {
      return new Future.delayed(new Duration(seconds: 15), () {
        try {
          testBucket.get(set0.key).then(callback);
        } catch(e) {
          callback();
        }
      });
    });
  });
}

void test_couchbase_get() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("default");

  test("Get", () {
    DBObject set0 = new DBObject("set0", "value0");
    var callback = expectAsync((DBObject ret) {
      expect(ret.key, equals(set0.key));
      expect(ret.value, equals(set0.value));
    });
    testBucket.set(set0).then((DBObject ret) {
      testBucket.get(set0.key).then(callback);
    });
  });
}

void test_couchbase_getAll() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("default");

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

void test_couchbase_increment() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("default");

  test("Increment", () {
    DBObject set0 = new DBObject("set0", 42);
    var callback = expectAsync((int result) {
      expect(result, equals((set0.value as int) + 1));
    });
    testBucket.set(set0).then((DBObject ret) {
      testBucket.increment(new DBObject(set0.key, 1)).then(callback);
    });
  });
}

void test_couchbase_decrement() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("default");

  test("Decrement", () {
    DBObject set0 = new DBObject("set0", 42);
    var callback = expectAsync((int result) {
      expect(result, equals((set0.value as int) - 1));
    });
    testBucket.set(set0).then( (DBObject ret) {
      testBucket.decrement(new DBObject(set0.key, 1)).then(callback);
    });
  });
}

void test_couchbase_delete() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("default");

  test("Delete", () {
    var callback = expectAsync((){});
    testBucket.delete("set0").then((bool result) {
      expect(result, isTrue);
      callback();
    });
  });
}

void test_couchbase_views() {
  CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
    FileTeCouch testBucket = new FileTeCouch("beer-sample");

    test("GetView : Map AND Reduce", () {
      var callback = expectAsync((result) {
        expect(result is DBObject, isTrue);
        expect((result as DBObject).value, equals(1411));
      });
      testBucket.getView("beer", "by_location").then(callback);
    });

    test("GetView : ONLY Map", () {
      DBQuery query = new DBQuery();
      query.reduce = false;
      var callback = expectAsync((result) {
        expect(result is List<ViewObject>, isTrue);
        expect((result as List<ViewObject>).length, equals(1411));
      });
      testBucket.getViewByQuery("beer", "by_location", query).then(callback);
    });

    test("GetView : ONLY Map filtered by keys", () {
      DBQuery query = new DBQuery();
      query.reduce = false;
      query.key = "42";
      var callback = expectAsync((result) {
        expect(result is List<ViewObject>, isTrue);
        expect((result as List<ViewObject>).length, equals(0));
      });
      testBucket.getViewByQuery("beer", "by_location", query).then(callback);
    });
}