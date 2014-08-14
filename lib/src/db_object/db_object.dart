part of FileTeCouch;

class DBObject {
  
  String  key = null;
  Object  value = null;
  int     ttl = null;
  int     revision = null;
  
  
  DBObject(String dbKey, Object dbValue, {int dbTtl: null, int dbRevision: null, String prefixNewId: null}) {
    if (dbKey == null || dbKey == "")
      key = prefixNewId == null ? new DBObjectId().toString() : prefixNewId + "_" + new DBObjectId().toString();
    else
      key = dbKey;
    
    value = dbValue;
    
    ttl = dbTtl;
    revision = dbRevision;
  }
  
  
  
  
  static DBObject entryToDBObject(GetResult row) {
    Object obj = JSON.decode(UTF8.decode(row.data));
    return new DBObject(row.key, obj, dbRevision: row.cas);
  }
  static List<DBObject> entriesToDBObject(List<GetResult> rows) {
    List<DBObject> ret = new List();
    rows.forEach( (GetResult row) {
      ret.add(entryToDBObject(row));
    });
    return ret; 
  }
  
  String toString() {
    String ret = "";
    
    ret += "{";
    ret += "key=" + (key != null ? "\"" + key + "\"" : "null");
    ret += ", ";
    ret += "value=" + (value != null ? "\"" + value + "\"" : "null");
    ret += ", ";
    ret += "ttl=" + (ttl != null ? "\"" + ttl.toString() + "\"" : "unlimited");
    ret += ", ";
    ret += "revision=" + (revision != null ? "\"" + revision.toString() + "\"" : "null");
    ret += "}";
    
    return ret;
  }
  
}
