part of FileTeCouch;

abstract class ABucketAccess {

  String bucket;
  
  ABucketAccess(String bucket) : bucket = bucket {}
      
  Future set(DBObject obj);
  Future get(String key);
  Future getAll(List<String> keys);
  Future delete(String key);
  
  
  Future increment(DBObject obj);
  Future decrement(DBObject obj);
  
  Future getView(String designDocumentName, String viewName, DBQuery query);
  
}



