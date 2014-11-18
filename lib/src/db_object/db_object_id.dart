part of FileTeCouch;

class DBObjectIdVar {
  //  @todo: faire un VRAI UUID
  //         in the dart roadmap
  static String UUID = (new Random(new DateTime.now().millisecondsSinceEpoch)).nextInt(10000).toString();
  static int inc = 0;
}





class DBObjectId {
  
  String _id = null;
  
  DBObjectId({String prefix}) {
    _id = "";
    if (prefix != null)
      _id = prefix + "_";
    else {
      // + UUID
      _id += DBObjectIdVar.UUID;
      // + PID
      _id += pid.toString();
      // + timestamp
      _id += new DateTime.now().millisecondsSinceEpoch.toString();
      // + atomic local number
      var tmp = "000" + (DBObjectIdVar.inc++).abs().toString();
      _id += tmp.substring(tmp.length - 4);
    }
  }
  
  String  toString() {
    return _id;
  }
  
}




