part of test_file_te_couch;

void test_couchbase_config_server() {
  test("Can load good config file", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster.yaml"), returnsNormally);
  });
  
  test("Missing file", () {
    expect(() => CouchbaseCluster.init("foo.yaml"), throwsException);
  });
  test("Missing server list", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_serverListError0.yaml"), throwsA(new isInstanceOf<String>()));
  });
  test("No server in the list", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_serverListError4.yaml"), throwsA(new isInstanceOf<String>()));
  });
  
  test("Missing host", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_serverListError1.yaml"), throwsA(new isInstanceOf<String>()));
  });
  test("Missing couchbase port", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_serverListError2.yaml"), throwsA(new isInstanceOf<String>()));
  });
  test("Missing memcached port", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_serverListError3.yaml"), throwsA(new isInstanceOf<String>()));
  });
  
  test("Incorrect server address", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_serverListError5.yaml"), throwsA(new isInstanceOf<String>()));
  });
  test("Incorrect couchbase port", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_serverListError6.yaml"), throwsA(new isInstanceOf<String>()));
  });
  test("Incorrect memcached port", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_serverListError7.yaml"), throwsA(new isInstanceOf<String>()));
  });
}


void test_couchbase_config_bucket() {
  test("Missing bucket list", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_bucketListError0.yaml"), throwsA(new isInstanceOf<String>()));
  });
  test("No bucket in the list", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_bucketListError1.yaml"), throwsA(new isInstanceOf<String>()));
  });
  
  test("Missing bucket name", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_bucketListError2.yaml"), throwsA(new isInstanceOf<String>()));
  });
  test("Missing bucket password", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_bucketListError3.yaml"), throwsA(new isInstanceOf<String>()));
  });
  test("Missing bucket type", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_bucketListError4.yaml"), throwsA(new isInstanceOf<String>()));
  });
  
  test("Incorrect bucket name", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_bucketListError5.yaml"), throwsA(new isInstanceOf<String>()));
  });
  test("Incorrect bucket password", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_bucketListError6.yaml"), throwsA(new isInstanceOf<String>()));
  });
  test("Incorrect bucket type", () {
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_bucketListError7.yaml"), throwsA(new isInstanceOf<String>()));
    expect(() => CouchbaseCluster.init("config/test_couchbase_cluster_bucketListError8.yaml"), throwsA(new isInstanceOf<String>()));
  });
}

void test_couchbase_config_connect() {
  test("Can load good config file and connect to default bucket", () {
    CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
    expect(() => new FileTeCouch("default"), returnsNormally);
  });
  
  test("Cannot connect to unkown bucket", () {
    CouchbaseCluster.init("config/test_couchbase_cluster.yaml");
    expect(() => CouchbaseCluster.connect("edfault"), throwsA(new isInstanceOf<String>()));
  });
}


