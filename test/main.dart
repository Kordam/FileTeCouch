part of test_file_te_couch;


void test_db_object_id() {
  group('DBObjectId tests =>', () {
    test_db_object_id_basic();
    test_db_object_id_width_prefix();
  });
}

void test_db_object() {
  group('DBObject tests =>', () {
    test_db_object_ctor();
    test_db_object_GetResult_to_DBObject();
  });  
}

void test_couchbase_config() {
  group('Couchbase config tests =>', () {
    test_couchbase_config_server();
    test_couchbase_config_bucket();
    test_couchbase_config_connect();
  });
}

void test_couchbase_basic() {
  group('Basic Couchbase request tests =>', () {
    test_couchbase_set();
//    test_couchbase_get();
    test_couchbase_getAll();
    test_couchbase_delete();
    test_couchbase_increment();
    test_couchbase_decrement();
    test_couchbase_views();
  });
}

void test_memcached_basic() {
  group('Basic Memcached request tests =>', () {
//    test_memcached_set();
//    test_memcached_get();
    test_memcached_getAll();
    test_memcached_delete();
    test_memcached_increment();
    test_memcached_decrement();
    test_memcached_views();
  });
}

void main() {
  test_db_object_id();
  test_db_object();
  test_couchbase_config();
  test_couchbase_basic();
  test_memcached_basic();
}