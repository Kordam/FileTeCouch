
import "package:FileTeCouch/FileTeCouch.dart";

import "simple.dart";
import "views.dart";

void main() {

  // don't forget to declare you own configuration in the .yaml file here :
  CouchbaseCluster.init("couchbase_cluster.yaml", null);
  FileTeCouch couchbaseBucket = new FileTeCouch("test_couchbase");
  FileTeCouch beerBucket = new FileTeCouch("beer-sample");
  FileTeCouch memcachedBucket = new FileTeCouch("test_memcached");
  
  // pick only one or you will have a lot of answers at the same time on your console ;-)
  simple_setAndGet(couchbaseBucket);
  simple_update(couchbaseBucket);
  simple_delete(couchbaseBucket);
  simple_incrementAndDecrement(couchbaseBucket);
  
  views_getView(beerBucket);
  views_getViewTheGetDocument(beerBucket);
  views_getViewByQuery(beerBucket);
  views_getConsistentViewByQuery(beerBucket);

  simple_setAndGet(memcachedBucket);
  simple_update(memcachedBucket);
  simple_delete(memcachedBucket);
  simple_incrementAndDecrement(memcachedBucket);
}