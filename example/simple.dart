part of example;

/**
 * Set a values, get and print
 */
void simple_setAndGet(FileTeCouch testBucket) {
  DBObject objSet0 = new DBObject("simple_setAndGet0", "simple_value0");
  
  testBucket.set(objSet0).then( (DBObject val1) {
    testBucket.get(val1.key).then( (DBObject val2) {
      print(val2.value);
    });
  });
}

/**
 * Set two times the same value (for an update the second time)
 */
void simple_update(FileTeCouch testBucket) {
  DBObject objSet1 = new DBObject("simple_update1", "simple_value1");
  testBucket.set(objSet1).then( (DBObject val) {
    print(val.value);
    val.value = "value2_bis";
    testBucket.set(val).then( (DBObject val) {
      testBucket.get(val.key).then( (DBObject val) {
        print(val.value);
      });
    });
  });
}

/**
 * Set and delete a value delete
 *    + check if the value is deleted
 */
void simple_delete(FileTeCouch testBucket) {
  DBObject objSet2 = new DBObject("simple_set2", "simple_value2");
 testBucket.set(objSet2).then( (DBObject val) {
   testBucket.delete(val.key).then( (isDeleted) {
     testBucket.get(val.key).then( (DBObject val) {
       print(val.key + " isn't deleted");
     }).catchError( (err) {
       print(val.key + " is deleted");
     });
   });
 });
}

/**
 * Create two value and get both at the same time
 */
void simple_getAll(FileTeCouch testBucket) {
  DBObject objGetAll3 = new DBObject("simple_getAll3", "simple_value2");
  DBObject objGetAll4 = new DBObject("simple_getAll4", "simple_value4");
  
  var write1 = testBucket.set(objGetAll3);
  var write2 = testBucket.set(objGetAll4);
  
  Future.wait([write1, write2]).then( (_) {
    testBucket.getAll(["simple_getAll3", "simple_getAll4"]).then( (List<DBObject> val) {
      print(val.toString());
    });
  });
}

/**
 * Create a value, increment of 21 then decrement of 21
 */
void simple_incrementAndDecrement(FileTeCouch testBucket) {
  DBObject objSet4 = new DBObject("simple_incrementAndDecrement4", 21);
  DBObject objIncDec4 = new DBObject("simple_incrementAndDecrement4", 21);
  
  // set a value
  testBucket.set(objSet4).then( (DBObject val) {
    print(val.value);
  }).then( (_) {
    // increment the value
    return testBucket.increment(objIncDec4);
  }).then( (num val) {
    print(val);
    // decrement the value
    return testBucket.decrement(objIncDec4);
  }).then( (num val) {
    print(val);
  });
}
