
import "package:FileTeCouch/FileTeCouch.dart";

import "simple.dart";

void main() {

  // don't forget to declare you own configuration in the .yaml file here :
  CouchbaseCluster.init("couchbase_cluster.yaml");
  FileTeCouch testBucket = new FileTeCouch("testBucket");
  
  // pick only one or you will have a lot of answers at the same time on you console ;-)
  simple_setAndGet(testBucket);
//  simple_update(testBucket);
//  simple_delete(testBucket);
//  simple_incrementAndDecrement(testBucket);
}