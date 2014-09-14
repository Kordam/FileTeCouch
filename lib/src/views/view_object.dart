part of FileTeCouch;

class ViewObject {
  
  String    bucketName;
  String    id = null;
  Object    key = null;
  Object    value = null;
  DBObject  doc = null;
  
  
  ViewObject(String bucket, String idRow, Object keyEmit, Object valueEmit, {DBObject docAttached}) {
    bucketName = bucket;
    id = idRow;
    key = keyEmit;
    value = valueEmit;
    doc = docAttached;
  }
  
  
  
  
  static ViewObject _entryToViewObject(String bucket, ViewRow row) {
    if (row == null)
      return null;

    Object key = row.key == null ? null : JSON.decode(row.key);
    Object value = row.value == null ? null : JSON.decode(row.value);
    DBObject doc = row.doc == null ? null : new DBObject(row.id, JSON.decode(UTF8.decode(row.doc.data)), dbRevision: row.doc.cas);
    return new ViewObject(bucket, row.id, key, value, docAttached: doc);
  }
  static List<ViewObject> entriesToViewObject(String bucket, Iterable<ViewRow> rows) {
    List<ViewObject> ret = new List<ViewObject>();
    
    if (rows == null || rows.isEmpty)
      return ret;
    
    for (ViewRow row in rows)
      ret.add(_entryToViewObject(bucket, row));
    return ret; 
  }
  
  String toString() {
    String ret = "";
    
    ret += "{";
    ret += "id=" + (id != null ? "\"" + id + "\"" : "null");
    ret += ", ";
    ret += "key=" + (key != null ? "\"" + key.toString() + "\"" : "null");
    ret += ", ";
    ret += "value=" + (value != null ? "\"" + value.toString() + "\"" : "null");
    ret += ", ";
    ret += "doc=" + (doc != null ? "\"" + doc.toString() + "\"" : "null");
    ret += "}";
    
    return ret;
  }
  
  /**
   * Return the document put in the map reduce algorythm (by id)
   */
  Future    getDocument() {
    if (doc != null) {
      return new Future(() { return doc; });
    }
      
    FileTeCouch bucket = new FileTeCouch(bucketName);
    return bucket.get(id);
  }
  
}
