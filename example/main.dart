
import "package:FileTeCouch/FileTeCouch.dart";

import "simple.dart";
import "views.dart";

void main() {

  // don't forget to declare you own configuration in the .yaml file here :
  CouchbaseCluster.init("couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("default");
  FileTeCouch beerBucket = new FileTeCouch("beer-sample");
  FileTeCouch memcachedBucket = new FileTeCouch("test_cache");
  
  // pick only one or you will have a lot of answers at the same time on your console ;-)
  simple_setAndGet(testBucket);
  simple_update(testBucket);
  simple_delete(testBucket);
  simple_incrementAndDecrement(testBucket);
  
  views_getView(beerBucket);
  views_getViewTheGetDocument(beerBucket);
  views_getViewByQuery(beerBucket);
  views_getConsistentViewByQuery(beerBucket);
  
  simple_setAndGet(memcachedBucket);
  simple_update(memcachedBucket);
  simple_delete(memcachedBucket);
  simple_incrementAndDecrement(memcachedBucket);  
}