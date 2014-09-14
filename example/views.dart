
import "dart:async";
import "package:FileTeCouch/FileTeCouch.dart";

/**
 * Perform a simple map/reduce algorythm
 */
void views_getView(FileTeCouch beerBucket) {
  beerBucket.getView("beer", "brewery_beers").then( (List<ViewObject> val) {
    for (ViewObject item in val)
      print(item.toString());
  });
}


/**
 * For the 10 first answers :
 *    1- Get view that return ViewObject
 *    2- Manipulate ViewObject
 *    3- Get the document used to generate the map/reduce algorythm
 */
void views_getViewTheGetDocument(FileTeCouch beerBucket) {
  beerBucket.getView("beer", "brewery_beers").then( (List<ViewObject> val) {
    
    for (var i = 0; val != null && i < val.length && i < 10; ++i) {
      ViewObject item = val[i];
      item.getDocument().then( (DBObject doc) {
        print(item.id + " => " + doc.toString());
      });
    }
    
  });
}



/**
 * Perform a map/reduce algorythm with query
 * To know all arguments and their description : 
 *      https://github.com/rikulo/couchclient/blob/master/lib/src/Query.dart
 */
void views_getViewByQuery(FileTeCouch beerBucket) {
  DBQuery query = new DBQuery();
  query.skip(10);
  query.limit(10);
  query.includeDocs = true;
  query.reduce(false);
  
  beerBucket.getViewByQuery("beer", "brewery_beers", query).then( (List<ViewObject> val) {
    for (ViewObject item in val)
      print(item.toString());
  });
}



/**
 * Perform a simple map/reduce algorythm with consistent view cache
 */
void views_getConsistentViewByQuery(FileTeCouch beerBucket) {
  beerBucket.getConsistentViewByQuery("beer", "brewery_beers", new DBQuery()).then( (List<ViewObject> val) {
    for (ViewObject item in val)
      print(item.toString());
  });
}
