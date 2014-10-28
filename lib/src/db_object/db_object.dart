part of FileTeCouch;

class DBObject {
  
  String  key = null;
  Object  value = null;
  int     revision = null;
  int     _ttl = null;		// write only
  
  /**
   * Readable/writable object in Couchbase Server
   *	- dbKey can be null : create a random key
   *	- dbValue can be a binary value, a value, an object, an array...
   *	- dbTtl (optional) : expiration time in seconds. Cannot exceeds 30 days.
   *	- dbRevision (optional) : optimistic write
   *	- prefixNewId (optional) : if dbKey is NULL, so
   *	  	      dbKey = prefixNewId + "_" + random value
   */
  DBObject(String dbKey, Object dbValue, {int dbTtl: null, int dbRevision: null, String prefixNewId: null}) {
    if (dbKey == null || dbKey == "")
      key = prefixNewId == null ? new DBObjectId().toString() : prefixNewId + "_" + new DBObjectId().toString();
    else
      key = dbKey;
    
    value = dbValue;
    
    _ttl = dbTtl;
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
    ret += "value=" + (value != null ? "\"" + value.toString() + "\"" : "null");
    ret += ", ";
    ret += "_ttl=" + (_ttl != null ? "\"" + _ttl.toString() + "\"" : "unlimited");
    ret += ", ";
    ret += "revision=" + (revision != null ? "\"" + revision.toString() + "\"" : "null");
    ret += "}";
    
    return ret;
  }
  
}
